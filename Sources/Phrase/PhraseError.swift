//
//  PhraseError.swift
//  Phrase
//
//  Created by Philip Niedertscheider on 05.07.20.
//  Copyright © Philip Niedertscheider. All rights reserved.
//

/// Errors which can be thrown during framework usage
public enum PhraseError: Error {

    /// The given expression is empty
    case expressionIsEmpty

    /// A infix operator needs to be in the form of `a ?? b`, but the second parameter was not given
    case infixMissingSecondaryParameter

    /// The type of two nodes differ
    case typesMismatch

    /// A logical type, such as `true` or `false` is expected
    case typesNotLogical

    /// Two types are not comparable
    case typesNotComparable

    /// A string in the expression is not closed
    case missingClosingQuote

    /// A requested variable with the given `name` could not be found in the `context`
    case unknownVariable(name: String)

    /// Type of a value is not supported by the rfamework
    case invalidVariableType(Any)

    /// Found an invalid token inside the expression
    case invalid(token: String)

    /// A unknown operator was found in the expression
    case unknownOperator(name: String)
}
