//
//  ASTNode.swift
//  Phrase
//
//  Created by Philip Niedertscheider on 05.07.20.
//  Copyright © Philip Niedertscheider. All rights reserved.
//

internal indirect enum ASTNode {
    case prefix(op: PrefixOperator, node: ASTNode)
    case infix(op: InfixOperator, lhs: ASTNode, rhs: ASTNode)
    case postfix(op: PostfixOperator, node: ASTNode)

    /// Leave node of AST holding a constant value
    case constant(Constant)
    /// Leave node of AST holding a variable which will be resolved using the context during evaluation
    case variable(Variable)

    func isNotLogical(context: [String: Any]) throws -> Bool {
        switch self {
        case let .constant(value):
            switch value {
            case .true, .false:
                return false
            default:
                return true
            }
        case let .variable(name):
            guard let val = context[name] else {
                return false
            }
            let casted = try Constant.cast(variable: val)
            let isTruthy = try casted == .true
            let isFalsey = try casted == .false
            return !isTruthy && !isFalsey
        case let .prefix(op, _):
            return op != .not
        default:
            return true
        }
    }
}
