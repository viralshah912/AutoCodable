import AutoCodable

@AutoCodable
struct User: Codable {
    let firstName: String
    let lastName: String
    let age: Int
    let state: State
}


@AutoCodable(style: .uppercase)
enum State: String, Codable {
    case active
    case inactive
    case suspended
    case closed
}

@AutoCodable(style: .httpHeader)
struct Headers: Codable {
    let contentType: String?
    let contentSecurityPolicy: String?
    let cacheControl: String?
}
