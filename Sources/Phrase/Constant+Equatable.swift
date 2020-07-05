//
//  Constant+Equatable.swift
//  Phrase
//
//  Created by Philip Niedertscheider on 05.07.20.
//  Copyright © Philip Niedertscheider. All rights reserved.
//

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

func != (lhs: Constant, rhs: Constant) throws -> Bool {
    !(try lhs == rhs)
}

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

private func isNil(rhs: Constant) -> Bool {
    guard case Constant.nil = rhs else {
        return false
    }
    return true
}

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
