//
//  Constant.swift
//  Phrase
//
//  Created by Philip Niedertscheider on 05.07.20.
//  Copyright © Philip Niedertscheider. All rights reserved.
//

/// Represents a constant value in the expression
internal enum Constant {

    // MARK: - Boolean constants

    /// Constant represents a logical fruth value
    case `true`

    /// Constant represents a logical false value
    case `false`

    // MARK: - Nullability constants

    /// Constant represents non-existence
    case `nil`

    // MARK: - Arbitary typed constants

    /// Constant holds a raw string number
    case number(String)

    /// Constant holds a string value
    case string(String)

    /// Constant holds an array of constants
    case array([Constant])

    /// Returns a `Constant` based on the given variable type, or throws if the type is invalid.
    ///
    /// - Parameter variable: Value which should be casted into a `Constant`
    /// - Throws:
    ///     - `PhraseError.invalidVariableType`, if the variable has a unsupported type
    /// - Returns: Constant representing the given variable
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
