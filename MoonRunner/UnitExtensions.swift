/*
 Permet d'étendre la classe UnitSpeed, afin de pouvoir gérer le concep d'allure moyenne, qui n'est pas implanté directement dans xCode
 Exemple d'allure moyenne : min/km, sec/metre
 */
 

import Foundation

// Calculs de math permettant de convertir le concept de vitesse (km/min) en allure moyenne (min/km)

class UnitConverterPace: UnitConverter {
  private let coefficient: Double
  
  init(coefficient: Double) {
    self.coefficient = coefficient
  }
  
  override func baseUnitValue(fromValue value: Double) -> Double {
    return reciprocal(value * coefficient)
  }
  
  override func value(fromBaseUnitValue baseUnitValue: Double) -> Double {
    return reciprocal(baseUnitValue * coefficient)
  }
  
  private func reciprocal(_ value: Double) -> Double {
    guard value != 0 else { return 0 }
    return 1.0 / value
  }
}


/*
 La classe UnitSpeed est implementée de base dans Fundation, mais n'accepte que par défaut les meters/second
 On étend cette classe afin d'y ajouter sec/m, min/km et min/mi (pour les anglais)
*/
extension UnitSpeed {
  class var secondsPerMeter: UnitSpeed {
    return UnitSpeed(symbol: "sec/m", converter: UnitConverterPace(coefficient: 1))
  }
  
  class var minutesPerKilometer: UnitSpeed {
    return UnitSpeed(symbol: "min/km", converter: UnitConverterPace(coefficient: 60.0 / 1000.0))
  }
  
  class var minutesPerMile: UnitSpeed {
    return UnitSpeed(symbol: "min/mi", converter: UnitConverterPace(coefficient: 60.0 / 1609.34))
  }
}
