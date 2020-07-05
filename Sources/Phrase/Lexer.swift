//
//   Lexer.swift
//   Phrase
//
//   Created by Philip Niedertscheider on 05.07.20.
//   Copyright © Philip Niedertscheider. All rights reserved.
//

class Lexer: IteratorProtocol {
    let lexems: [Substring]
    var index = 0

    init(lexems: [Substring]) {
        assert(!lexems.isEmpty, "Lexer should have at least one value")
        self.lexems = lexems
    }

    var token: Substring {
        lexems[index]
    }

    func next() -> Substring? {
        guard !isAtEnd else {
            return nil
        }
        let token = lexems[index]
        index += 1
        return token
    }

    var isAtEnd: Bool {
        index >= lexems.count
    }
}
