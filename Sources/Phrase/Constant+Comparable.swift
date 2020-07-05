//
//  Constant+Comparable.swift
//  Phrase
//
//  Created by Philip Niedertscheider on 05.07.20.
//  Copyright © Philip Niedertscheider. All rights reserved.
//

internal func < (lhs: Constant, rhs: Constant) throws -> Bool {
    if case let Constant.number(lhsv) = lhs, case let Constant.number(rhsv) = rhs {
        return lhsv < rhsv
    }
    if case let Constant.string(lhsv) = lhs, case let Constant.string(rhsv) = rhs {
        return lhsv < rhsv
    }
    throw PhraseError.typesMismatch
}

internal func <= (lhs: Constant, rhs: Constant) throws -> Bool {
    let isLower = try lhs < rhs
    let isEqual = try lhs == rhs
    return isLower || isEqual
}

internal func > (lhs: Constant, rhs: Constant) throws -> Bool {
    let isNotLower = !(try lhs < rhs)
    let isNotEqual = !(try lhs == rhs)
    return isNotLower && isNotEqual
}

internal func >= (lhs: Constant, rhs: Constant) throws -> Bool {
    !(try lhs < rhs)
}
