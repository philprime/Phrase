//
//  Evaluator.swift
//  Phrase
//
//  Created by Philip Niedertscheider on 05.07.20.
//  Copyright © Philip Niedertscheider. All rights reserved.
//

class Evaluator {
    private let tree: ASTNode
    private let context: Context

    init(tree: ASTNode, context: Context) {
        self.tree = tree
        self.context = context
    }

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
        // Use lazy evaluation, so the operator can decide if each evaluations is actually necessary
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
