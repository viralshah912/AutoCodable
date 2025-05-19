# 🧩 AutoCodable for Swift

AutoCodable is a Swift macro that automatically generates a CodingKeys enum for your structs and enums, with support for different case transformation styles like snake_case, camelCase, HTTP-Header, and more. It simplifies conformance to Codable by eliminating repetitive boilerplate code.

# ✨ Features
	•	Automatically generates CodingKeys based on your properties or enum cases.
	•	Supports case transformation styles:
	◦	original (no change)
	◦	lowercase
	◦	uppercase
	◦	snake_case
	◦	camelCase
	◦	httpHeader

# 📦 Installation

Note: Requires Swift 5.9+ with macro support.
Add this package to your Package.swift dependencies:
```bash
.package(url: "https://github.com/your-username/AutoCodable.git", from: "1.0.0")
```

And add "AutoCodable" to your target's dependencies.

# 🛠️ Usage

Simply annotate your struct or enum with the @Codable macro:

Example 1: Struct with snake_case style
```swift
import AutoCodable

@Codable(style: .snake_case)
struct User: Codable {
    var firstName: String
    var lastName: String
    var dateOfBirth: String
}
```

This will generate:

```swift
enum CodingKeys: String, CodingKey {
    case firstName = "first_name"
    case lastName = "last_name"
    case dateOfBirth = "date_of_birth"
}
```

Example 2: Enum with httpHeader style

```swift
import AutoCodable

@Codable(style: .httpHeader)
enum HeaderKey: String, Codable {
    case contentType
    case acceptEncoding
}
```

This will generate:

```swift
enum CodingKeys: String, CodingKey {
    case contentType = "Content-Type"
    case acceptEncoding = "Accept-Encoding"
}
```

# 🧠 How It Works

The @Codable macro uses Swift’s macro system to introspect the declarations of your struct or enum and automatically generate a CodingKeys enum with string representations transformed to the specified AutoCodableCaseStyle.

Supported case styles:

| Style        | Description                              |
|--------------|------------------------------------------|
| `.original`  | Keeps the name unchanged                 |
| `.lowercase` | Transforms name to all lowercase         |
| `.uppercase` | Transforms name to all uppercase         |
| `.snake_case`| Transforms to snake_case                 |
| `.camelCase` | Transforms to camelCase                  |
| `.httpHeader`| Transforms to HTTP-Header-Style          |


# 📁 Project Structure

AutoCodableMacro: The macro implementation that inspects and transforms the syntax.

AutoCodablePlugin: Registers the macro plugin.

AutoCodableShared: Contains shared declarations like the @Codable macro and AutoCodableCaseStyle.

# 📋 License

MIT License.
