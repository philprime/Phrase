//
//  Parser.swift
//  Phrase
//
//  Created by Philip Niedertscheider on 05.07.20.
//  Copyright © Philip Niedertscheider. All rights reserved.
//

class Parser {
    let lexer: Lexer
    var stack: [ASTNode] = []

    init(lexer: Lexer) {
        self.lexer = lexer
    }

    var result: ASTNode {
        stack.first!
    }

    internal func parse(token: Substring) throws {
        switch token {
        case "true":
            stack.append(.constant(.true))
        case "false":
            stack.append(.constant(.false))
        case "&&", "||", "==", "!=", ">=", ">", "<", "<=":
            guard let nextToken = lexer.next() else {
                throw PhraseError.infixMissingSecondaryParameter
            }
            try parse(token: nextToken)
            var rhs = stack.popLast()!
            let lhs = stack.popLast()!

            // if rhs is only a variable but not a boolean value, continue
            if token == "&&" || token == "||" {
                if try rhs.isNotLogical(context: [:]), let nextToken = lexer.next() {
                    stack.append(rhs)
                    try parse(token: nextToken)
                    rhs = stack.popLast()!
                }
            }

            guard let op = InfixOperator(rawValue: String(token)) else {
                throw PhraseError.unknownOperator(name: String(token))
            }
            stack.append(.infix(op: op, lhs: lhs, rhs: rhs))
        default:
            // Scan for prefix token
            if token.hasPrefix("!") {
                let subtoken = token.dropFirst()
                try parse(token: subtoken)
                stack.append(.prefix(op: .not, node: stack.popLast()!))
            } else if let number = parseNumber(token: token) {
                stack.append(.constant(number))
            } else if let string = try parseString(token: token, lexer: lexer) {
                stack.append(.constant(string))
            } else if token.hasPrefix("[") {
                // if token ends with quote, it does not contain any spaces and where are done
                var subtoken = token.dropFirst()
                if token.hasSuffix("]") {
                    subtoken = subtoken.dropLast()
                } else {
                    // add tokens until we either run out of tokens, or the closing quote is found
                    repeat {
                        guard let nextToken = lexer.next() else {
                            throw PhraseError.missingClosingQuote
                        }
                        subtoken += nextToken
                    } while !subtoken.hasSuffix("]")
                }
                stack.append(.constant(try parseArray(content: subtoken)))
            } else {
                // Either it is unparsed or it is a variable name
                // Check if name has non-alphanumeric with lowercase, if so it is not a variable name
                if let variable = try Variable.parse(token: token) {
                    stack.append(.variable(variable))
                } else {
                    // functions
                    let keypath = token.split(separator: ".")
                    var keypathStack: [ASTNode] = []
                    // Only count is implemented so far, so we hardcode it
                    for (idx, path) in keypath.enumerated() {
                        if idx == keypath.count - 1, path == "count", keypathStack.count > 0 {
                            guard let prevNode = keypathStack.popLast() else {
                                fatalError()
                            }
                            keypathStack.append(.postfix(op: .count, node: prevNode))
                        } else if let variable = try Variable.parse(token: path) {
                            if keypathStack.count != 0 {
                                fatalError("Did not implement nested variables yet")
                            } else {
                                keypathStack.append(.variable(variable))
                            }
                        } else {
                            fatalError()
                        }
                    }
                    assert(keypathStack.count == 1)
                    stack.append(keypathStack[0])
                }
            }
        }
    }

    private func parseArray(content: Substring) throws -> Constant {
        guard !content.isEmpty else {
            return .array([])
        }
        var values: [Constant] = []
        let lexer = Lexer(lexems: content.split(separator: ","))

        while let token = lexer.next() {
            if let string = try parseString(token: token, lexer: lexer) {
                values.append(string)
            } else if let number = parseNumber(token: token) {
                values.append(number)
            } else {
                throw PhraseError.unknownVariable(name: String(token))
            }
        }

        return .array(values)
    }

    private func parseNumber(token: Substring) -> Constant? {
        guard Int(token) != nil || Float(token) != nil || Double(token) != nil else {
            return nil
        }
        return .number(String(token))
    }

    private func parseString(token: Substring, lexer: Lexer) throws -> Constant? {
        guard token.starts(with: "'") else {
            return nil
        }
        // if token ends with quote, it does not contain any spaces and where are done
        var subtoken = token.dropFirst()
        if subtoken.hasSuffix("'") {
            subtoken = subtoken.dropLast()
        } else {
            // add tokens until we either run out of tokens, or the closing quote is found
            repeat {
                guard let nextToken = lexer.next() else {
                    throw PhraseError.missingClosingQuote
                }
                subtoken += nextToken
            } while !subtoken.hasSuffix("'")
        }
        return .string(String(subtoken))
    }
}
