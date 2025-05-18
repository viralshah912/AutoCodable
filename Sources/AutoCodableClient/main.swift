import AutoCodable

@AutoCodable
struct User: Codable {
    let firstName: String
    let lastName: String
    let age: Int
}
