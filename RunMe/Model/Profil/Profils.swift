import Foundation

struct Profils: Decodable {
  let count: Int
  let all: [Profil]
  
  enum CodingKeys: String, CodingKey {
    case count
    case all = "results"
  }
}
