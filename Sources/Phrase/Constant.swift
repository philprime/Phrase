//
//  Constant.swift
//  Phrase
//
//  Created by Philip Niedertscheider on 05.07.20.
//  Copyright © Philip Niedertscheider. All rights reserved.
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

    internal static func cast(variable: Any) throws -> Constant {
        if let string = variable as? String {
            return .string(string)
        } else if let integer = variable as? Int {
            return .number(String(integer))
        } else if let integer = variable as? Float {
            return .number(String(integer))
        } else if let integer = variable as? Double {
            return .number(String(integer))
        } else if let array = variable as? [Any] {
            return try .array(array.map { value in
                try cast(variable: value)
            })
        }
        throw PhraseError.invalidVariableType(variable)
    }
}
