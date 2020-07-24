//
//  Constant+Comparable.swift
//  Phrase
//
//  Created by Philip Niedertscheider on 05.07.20.
//  Copyright © Philip Niedertscheider. All rights reserved.
//

/// Compares the two given constant.
///
/// To be comparable, both constants need to have the same type.
/// Also only `.number` and `.string` support comparing, therefore comparing any other type will throw an exception.
///
/// - Parameters:
///   - lhs: Base constant to compare
///   - rhs: Other constant to compare
/// - Throws: `PhraseError.typesMismatch`, if the types of the constants differ or are unsupported
/// - Returns: `true` if `lhs` is smaller than `rhs`, otherwise `false`
internal func < (lhs: Constant, rhs: Constant) throws -> Bool {
    if case let Constant.number(lhsv) = lhs, case let Constant.number(rhsv) = rhs {
        return lhsv < rhsv
    }
    if case let Constant.string(lhsv) = lhs, case let Constant.string(rhsv) = rhs {
        return lhsv < rhsv
    }
    throw PhraseError.typesMismatch
}

/// Compares the two given constants.
///
/// To be comparable, both constants need to have the same type.
/// See `==(lhs:,rhs:)` and `<(lhs:rhs:)` for details on type mismatching and exceptions.
///
/// - Parameters:
///   - lhs: Base constant to compare
///   - rhs: Other constant to compare
/// - Throws: `PhraseError.typesMismatch`, if either comparing or equating throwed an exception
/// - Returns: `true` if `lhs` is smaller or equal than `rhs`, otherwise `false`
internal func <= (lhs: Constant, rhs: Constant) throws -> Bool {
    let isLower = try lhs < rhs
    let isEqual = try lhs == rhs
    return isLower || isEqual
}

/// Compares the two given constants.
///
/// To be comparable, both constants need to have the same type.
/// Also only `.number` and `.string` support comparing, therefore comparing any other type will throw an exception.
///
/// - Parameters:
///   - lhs: Base constant to compare
///   - rhs: Other constant to compare
/// - Throws: `PhraseError.typesMismatch`, if the types of the constants differ or are unsupported
/// - Returns: `true` if `lhs` is greater than `rhs`, otherwise `false`
internal func > (lhs: Constant, rhs: Constant) throws -> Bool {
    let isNotLower = !(try lhs < rhs)
    let isNotEqual = !(try lhs == rhs)
    return isNotLower && isNotEqual
}

/// Compares the two given constants.
///
/// To be comparable, both constants need to have the same type.
/// See `==(lhs:,rhs:)` and `>(lhs:rhs:)` for details on type mismatching and exceptions. 
///
/// - Parameters:
///   - lhs: Base constant to compare
///   - rhs: Other constant to compare
/// - Throws: `PhraseError.typesMismatch`, if the types of the constants differ or are unsupported
/// - Returns: `true` if `lhs` is greater or equal than `rhs`, otherwise `false`
internal func >= (lhs: Constant, rhs: Constant) throws -> Bool {
    !(try lhs < rhs)
}
