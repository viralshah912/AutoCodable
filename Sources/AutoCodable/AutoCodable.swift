import AutoCodableShared


@attached(member, names: named(CodingKeys))
public macro Codable(style: AutoCodableCaseStyle = .original) = #externalMacro(module: "AutoCodableMacros", type: "AutoCodableMacro")
