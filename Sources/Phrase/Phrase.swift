//
//  Phrase.swift
//  Phrase
//
//  Created by Philip Niedertscheider on 05.07.20.
//  Copyright © Philip Niedertscheider. All rights reserved.
//

/// Parse and evaluate a boolean expression.
///
/// Expressions consist of an expression string and a `context` to set parameters/replace variables.
///
/// **Example:**
///
///     let expression = try Phrase("list != nil && list.count > 3")
///     expression.context = [
///        "list": [1,2,3,4,5]
///     ]
///     if try expression.evaluate() {
///         ...
///     } else {
///         ...
///     }
public class Phrase: Equatable {

    /// Tree of parsed abstract syntax nodes
    private var tree: ASTNode!

    /// Evaluation context, holding values for variable names
    ///
    /// **Example:**
    ///
    ///     try Phrase("list.count > 3")
    ///     expression.context = [
    ///         "list": [1,2,3,4,5]
    ///     ]
    public var context: Context = [:]

    /// Create a new instance of Phrase based on the given expression.
    ///
    /// Evaluating an Abstract Syntax Tree (AST) consists of three steps:
    /// 1. Finding the lexems (smallest known valid tokens) using a `Lexer` (eg. split by spaces),
    /// 2. Parse the tokens into tree nodes using a `Parser` (e.g. `&&` means logically `and`).
    /// 3. Evaluate the AST tree with optional variable values into a single boolean value using a `Evaluator`.
    ///
    /// Algorithm runs linearly in `O(n)`.
    ///
    /// - Parameter expression: Expression to be converted into a AST
    /// - Throws: `PhraseError`, if the expression is invalid and can not be parsed
    public init(_ expression: String) throws {
        guard !expression.isEmpty else {
            throw PhraseError.expressionIsEmpty
        }
        guard let lexer = Lexer(raw: expression) else {
            return
        }
        let parser = Parser(lexer: lexer)
        while let token = lexer.next() {
            try parser.parse(token: token)
        }
        tree = parser.result
    }

    /// Evaluates the Abstract Syntax Tree (AST) of this expression, using the current context.
    ///
    /// - Throws: if the evaluation fails, see `Evaluator.evaluate` for more details.
    /// - Returns: Boolean result value of the AST based on the current context.
    public func evaluate() throws -> Bool {
        try Evaluator(tree: tree, context: context).evaluate()
    }

    /// Checks if two instances of `Phrase` equal.
    ///
    /// - Parameters:
    ///   - lhs: One instance of `Phrase`
    ///   - rhs: Another instance of `Phrase`
    /// - Returns: `true` if the `tree` and the `context` equal, otherwise `false`
    public static func == (lhs: Phrase, rhs: Phrase) -> Bool {
        guard lhs.tree == rhs.tree else {
            return false
        }
        guard lhs.context.count == rhs.context.count else {
            return false
        }
        return lhs.context == rhs.context
    }
}
