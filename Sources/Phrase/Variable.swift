//
//  Variable.swift
//  Phrase
//
//  Created by Philip Niedertscheider on 05.07.20.
//  Copyright © Philip Niedertscheider. All rights reserved.
//

typealias Variable = String

extension Variable {
    static func parse(token: Substring) throws -> Variable? {
        let alphabet = "abcdefghijklmnopqrstuvwxyz"
        let decimals = "0123456789"
        let symbols = "_"
        let allowedCharacters = alphabet + alphabet.uppercased() + decimals + symbols
        guard token.allSatisfy(allowedCharacters.contains) else {
            return nil
        }
        return Variable(token)
    }
}
