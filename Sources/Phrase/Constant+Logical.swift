//
//   Constant+Logical.swift
//   Phrase
//
//   Created by Philip Niedertscheider on 05.07.20.
//   Copyright © Philip Niedertscheider. All rights reserved.
//

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

func || (lhs: Constant, rhs: Constant) throws -> Bool {
    if try (try lhs == .false) && (try rhs == .false) {
        return false
    }
    if try ((try lhs == .true) || (try lhs == .false)) && ((try rhs == .true) || (try rhs == .false)) {
        return true
    }
    throw PhraseError.typesNotLogical
}
