//
//  Constant+Logical.swift
//  Phrase
//
//  Created by Philip Niedertscheider on 05.07.20.
//  Copyright © Philip Niedertscheider. All rights reserved.
//

/// Checks if the two given constants are either `Constant.true` or `Constant.false`, and if the logical `and` condition is fulfilled.
///
/// The following truth table applys:
///
///       lhs  |  rhs  | result
///     -------|-------|-------
///      true  | true  | true
///      true  | false | false
///      false | true  | false
///      false | false | false
///
/// - Parameters:
///   - lhs: Preceeding constant of operator
///   - rhs: Succeeding constant of operator
/// - Throws:
///   - `PhraseError.typesNotLogical`, if either of the two constants is not a logical one
/// - Returns: `true` or `false`, see the truth table
func && (lhs: Constant, rhs: Constant) throws -> Bool {
    if case Constant.true = lhs, case Constant.true = rhs {
        return true
    }
    if case Constant.true = lhs, case Constant.false = rhs {
        return false
    }
    if case Constant.false = lhs, case Constant.true = rhs {
        return false
    }
    if case Constant.false = lhs, case Constant.false = rhs {
        return false
    }
    throw PhraseError.typesNotLogical
}

/// Checks if the two given constants are either `Constant.true` or `Constant.false`, and if the logical `or` condition is fulfilled.
///
/// The following truth table applys:
///
///       lhs  |  rhs  | result
///     -------|-------|-------
///      true  | true  | true
///      true  | false | true
///      false | true  | true
///      false | false | false
///
/// - Parameters:
///   - lhs: Preceeding constant of operator
///   - rhs: Succeeding constant of operator
/// - Throws:
///   - `PhraseError.typesNotLogical`, if either of the two constants is not a logical one
/// - Returns: `true` or `false`, see the truth table
func || (lhs: Constant, rhs: Constant) throws -> Bool {
    if try (try lhs == .false) && (try rhs == .false) {
        return false
    }
    if try ((try lhs == .true) || (try lhs == .false)) && ((try rhs == .true) || (try rhs == .false)) {
        return true
    }
    throw PhraseError.typesNotLogical
}
