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

    internal func parseInfixOperator(from token: Substring) throws {
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
    }

    internal func parse(token: Substring) throws {
        switch token {
        case "true":
            stack.append(.constant(.true))
        case "false":
            stack.append(.constant(.false))
        case "&&", "||", "==", "!=", ">=", ">", "<", "<=":
            try parseInfixOperator(from: token)
        default:
            try parseUnknown(token: token)
        }
    }

    func parseUnknown(token: Substring) throws {
        // Scan for prefix token
        if token.hasPrefix("!") {
            try parse(token: token.dropFirst())
            stack.append(.prefix(op: .not, node: stack.popLast()!))
        } else if let number = parseNumber(token: token) {
            stack.append(.constant(number))
        } else if let string = try parseString(token: token, lexer: lexer) {
            stack.append(.constant(string))
        } else if token.hasPrefix("[") {
            try parseArrayToken(token: token)
        } else if let variable = Variable.parse(token: token) {
            // Check if name has non-alphanumeric with lowercase, if so it is not a variable name
            stack.append(.variable(variable))
        } else {
            try parseKeyPath(token: token)
        }
    }

    private func parseArrayToken(token: Substring) throws {
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
        stack.append(.constant(try parseArrayContent(content: subtoken)))
    }

    private func parseArrayContent(content: Substring) throws -> Constant {
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
                throw PhraseError.invalid(token: String(token))
            }
        }

        return .array(values)
    }

    private func parseKeyPath(token: Substring) throws {
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
            } else if let variable = Variable.parse(token: path) {
                if keypathStack.count != 0 {
                    fatalError("Did not implement nested variables yet")
                } else {
                    keypathStack.append(.variable(variable))
                }
            } else {
                throw PhraseError.invalid(token: String(token))
            }
        }
        assert(keypathStack.count == 1)
        stack.append(keypathStack[0])
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
