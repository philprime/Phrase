//
//  Parser.swift
//  Phrase
//
//  Created by Philip Niedertscheider on 05.07.20.
//  Copyright © Philip Niedertscheider. All rights reserved.
//

class Parser {
    let lexer: Lexer
    let stack: [ASTNode]

    init(lexer: Lexer, stack: inout [ASTNode]) {
        self.lexer = lexer
        self.stack = stack
    }
}
