//
//  PhraseError.swift
//  Phrase
//
//  Created by Philip Niedertscheider on 05.07.20.
//  Copyright © Philip Niedertscheider. All rights reserved.
//

enum PhraseError: Error {
    case expressionIsEmpty
    case infixMissingSecondaryParameter
    case typesMismatch
    case typesNotLogical
    case typesNotComparable
    case missingClosingQuote
    case unknownVariable(name: String)
    case invalidVariableType(Any)
    case invalid(token: String)

    case unknownOperator(name: String)
}
