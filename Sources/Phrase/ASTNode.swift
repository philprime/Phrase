//
//  ASTNode.swift
//  Phrase
//
//  Created by Philip Niedertscheider on 05.07.20.
//  Copyright © Philip Niedertscheider. All rights reserved.
//

internal indirect enum ASTNode: Equatable {
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

    // MARK: - Equatable

    /// Recrusively comparse both nodes first by its type and then by  the value it might hold.
    ///
    /// - Parameters:
    ///   - lhs: Base node to test for equality
    ///   - rhs: Other node to to test for equality
    /// - Returns: if equals `true`, otherwise `false`
    public static func == (lhs: ASTNode, rhs: ASTNode) -> Bool {
        if case ASTNode.prefix(let lhsOp, let lhsNode) = lhs, case ASTNode.prefix(let rhsOp, let rhsNode) = rhs {
            return lhsOp == rhsOp && lhsNode == rhsNode
        } else if case ASTNode.infix(let lhsOp, let lhsLNode, let lhsRNode) = lhs, case ASTNode.infix(let rhsOp, let rhsLNode, let rhsRNode) = rhs {
            return lhsOp == rhsOp && lhsLNode == rhsLNode && lhsRNode == rhsRNode
        } else if case ASTNode.postfix(let lhsOp, let lhsNode) = lhs, case ASTNode.postfix(let rhsOp, let rhsNode) = rhs {
            return lhsOp == rhsOp && lhsNode == rhsNode
        } else if case ASTNode.constant(let lhsValue) = lhs, case ASTNode.constant(let rhsValue) = rhs {
            return (try? lhsValue == rhsValue) ?? false
        } else if case ASTNode.variable(let lhsVar) = lhs, case ASTNode.variable(let rhsVar) = rhs {
            return lhsVar == rhsVar
        }
        return false
    }
}
