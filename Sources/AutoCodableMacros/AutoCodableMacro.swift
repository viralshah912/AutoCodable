import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

@main
struct AutoCodablePlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        AutoCodableMacro.self
    ]
}

public struct AutoCodableMacro: MemberMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf decl: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard let structDecl = decl.as(StructDeclSyntax.self) else { return [] }

        var codingKeys: [String] = []

        for member in structDecl.memberBlock.members {
            guard
                let varDecl = member.decl.as(VariableDeclSyntax.self),
                let binding = varDecl.bindings.first,
                let pattern = binding.pattern.as(IdentifierPatternSyntax.self)
            else { continue }

            let propertyName = pattern.identifier.text
            let snakeCase = convertToSnakeCase(propertyName)

            if snakeCase != propertyName {
                codingKeys.append("case \(propertyName) = \"\(snakeCase)\"")
            } else {
                codingKeys.append("case \(propertyName)")
            }
        }

        let codingKeyDecl = """
        enum CodingKeys: String, CodingKey {
            \(codingKeys.joined(separator: "\n    "))
        }
        """

        return [DeclSyntax(stringLiteral: codingKeyDecl)]
    }

    private static func convertToSnakeCase(_ input: String) -> String {
        var result = ""
        for char in input {
            if char.isUppercase {
                result += "_" + char.lowercased()
            } else {
                result += String(char)
            }
        }
        return result
    }
}

