//
//  Variable.swift
//  Phrase
//
//  Created by Philip Niedertscheider on 05.07.20.
//  Copyright © Philip Niedertscheider. All rights reserved.
//

/// Variables are currently only raw strings
typealias Variable = String

extension Variable {

    /// If the given token is a valid variable name (not containing illegal characters), a new variable is returned.
    ///
    /// Variable names can contain case-insensitive alphanumeric characters and underscores.
    /// Any other character is considered illegal
    ///
    /// - Parameter token: Base for variable check.
    /// - Returns: `Variable` if the given `token` only contains valid characters, otherwise `nil`.
    static func parse(token: Substring) -> Variable? {
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
