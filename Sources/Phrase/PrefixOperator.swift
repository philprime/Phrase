//
//  PrefixOperator.swift
//  Phrase
//
//  Created by Philip Niedertscheider on 05.07.20.
//  Copyright © Philip Niedertscheider. All rights reserved.
//

/// Single operators which are set before an expression node.
///
/// Prefix operators require only a single succeeding node to be applied.
internal enum PrefixOperator {

    /// Inverts the evaluation result
    case not

    /// Applys itself on the given boolean value
    ///
    /// The evaluation depends on the operator:
    /// - `not`: Inverts the value, e.g. `true --> false` 
    ///
    /// - Parameter value: Base value for evaluation
    /// - Returns: Depending on the operator, either `true` or `false`
    func evaluate(value: Bool) -> Bool {
        switch self {
        case .not:
            return !value
        }
    }
}
