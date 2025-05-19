import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import AutoCodableShared


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
        if let structDecl = decl.as(StructDeclSyntax.self) {
            return try generateCodingKeys(for: structDecl, style: getCaseStyle(from: node))
        } else if let enumDecl = decl.as(EnumDeclSyntax.self) {
            return try generateCodingKeys(for: enumDecl, style: getCaseStyle(from: node))
        }
        return []
    }
    
    private static func getCaseStyle(from node: AttributeSyntax) -> AutoCodableCaseStyle {
        guard
            let arguments = node.arguments?.as(LabeledExprListSyntax.self),
            let styleArg = arguments.first(where: { $0.label?.text == "style" }),
            let value = styleArg.expression.as(MemberAccessExprSyntax.self)?.declName.baseName.text,
            let style = AutoCodableCaseStyle(rawValue: value)
        else {
            return .original
        }
        
        return style
    }
    
    private static func generateCodingKeys(for structDecl: StructDeclSyntax, style: AutoCodableCaseStyle) throws -> [DeclSyntax] {
        var codingKeys: [String] = []
        
        for member in structDecl.memberBlock.members {
            guard
                let varDecl = member.decl.as(VariableDeclSyntax.self),
                let binding = varDecl.bindings.first,
                let pattern = binding.pattern.as(IdentifierPatternSyntax.self)
            else { continue }
            
            let propertyName = pattern.identifier.text
            let transformed = transform(propertyName, to: style)
            
            if transformed != propertyName {
                codingKeys.append("case \(propertyName) = \"\(transformed)\"")
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
    
    private static func generateCodingKeys(for enumDecl: EnumDeclSyntax, style: AutoCodableCaseStyle) throws -> [DeclSyntax] {
        var codingKeys: [String] = []
        
        for member in enumDecl.memberBlock.members {
            guard let caseDecl = member.decl.as(EnumCaseDeclSyntax.self) else { continue }
            
            for elem in caseDecl.elements {
                let caseName = elem.name.text
                let transformed = transform(caseName, to: style)
                
                if transformed != caseName {
                    codingKeys.append("case \(caseName) = \"\(transformed)\"")
                } else {
                    codingKeys.append("case \(caseName)")
                }
            }
        }
        
        let codingKeyDecl = """
            enum CodingKeys: String, CodingKey {
                \(codingKeys.joined(separator: "\n    "))
            }
            """
        
        return [DeclSyntax(stringLiteral: codingKeyDecl)]
    }
    
    private static func transform(_ name: String, to style: AutoCodableCaseStyle) -> String {
        switch style {
        case .original:
            return name
        case .lowercase:
            return name.lowercased()
        case .uppercase:
            return name.uppercased()
        case .snake_case:
            return camelToSnake(name)
        case .camelCase:
            return name.prefix(1).lowercased() + name.dropFirst()
        case .httpHeader:
            return camelToHttpHeader(name)
        }
    }
    
    private static func camelToSnake(_ input: String) -> String {
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
    
    private static func camelToHttpHeader(_ input: String) -> String {
        var result = ""
        for char in input {
            if char.isUppercase {
                result += "-" + String(char)
            } else {
                result += String(char)
            }
        }
        // Capitalize each component
        return result
            .split(separator: "-")
            .map { $0.prefix(1).uppercased() + $0.dropFirst() }
            .joined(separator: "-")
    }
}
