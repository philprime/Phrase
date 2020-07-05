//
//  Phrase.swift
//  Phrase
//
//  Created by Philip Niedertscheider on 05.07.20.
//  Copyright © Philip Niedertscheider. All rights reserved.
//

public class Phrase {
    private var tree: ASTNode!
    public var context: Context = [:]

    public init(_ expression: String) throws {
        guard !expression.isEmpty else {
            throw PhraseError.expressionIsEmpty
        }
        let lexems = expression.lowercased().split(separator: " ")
        guard !lexems.isEmpty else {
            return
        }
        let lexer = Lexer(lexems: lexems)
        let parser = Parser(lexer: lexer)
        while let token = lexer.next() {
            try parser.parse(token: token)
        }
        tree = parser.result
    }

    public func evaluate() throws -> Bool {
        try Evaluator(tree: tree, context: context).evaluate()
    }
}
