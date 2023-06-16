import Foundation

struct Users: Decodable {
    let items: [Inform]
}

struct Inform: Decodable {
    let login: String
    let avatar_url: String
    let html_url: String
}
