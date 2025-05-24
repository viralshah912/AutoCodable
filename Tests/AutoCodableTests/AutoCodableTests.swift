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
            @Codable(style: .original)
            struct CardResponse: Codable {
                let data: CardData
                let message: String?
            }
            """,
            expandedSource: """
            struct CardResponse: Codable {
                let data: CardData
                let message: String?

                enum CodingKeys: String, CodingKey {
                    case data
                    case message
                }
            }
            """,
            macros: testMacros
        )
    }

    func testCardDataSnakeCase() {
        assertMacroExpansion(
            """
            @Codable(style: .snake_case)
            struct CardData: Codable {
                let creditCards: [CreditCard]
                let debitCards: [DebitCard]
            }
            """,
            expandedSource: """
            struct CardData: Codable {
                let creditCards: [CreditCard]
                let debitCards: [DebitCard]

                enum CodingKeys: String, CodingKey {
                    case creditCards = "credit_cards"
                    case debitCards = "debit_cards"
                }
            }
            """,
            macros: testMacros
        )
    }

    func testCreditCardSnakeCase() {
        assertMacroExpansion(
            """
            @Codable(style: .snake_case)
            struct CreditCard: Codable {
                let cardIdentifier: String
                let cardNo: String
                let availableCredit: Double
                let usedCredit: Double
                let totalCredit: Double
                let rewards: Reward
            }
            """,
            expandedSource: """
            struct CreditCard: Codable {
                let cardIdentifier: String
                let cardNo: String
                let availableCredit: Double
                let usedCredit: Double
                let totalCredit: Double
                let rewards: Reward

                enum CodingKeys: String, CodingKey {
                    case cardIdentifier = "card_identifier"
                    case cardNo = "card_no"
                    case availableCredit = "available_credit"
                    case usedCredit = "used_credit"
                    case totalCredit = "total_credit"
                    case rewards
                }
            }
            """,
            macros: testMacros
        )
    }

    func testRewardOriginal() {
        assertMacroExpansion(
            """
            @Codable(style: .original)
            struct Reward: Codable {
                let type: String
                let points: Double
            }
            """,
            expandedSource: """
            struct Reward: Codable {
                let type: String
                let points: Double

                enum CodingKeys: String, CodingKey {
                    case type
                    case points
                }
            }
            """,
            macros: testMacros
        )
    }

    func testDebitCardSnakeCase() {
        assertMacroExpansion(
            """
            @Codable(style: .snake_case)
            struct DebitCard: Codable {
                let cardIdentifier: String
                let cardNo: String
                let expiryDate: String
                let cvv: String
                let cardHolder: String
            }
            """,
            expandedSource: """
            struct DebitCard: Codable {
                let cardIdentifier: String
                let cardNo: String
                let expiryDate: String
                let cvv: String
                let cardHolder: String

                enum CodingKeys: String, CodingKey {
                    case cardIdentifier = "card_identifier"
                    case cardNo = "card_no"
                    case expiryDate = "expiry_date"
                    case cvv
                    case cardHolder = "card_holder"
                }
            }
            """,
            macros: testMacros
        )
    }
}
