import AutoCodableShared


@attached(member, names: named(CodingKeys))
public macro AutoCodable(style: AutoCodableCaseStyle = .original) = #externalMacro(module: "AutoCodableMacros", type: "AutoCodableMacro")
