import AutoCodable

@Codable
struct User: Codable {
    let firstName: String
    let lastName: String
    let age: Int
    let state: State
}


@Codable(style: .uppercase)
enum State: String, Codable {
    case active
    case inactive
    case suspended
    case closed
}

@Codable(style: .httpHeader)
struct Headers: Codable {
    let contentType: String?
    let contentSecurityPolicy: String?
    let cacheControl: String?
}

@Codable(style: .original)
struct CardResponse: Codable {
    let data: CardData
    let message: String?
}

@Codable(style: .snake_case)
struct CardData: Codable {
    let creditCards: [CreditCard]
    let debitCards: [DebitCard]
}

@Codable(style: .snake_case)
struct CreditCard: Codable {
    let cardIdentifier: String
    let cardNo: String
    let availableCredit: Double
    let usedCredit: Double
    let totalCredit: Double
    let rewards: Reward
}

@Codable(style: .original)
struct Reward: Codable {
    let type: String
    let points: Double
}

@Codable(style: .snake_case)
struct DebitCard: Codable {
    let cardIdentifier: String
    let cardNo: String
    let expiryDate: String
    let cvv: String
    let cardHolder: String
}
