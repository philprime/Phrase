//
//  Lexer.swift
//  Phrase
//
//  Created by Philip Niedertscheider on 05.07.20.
//  Copyright © Philip Niedertscheider. All rights reserved.
//

/// A Lexer is used to iterate the so/called lexems, tokens in a string, basically an iterator.
class Lexer: IteratorProtocol {

    /// Lexems to iterate
    private let lexems: [Substring]

    /// Current iterator position
    private var index = 0

    /// Creates a new Lexer by tokenizing the given expression string.
    ///
    /// If the given expression is empty, or contains only empty characters (such as spaces),
    /// `nil` is returned, indicating no further parsing is necessary
    ///
    /// - Parameter expression: Expression used to tokenize and lex
    convenience init?(raw expression: String) {
        let lexems = expression.lowercased().split(separator: " ")
        guard !lexems.isEmpty else {
            return nil
        }
        self.init(lexems: lexems)
    }

    /// Creates a new Lexer for iterating the given lexems.
    /// - Parameter lexems: Tokens to iterate
    init(lexems: [Substring]) {
        assert(!lexems.isEmpty, "Lexer should have at least one value")
        self.lexems = lexems
    }

    /// Returns the currently selected lexem, does not modify the cursor position.
    var token: Substring {
        lexems[index]
    }

    /// Returns the currently selected lexem and moves the cursor to the nex position.
    func next() -> Substring? {
        guard !isAtEnd else {
            return nil
        }
        let token = lexems[index]
        index += 1
        return token
    }

    /// Returns truthy value if the end is reached, therefore all elements were iterated.
    var isAtEnd: Bool {
        index >= lexems.count
    }
}
