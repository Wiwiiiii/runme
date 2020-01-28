/*
 Permet l'uniformité de nos affichages : distance, temps, allure moyenne, vitesse...
 */
//
import Foundation
//
struct FormatDisplay {
  static func distance(_ distance: Double) -> String {
    let distanceMeasurement = Measurement(value: distance, unit: UnitLength.meters)
    return FormatDisplay.distance(distanceMeasurement)
  }
  //
  // On affiche les unités de distance à la française, et non à l'anglaise
  static func distance(_ distance: Measurement<UnitLength>) -> String {
    let formatter = MeasurementFormatter()
    let pays = Locale(identifier: "fr_FR")
    formatter.locale = pays
    return formatter.string(from: distance)
  }
  //
  static func time(_ seconds: Int) -> String {
    let formatter = DateComponentsFormatter()
    formatter.allowedUnits = [.hour, .minute, .second]
    formatter.unitsStyle = .positional
    formatter.zeroFormattingBehavior = .pad
    return formatter.string(from: TimeInterval(seconds))!
  }
  //
  static func pace(distance: Measurement<UnitLength>, seconds: Int, outputUnit: UnitSpeed) -> String {
    let formatter = MeasurementFormatter()
    formatter.unitOptions = [.providedUnit] // 1
    let speedMagnitude = seconds != 0 ? distance.value / Double(seconds) : 0
    let speed = Measurement(value: speedMagnitude, unit: UnitSpeed.metersPerSecond)
    return formatter.string(from: speed.converted(to: outputUnit))
  }
  //
  static func date(_ timestamp: Date?) -> String {
    guard let timestamp = timestamp as Date? else { return "" }
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "fr_FR")
    formatter.dateStyle = .full
    return formatter.string(from: timestamp)
  }
}
