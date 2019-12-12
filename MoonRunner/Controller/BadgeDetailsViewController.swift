

import UIKit

class BadgeDetailsViewController: UIViewController {
  
  @IBOutlet weak var badgeImageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var distanceLabel: UILabel!
  @IBOutlet weak var earnedLabel: UILabel!
  @IBOutlet weak var bestLabel: UILabel!
  @IBOutlet weak var silverLabel: UILabel!
  @IBOutlet weak var goldLabel: UILabel!
  @IBOutlet weak var silverImageView: UIImageView!
  @IBOutlet weak var goldImageView: UIImageView!
  
  var status: BadgeStatus!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let badgeRotation = CGAffineTransform(rotationAngle: .pi / 8)
    
    badgeImageView.image = UIImage(named: status.badge.imageName)
    nameLabel.text = status.badge.name
    distanceLabel.text = FormatDisplay.distance(status.badge.distance)
    let earnedDate = FormatDisplay.date(status.earned?.timestamp)
    earnedLabel.text = "Obtenu le : \(earnedDate)"
    
    let bestDistance = Measurement(value: status.best!.distance, unit: UnitLength.meters)
    let bestPace = FormatDisplay.pace(distance: bestDistance,
                                      seconds: Int(status.best!.duration),
                                      outputUnit: UnitSpeed.minutesPerKilometer)
    let bestDate = FormatDisplay.date(status.earned?.timestamp)
    bestLabel.text = "Meilleure course : \(bestPace), \(bestDate)"
    
    let earnedDistance = Measurement(value: status.earned!.distance, unit: UnitLength.meters)
    let earnedDuration = Int(status.earned!.duration)
    
    if let silver = status.silver {
      silverImageView.transform = badgeRotation
      silverImageView.alpha = 1
      let silverDate = FormatDisplay.date(silver.timestamp)
      silverLabel.text = "Obtenu le : \(silverDate)"
    } else {
      silverImageView.alpha = 0
      let silverDistance = earnedDistance * BadgeStatus.silverMultiplier
      let pace = FormatDisplay.pace(distance: silverDistance,
                                    seconds: earnedDuration,
                                    outputUnit: UnitSpeed.minutesPerKilometer)
      silverLabel.text = "Moyenne < \(pace) pour la médaille d'argent ! "
    }
    
    if let gold = status.gold {
      goldImageView.transform = badgeRotation
      goldImageView.alpha = 1
      let goldDate = FormatDisplay.date(gold.timestamp)
      goldLabel.text = "Obtenu le : \(goldDate)"
    } else {
      goldImageView.alpha = 0
      let goldDistance = earnedDistance * BadgeStatus.goldMultiplier
      let pace = FormatDisplay.pace(distance: goldDistance,
                                    seconds: earnedDuration,
                                    outputUnit: UnitSpeed.minutesPerKilometer)
      goldLabel.text = "Moyenne < \(pace) pour la médaille d'or ! "
    }
  }
  
  @IBAction func infoButtonTapped() {
    let alert = UIAlertController(title: status.badge.name,
                                  message: status.badge.information,
                                  preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .cancel))
    present(alert, animated: true)
  }
}
