//
//  InfixOperator.swift
//  Phrase
//
//  Created by Philip Niedertscheider on 05.07.20.
//  Copyright © Philip Niedertscheider. All rights reserved.
//

internal enum InfixOperator: String {

    // MARK: Logic operators

    /// Binary AND
    case and = "&&"
    /// Binary OR
    case or = "||"

    // MARK: Equatable

    /// Checks if both sides are the same
    case equals = "=="
    /// Checks if both sides are not the same
    case inequals = "!="

    // MARK: Comparable

    case greater = ">"
    case greaterThan = ">="
    case lower = "<"
    case lowerThan = "<="

    /// Evaluates the infix operator with the two given constants.
    ///
    /// Given constants are lazily evalutated, in case the right hand side depends on the left hand side, e.g.
    /// ```
    /// array != nil && array.count > 0
    /// ```
    ///
    /// - Parameters:
    ///   - lhs: Closure returning the first operation parameter
    ///   - rhs: Closure returning the second operation parameter
    /// - Throws: `PhraseError.typesMismatch`, if the two constant can not operate together
    /// - Returns: Evaluation result
    func evaluate(lhs: () throws -> Constant, rhs: () throws -> Constant) throws -> Bool {
        switch self {
        case .and:
            // AND: Only evaluate right hand side if left hand side is true, otherwise it will always fail anyways
            guard case Constant.true = try lhs() else {
                return false
            }
            return try rhs() == .true
        case .or:
            return try lhs() || rhs()

        case .equals:
            return try lhs() == rhs()
        case .inequals:
            return try lhs() != rhs()

        case .greater:
            return try lhs() > rhs()
        case .greaterThan:
            return try lhs() >= rhs()
        case .lower:
            return try lhs() < rhs()
        case .lowerThan:
            return try lhs() <= rhs()
        }
    }
}
