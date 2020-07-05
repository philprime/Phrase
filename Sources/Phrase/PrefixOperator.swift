//
//  PrefixOperator.swift
//  Phrase
//
//  Created by Philip Niedertscheider on 05.07.20.
//  Copyright © Philip Niedertscheider. All rights reserved.
//

internal enum PrefixOperator {
    /// Inverts the evaluation result
    case not

    func evaluate(value: Bool) -> Bool {
        switch self {
        case .not:
            return !value
        }
    }
}
