//
//  Evaluator.swift
//  Phrase
//
//  Created by Philip Niedertscheider on 05.07.20.
//  Copyright © Philip Niedertscheider. All rights reserved.
//

/// Evaluates an Abstract Syntax Tree (AST) based on the given data context.
class Evaluator {

    /// Tree of parsed abstract syntax nodes
    private var tree: ASTNode!

    /// Evaluation context, holding values for variable names
    ///
    /// **Example:**
    ///
    ///     evaluator.context = [
    ///         "list": [1,2,3,4,5]
    ///     ]
    public var context: Context = [:]

    /// Creates a new instance of Evaluator for evaluating the given `tree` using the values in the given `context`
    ///
    /// - Parameters:
    ///   - tree: Abstract Syntax Tree
    ///   - context: Context holding named values
    init(tree: ASTNode, context: Context) {
        self.tree = tree
        self.context = context
    }

    /// Evaluates the AST by inverse recursively evaluating the root node of the tree
    ///
    /// - Throws:
    ///    - `PhraseError`, if something went wrong
    /// - Returns: `true` if the evaluation result equals `Constant.true`, otherwise `false`
    internal func evaluate() throws -> Bool {
        try evaluate(node: tree) == .true
    }

    private func evaluate(node: ASTNode) throws -> Constant {
        switch node {
        case let .prefix(op, node):
            return try evaluate(prefixOp: op, node: node)
        case let .infix(op, lhs, rhs):
            return try evaluate(infixOp: op, lhs: lhs, rhs: rhs)
        case let .postfix(op, node):
            return try evaluate(postfixOp: op, node: node)
        case let .constant(constant):
            return constant
        case let .variable(variable):
            return try evaluate(variable: variable)
        }
    }

    private func evaluate(prefixOp: PrefixOperator, node: ASTNode) throws -> Constant {
        switch prefixOp {
        case .not:
            return try evaluate(node: node) == .true ? .false : .true
        }
    }

    private func evaluate(infixOp: InfixOperator, lhs: ASTNode, rhs: ASTNode) throws -> Constant {
        let evaluatedLhs: () throws -> Constant = { try self.evaluate(node: lhs) }
        let evaluatedRhs: () throws -> Constant = { try self.evaluate(node: rhs) }
        // Use lazy evaluation, so the operator can decide if each evaluations are actually necessary
        return try infixOp.evaluate(lhs: evaluatedLhs, rhs: evaluatedRhs) ? .true : .false
    }

    private func evaluate(postfixOp: PostfixOperator, node: ASTNode) throws -> Constant {
        switch postfixOp {
        case .count:
            guard case let ASTNode.variable(variable) = node else {
                throw PhraseError.invalidVariableType(node)
            }
            guard let variableData = context[variable] else {
                throw PhraseError.unknownVariable(name: variable)
            }
            guard case let Constant.array(array) = try Constant.cast(variable: variableData) else {
                throw PhraseError.typesMismatch
            }
            return .number(array.count.description)
        }
    }

    private func evaluate(variable: Variable) throws -> Constant {
        guard let value = context[variable] else {
            return .nil
        }
        return try Constant.cast(variable: value)
    }
}
