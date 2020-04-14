import SwiftSyntax

extension DeclSyntaxProtocol {

    var name: String? {
        switch self {
        case let syntax as ClassDeclSyntax:
            return syntax.identifier.withoutTrivia().text
        case let syntax as EnumDeclSyntax:
            return syntax.identifier.withoutTrivia().text
        case let syntax as ExtensionDeclSyntax:
            return syntax.extendedType.description.trimmed
        case let syntax as ProtocolDeclSyntax:
            return syntax.identifier.withoutTrivia().text
        case let syntax as StructDeclSyntax:
            return syntax.identifier.withoutTrivia().text
        default:
            return nil
        }
    }

    var ancestors: [DeclSyntaxProtocol] {
        guard let context = context else { return [] }
        return Array(sequence(first: context, next: { $0.context }))
    }

    var ancestorsName: String? {
        return ancestors.compactMap { $0.name }.reversed().joined(separator: ".").nonEmpty
    }
}

extension SyntaxProtocol {

    var context: DeclSyntaxProtocol? {
        for case let node? in sequence(first: parent, next: { $0?.parent }) {
            guard let declaration = node.asProtocol(DeclSyntaxProtocol.self) else { continue }
            return declaration
        }

        return nil
    }
}
