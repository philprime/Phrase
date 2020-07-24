//
//  PostfixOperator.swift
//  Phrase
//
//  Created by Philip Niedertscheider on 05.07.20.
//  Copyright © Philip Niedertscheider. All rights reserved.
//

/// Single operators which are set after an expression node.
///
/// Postfix operators require only a single preceding node to be applied.
enum PostfixOperator {

    // MARK: Array operators

    /// Returns the amount of elements of a given array
    case count
}
