//
//   ASTNode.swift
//   Phrase
//
//   Created by Philip Niedertscheider on 05.07.20.
//   Copyright © Philip Niedertscheider. All rights reserved.
//

internal indirect enum ASTNode {
    case prefix(op: PrefixOperator, node: ASTNode)
    case infix(op: InfixOperator, lhs: ASTNode, rhs: ASTNode)
    case postfix(op: PostfixOperator, node: ASTNode)

    /// Leave node of AST holding a constant value
    case constant(Constant)
    /// Leave node of AST holding a variable which will be resolved using the context during evaluation
    case variable(Variable)
}
