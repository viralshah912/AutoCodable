import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(AutoCodableMacros)
import AutoCodableMacros
#endif

import AutoCodableShared
import AutoCodable

let testMacros: [String: Macro.Type] = [
    "Codable": AutoCodableMacro.self,
]

final class AutoCodableTests: XCTestCase {
    
    func testSnakeCaseGeneration() {
        assertMacroExpansion(
                """
                @Codable(style: .snake_case)
                struct User: Codable {
                    let firstName: String
                    let lastName: String
                    let age: Int
                    let state: State
                }
                """,
                expandedSource: """
                struct User: Codable {
                    let firstName: String
                    let lastName: String
                    let age: Int
                    let state: State
                
                    enum CodingKeys: String, CodingKey {
                        case firstName = "first_name"
                        case lastName = "last_name"
                        case age
                        case state
                    }
                }
                """,
                macros: testMacros
        )
    }
    
    func testUpperCaseEnumCase() {
        assertMacroExpansion(
                """
                @Codable(style: .uppercase)
                enum State: String, Codable {
                    case active
                    case inactive
                    case suspended
                    case closed
                }
                """,
                expandedSource: """
                enum State: String, Codable {
                    case active
                    case inactive
                    case suspended
                    case closed
                
                    enum CodingKeys: String, CodingKey {
                        case active = "ACTIVE"
                        case inactive = "INACTIVE"
                        case suspended = "SUSPENDED"
                        case closed = "CLOSED"
                    }
                }
                """,
                macros: testMacros
        )
    }
    
    func testCamelCaseStyle() {
        assertMacroExpansion(
                """
                @Codable(style: .camelCase)
                struct LoginData: Codable {
                    let UserID: String
                    let SessionToken: String
                }
                """,
                expandedSource: """
                struct LoginData: Codable {
                    let UserID: String
                    let SessionToken: String
                
                    enum CodingKeys: String, CodingKey {
                        case UserID = "userID"
                        case SessionToken = "sessionToken"
                    }
                }
                """,
                macros: testMacros
        )
    }
    
    func testHttpHeaderStyle() {
        assertMacroExpansion(
                """
                @Codable(style: .httpHeader)
                struct Headers: Codable {
                    let contentType: String?
                    let contentSecurityPolicy: String?
                    let cacheControl: String?
                }
                """,
                expandedSource: """
                struct Headers: Codable {
                    let contentType: String?
                    let contentSecurityPolicy: String?
                    let cacheControl: String?
                
                    enum CodingKeys: String, CodingKey {
                        case contentType = "Content-Type"
                        case contentSecurityPolicy = "Content-Security-Policy"
                        case cacheControl = "Cache-Control"
                    }
                }
                """,
                macros: testMacros
        )
    }
    
    func testOriginalStyle() {
        assertMacroExpansion(
                """
                @Codable
                struct OriginalStyle: Codable {
                    let name: String
                    let age: Int
                }
                """,
                expandedSource: """
                struct OriginalStyle: Codable {
                    let name: String
                    let age: Int
                
                    enum CodingKeys: String, CodingKey {
                        case name
                        case age
                    }
                }
                """,
                macros: testMacros
        )
    }
}
