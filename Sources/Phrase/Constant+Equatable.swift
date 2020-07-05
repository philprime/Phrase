//
//   Constant+Equatable.swift
//   Phrase
//
//   Created by Philip Niedertscheider on 05.07.20.
//   Copyright © Philip Niedertscheider. All rights reserved.
//

func == (lhs: Constant, rhs: Constant) throws -> Bool {
    switch lhs {
    case .true:
        switch rhs {
        case .true:
            return true
        case .false,
             .nil:
            return false
        default:
            throw PhraseError.typesMismatch
        }
    case .false:
        switch rhs {
        case .false:
            return true
        case .true,
             .nil:
            return false
        default:
            throw PhraseError.typesMismatch
        }
    case .nil:
        switch rhs {
        case .nil:
            return true
        default:
            return false
        }
    case let .number(lhsValue):
        switch rhs {
        case let .number(rhsValue):
            return lhsValue == rhsValue
        case .nil:
            return false
        default:
            throw PhraseError.typesMismatch
        }
    case let .string(lhsValue):
        switch rhs {
        case let .string(rhsValue):
            return lhsValue == rhsValue
        case .nil:
            return false
        default:
            throw PhraseError.typesMismatch
        }
    case let .array(lhsValues):
        switch rhs {
        case let .array(rhsValues):
            guard lhsValues.count == rhsValues.count else {
                return false
            }
            return try lhsValues.enumerated().allSatisfy { element -> Bool in
                try element.element == rhsValues[element.offset]
            }
        case .nil:
            return false
        default:
            throw PhraseError.typesMismatch
        }
    }
}

func != (lhs: Constant, rhs: Constant) throws -> Bool {
    !(try lhs == rhs)
}
