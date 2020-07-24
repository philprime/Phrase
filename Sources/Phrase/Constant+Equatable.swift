//
//  Constant+Equatable.swift
//  Phrase
//
//  Created by Philip Niedertscheider on 05.07.20.
//  Copyright © Philip Niedertscheider. All rights reserved.
//

/// Checks the two given constants for equality.
///
/// - Parameters:
///   - lhs: Base constant to equate
///   - rhs: Other constant to equate
/// - Throws:
///    - `PhraseError.typesMismatch`, if the two constants are of different type, and can not be equated.
/// - Returns: `true`, if the two constants are the same, otherwise `false`
func == (lhs: Constant, rhs: Constant) throws -> Bool {
    switch lhs {
    case .true:
        return try equalsTruthyBoolean(rhs: rhs)
    case .false:
        return try equalsFalseyBoolean(rhs: rhs)
    case .nil:
        return isNil(rhs: rhs)
    case let .number(lhsValue):
        return try equalsNumber(rhs: rhs, number: lhsValue)
    case let .string(lhsValue):
        return try equalsString(rhs: rhs, string: lhsValue)
    case let .array(lhsValues):
        return try equalsArray(rhs: rhs, values: lhsValues)
    }
}

/// Checks the two given constants for inequality.
///
/// - Parameters:
///   - lhs: Base constant to equate
///   - rhs: Other constant to equate
/// - Throws: If equating the two constants fails, see `==(lhs:rhs:)` for details
/// - Returns: `true`, if the two constants differ, otherwise `false`
func != (lhs: Constant, rhs: Constant) throws -> Bool {
    !(try lhs == rhs)
}

/// Checks if `rhs` is truth constant
private func equalsTruthyBoolean(rhs: Constant) throws -> Bool {
    switch rhs {
    case .true:
        return true
    case .false,
         .nil:
        return false
    default:
        throw PhraseError.typesMismatch
    }
}

/// Checks if `rhs` is false constant
private func equalsFalseyBoolean(rhs: Constant) throws -> Bool {
    switch rhs {
    case .false:
        return true
    case .true,
         .nil:
        return false
    default:
        throw PhraseError.typesMismatch
    }
}

/// Checks if `rhs` is a nil constant
private func isNil(rhs: Constant) -> Bool {
    guard case Constant.nil = rhs else {
        return false
    }
    return true
}

/// Checks if `rhs` is a number and if the value equals
private func equalsNumber(rhs: Constant, number: String) throws -> Bool {
    switch rhs {
    case let .number(other):
        return number == other
    case .nil:
        return false
    default:
        throw PhraseError.typesMismatch
    }
}

/// Checks if `rhs` is an string and if the value equals
private func equalsString(rhs: Constant, string: String) throws -> Bool {
    switch rhs {
    case let .string(other):
        return string == other
    case .nil:
        return false
    default:
        throw PhraseError.typesMismatch
    }
}

/// Checks if `rhs` is an array and if the elements equals
private func equalsArray(rhs: Constant, values: [Constant]) throws -> Bool {
    switch rhs {
    case let .array(other):
        guard values.count == other.count else {
            return false
        }
        return try values.enumerated().allSatisfy { element -> Bool in
            try element.element == other[element.offset]
        }
    case .nil:
        return false
    default:
        throw PhraseError.typesMismatch
    }
}
