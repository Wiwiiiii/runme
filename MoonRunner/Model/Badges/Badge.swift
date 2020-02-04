import Foundation

// Définit la structure du badge et fournit un initialiseur disponible pour extraire les informations de l'objet JSON
struct Badge {
  let name: String
  let imageName: String
  let information: String
  let distance: Double

  init?(from dictionary: [String: String]) {
    guard
      let name = dictionary["name"],
      let imageName = dictionary["imageName"],
      let information = dictionary["information"],
      let distanceString = dictionary["distance"],
      let distance = Double(distanceString)
    else {
        return nil
    }
    self.name = name
    self.imageName = imageName
    self.information = information
    self.distance = distance
  }

  // Utilisation des données JSON et flatMap pour supprimer toutes les structures qui ne parviennent pas à s'initialiser.
  // allBadges est déclaré statique afin que l'opération d'analyse ne se produise qu'une seule fois.
  static let allBadges: [Badge] = {
    guard let fileURL = Bundle.main.url(forResource: "badges", withExtension: "txt") else {
      fatalError("No badges.txt file found")
    }
    do {
      let jsonData = try Data(contentsOf: fileURL, options: .mappedIfSafe)
      let jsonResult = try JSONSerialization.jsonObject(with: jsonData) as! [[String: String]]
      return jsonResult.compactMap(Badge.init)
    } catch {
      fatalError("Cannot decode badges.txt")
    }
  }()

  // Chacune de ces méthodes filtre la liste des badges selon qu'ils ont été gagnés ou ne sont pas encore gagnés.

  static func best(for distance: Double) -> Badge {
    return allBadges.filter { $0.distance < distance }.last ?? allBadges.first!
  }
  
  static func next(for distance: Double) -> Badge {
    return allBadges.filter { distance < $0.distance }.first ?? allBadges.last!
  }
}

// MARK: - Equatable

extension Badge: Equatable {
  static func ==(lhs: Badge, rhs: Badge) -> Bool {
    return lhs.name == rhs.name
  }
}
