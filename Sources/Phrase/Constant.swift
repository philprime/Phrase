//
//   Constant.swift
//   Phrase
//
//   Created by Philip Niedertscheider on 05.07.20.
//   Copyright © Philip Niedertscheider. All rights reserved.
//

internal enum Constant {
    // Boolean constants
    case `true`
    case `false`

    // Nullability constants
    case `nil`

    // Arbitary typed constants
    case number(String)
    case string(String)
    case array([Constant])
}
