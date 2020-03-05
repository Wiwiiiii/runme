/*
 importe CoreLocation : permet de récupérer la localisation
 */
import UIKit
import CoreLocation
import MapKit
import AVFoundation
import Alamofire
import SwiftyJSON

class NewRunViewController: UIViewController {

  @IBOutlet weak var launchPromptStackView: UIStackView!
  @IBOutlet weak var dataStackView: UIStackView!
  @IBOutlet weak var startButton: UIButton!
  @IBOutlet weak var stopButton: UIButton!
  @IBOutlet weak var distanceLabel: UILabel!
  @IBOutlet weak var timeLabel: UILabel!
  @IBOutlet weak var paceLabel: UILabel!
  @IBOutlet weak var mapContainerView: UIView!
  @IBOutlet weak var mapView: MKMapView!
  @IBOutlet weak var badgeStackView: UIStackView!
  @IBOutlet weak var badgeImageView: UIImageView!
  @IBOutlet weak var badgeInfoLabel: UILabel!
  @IBOutlet weak var caloriesLabel: UILabel!

  private var run: Run?

  // Objet que l'on va utiliser pour commencer et arrêter les services de localisation de l'application
  private let locationManager = LocationManager.shared
  // Track la durée de la course en secondes
  private var seconds = 0
  // S'actualise à chaque seconde et met à jour l'écran
  private var timer: Timer?
  // Gère la durée totale de la course
  private var distance = Measurement(value: 0, unit: UnitLength.kilometers)
  // Tableau stockant tous les objets CLLocation pendant la course
  private var locationList: [CLLocation] = []
  private var upcomingBadge: Badge!

  // Un son est produit quand l'utilisateur arrive à compléter un défi/badge
  private let successSound: AVAudioPlayer = {
    guard let successSound = NSDataAsset(name: "success") else {
      return AVAudioPlayer()
    }
    return try! AVAudioPlayer(data: successSound.data)
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    dataStackView.isHidden = true
    badgeStackView.isHidden = true
  }

  // Permet de mettre en pause la mise à jour de la localisation+le timer quand l'utilisateur est en dehors de cette vue
  // Cela évite la surconsommation de la batterie du téléphone
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    timer?.invalidate()
    locationManager.stopUpdatingLocation()
  }

  // Commence la course
  @IBAction func startTapped() {
    startRun()
  }

  struct CourseVarGlobales {
      static var IDCourse = 0
  }
  // Termine la course
  // Permet de sauvegarder cette course ou non dans l'historique
  @IBAction func stopTapped() {
    let alertController = UIAlertController(title: "Terminer la course ?",
                                            message: "Voulez-vous vraiment mettre fin à cette course ?",
                                            preferredStyle: .actionSheet)
    alertController.addAction(UIAlertAction(title: "Annuler", style: .cancel))
    alertController.addAction(UIAlertAction(title: "Sauvegarder", style: .default) { _ in
      self.stopRun()
      // Sauvegarde dans la BDD
      self.saveRun()
      self.performSegue(withIdentifier: .details, sender: nil)
    })
    alertController.addAction(UIAlertAction(title: "Rejeter", style: .destructive) { _ in
      // Pas de sauvegarde comme il ne veut pas la garder dans son historique
      self.stopRun()
      _ = self.navigationController?.popToRootViewController(animated: true)
    })

    let castDistance = String(self.distanceLabel.text!)
    print("Distance:" + castDistance)
    let castDistanceReplace = castDistance.replacingOccurrences(of: "km ?", with: "", options: [.caseInsensitive, .regularExpression])
    let castDistanceReplace2 = castDistanceReplace.replacingOccurrences(of: "Distance: ?", with: "", options: [.caseInsensitive, .regularExpression])
    let castDistanceReplace3 = castDistanceReplace2.replacingOccurrences(of: ", ?", with: ".", options: [.caseInsensitive, .regularExpression])
    let castDistanceReplace4 = castDistanceReplace3.replacingOccurrences(of: " ?", with: "", options: [.caseInsensitive, .regularExpression])
    print("DistanceReplace:" + castDistanceReplace4)
    //var castDistance2 = String(self.distanceLabel.text ?? "")
    //print("Distance2:" + castDistance2)
    let castTemps = String(self.timeLabel.text!)
    print("Temps:" + castTemps)
    let castVitesse = String(self.paceLabel.text!)
    print("Vitesse:" + castVitesse)
    let castVitesseReplace = castVitesse.replacingOccurrences(of: "km/h ?", with: "", options: [.caseInsensitive, .regularExpression])
    let castVitesseReplace2 = castVitesseReplace.replacingOccurrences(of: "Vitesse: ?", with: "", options: [.caseInsensitive, .regularExpression])
    let castVitesseReplace3 = castVitesseReplace2.replacingOccurrences(of: " ?", with: "", options: [.caseInsensitive, .regularExpression])
    print("VitesseReplace:" + castVitesseReplace3)
    let castCalories = String(self.caloriesLabel.text!)
    print("Calories:" + castCalories)
    let castCaloriesReplace = castCalories.replacingOccurrences(of: "kcal ?", with: "", options: [.caseInsensitive, .regularExpression])
    let castCaloriesReplace2 = castCaloriesReplace.replacingOccurrences(of: "Calories : ?", with: "", options: [.caseInsensitive, .regularExpression])
    let castCaloriesReplace3 = castCaloriesReplace2.replacingOccurrences(of: " ?", with: "", options: [.caseInsensitive, .regularExpression])
    print("CaloriesReplace:" + castCaloriesReplace3)
    CourseVarGlobales.IDCourse+=1
    let castIDCourse = String(CourseVarGlobales.IDCourse)
    print(castIDCourse)
    print(CourseVarGlobales.IDCourse)
    // swiftlint:disable line_length
    AF.request("http://149.91.89.160:500/graphql?query=mutation%7B%20%20%20%20createCourse(%0A%20%20%20%20id%3A%20"+castIDCourse+"%2C%0A%20%20%20%20userid%3A%200%2C%0A%20%20%20%20distance%3A%20"+castDistanceReplace4+"%2C%0A%20%20%20%20temps%3A%20"+castTemps+"%2C%0A%20%20%20%20calories%3A%2050%2C%0A%20%20%20%20vitesse%3A%202.5%2C%0A%20%20)%0A%20%20%7B%0A%20%20%20%20%20%20id%2C%0A%20%20%20%20userid%2C%0A%20%20%20%20distance%2C%0A%20%20%20%20temps%2C%0A%20%20%20%20calories%2C%0A%20%20%20%20vitesse%0A%20%20%7D%0A%7D", method: .post, encoding: JSONEncoding.default)
        .responseJSON { response in
            if let valueSafe = response.value {
                let json = JSON(valueSafe)
            } else {
                print ("erreur dans le create de la course")
            }
    }
    // swiftlint:enable line_length
    present(alertController, animated: true)
  }

// MARK: - Fonctions de début et d'arrêt de course
  private func startRun() {
    // On cache ou non des boutons/éléments de l'interface
    launchPromptStackView.isHidden = true
    dataStackView.isHidden = false
    startButton.isHidden = true
    stopButton.isHidden = false
    mapContainerView.isHidden = false
    mapView.removeOverlays(mapView.overlays)

    // Cela réinitialise toutes les valeurs à mettre à jour pendant l'exécution à leur état initial
    // Démarre le timer qui se déclenche chaque seconde et commence à collecter les mises à jour d'emplacement.
    seconds = 0
    distance = Measurement(value: 0, unit: UnitLength.meters)
    locationList.removeAll()

    // Montre le premier badge à gagner
    badgeStackView.isHidden = false
    upcomingBadge = Badge.next(for: 0)
    badgeImageView.image = UIImage(named: upcomingBadge.imageName)
    updateDisplay()
    timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
      self.eachSecond()
    }
    startLocationUpdates()
  }

  private func stopRun() {
    // On cache les boutons/éléments de l'interface
    launchPromptStackView.isHidden = false
    dataStackView.isHidden = true
    startButton.isHidden = false
    stopButton.isHidden = true
    mapContainerView.isHidden = true

    // Les informations de badge doivent être cachées entre les courses
    badgeStackView.isHidden = true

    // Quand l'utilisateur a finit sa course, on veut arrêter de tracker sa position
    locationManager.stopUpdatingLocation()
  }

  // Fonction appelée chanque seconde par le timer
  func eachSecond() {
    seconds += 1
    checkNextBadge()
    updateDisplay()
  }
  // MARK: - Fonction de mise à jour des données sur l'écran
  // Met à jour l'affichage des données sur l'écran, en accord avec avec ce que l'on a fait dans FormatDisplay.swift
  private func updateDisplay() {
    let formattedDistance = FormatDisplay.distance(distance)
    let formattedTime = FormatDisplay.time(seconds)
    let formattedPace = FormatDisplay.pace(distance: distance,
                                           seconds: seconds,
                                           outputUnit: UnitSpeed.kilometersPerHour)
    let poidsFixe = 60.0
    let formattedCalories = (poidsFixe * Double(seconds) * 0.01)
    caloriesLabel.text = "Calories : \(formattedCalories) kcal"
    distanceLabel.text = "Distance:  \(formattedDistance)"
    timeLabel.text = "Temps:  \(formattedTime)"
    paceLabel.text = "Vitesse:  \(formattedPace)"

    // Garde l'utilisateur à jour sur le prochain badge à gagner
    let distanceRemaining = upcomingBadge.distance - distance.value
    let formattedDistanceRemaining = FormatDisplay.distance(distanceRemaining)
    badgeInfoLabel.text = "\(formattedDistanceRemaining) avant \(upcomingBadge.name)"
  }
  // MARK: - Fonction de mise à jour de la position
  // Reçoit et procède à la MaJ de la localisation
  private func startLocationUpdates() {
    locationManager.delegate = self
    //activityType : aide l'application à consommer moins pendant la course de l'utilisateur
    locationManager.activityType = .fitness
    // La distance horizontale minimale, en mètres, que l'appareil
    //doit parcourir avant d'émettre une mise à jour de position.
    locationManager.distanceFilter = 10
    // Démarre la MaJ
    locationManager.startUpdatingLocation()
  }
  // MARK: - Fonction de sauvegarde de la course
  // Permet de sauvegarder la course de l'utilisateur en BDD
  private func saveRun() {
    let newRun = Run(context: CoreDataStack.context)
    newRun.distance = distance.value
    newRun.duration = Int16(seconds)
    newRun.timestamp = Date()

    for location in locationList {
      let locationObject = Location(context: CoreDataStack.context)
      locationObject.timestamp = location.timestamp
      locationObject.latitude = location.coordinate.latitude
      locationObject.longitude = location.coordinate.longitude
      newRun.addToLocations(locationObject)
    }

    CoreDataStack.saveContext()

    run = newRun
  }

  // Détecte lorsqu'un badge a été obtenu, met à jour l'interface utilisateur pour afficher le prochain badge
  // Emet un son de succès pour célébrer la fin d'un badge.
  private func checkNextBadge() {
    let nextBadge = Badge.next(for: distance.value)
    if upcomingBadge != nextBadge {
      badgeImageView.image = UIImage(named: nextBadge.imageName)
      upcomingBadge = nextBadge
      successSound.play()
      AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
  }
}
// MARK: - Navigation
extension NewRunViewController: SegueHandlerType {
  enum SegueIdentifier: String {
    case details = "RunDetailsViewController"
  }
  //
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    switch segueIdentifier(for: segue) {
    case .details:
      let destination = segue.destination as! RunDetailsViewController
      destination.run = run
    }
  }
}
// MARK: - Location Manager Delegate
// Cette méthode est appelée à chaque fois que CoreLocation met à jour la localisation de l'utilisateur
// Informations contenus dans ce tableau : latitude, longitude, timestamp..
// On attend un peu que l'utilisateur bouge avant de mettre à jour les données
// de localisation, afin de ne pas avoir trop de données erronées

extension NewRunViewController: CLLocationManagerDelegate {

  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    for newLocation in locations {
      let howRecent = newLocation.timestamp.timeIntervalSinceNow
      guard newLocation.horizontalAccuracy < 20 && abs(howRecent) < 10 else { continue }

      if let lastLocation = locationList.last {
        let delta = newLocation.distance(from: lastLocation)

        // Impossibilité d'utiliser += avec Measurement
        // swiftlint:disable shorthand_operator
        distance = distance + Measurement(value: delta, unit: UnitLength.meters)
        // swiftlint:enable shorthand_operator

        // coordonées et region
        // Permettent d'ajouter le segment blue sur la map et de faire la MaJ de cette map pour la garder
        // Focus sur le lieu où l'utilisateur fait sa course
        let coordinates = [lastLocation.coordinate, newLocation.coordinate]
        mapView.addOverlay(MKPolyline(coordinates: coordinates, count: 2))
        let region = MKCoordinateRegion.init(center: newLocation.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(region, animated: true)
      }

      locationList.append(newLocation)
    }
  }
}

// MARK: - Map View Delegate
// Permet de faire en rendu pour les lignes sur la carte
// La ligne est de base bleu pendant la course sur la map
extension NewRunViewController: MKMapViewDelegate {
  func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
    guard let polyline = overlay as? MKPolyline else {
      return MKOverlayRenderer(overlay: overlay)
    }
    let renderer = MKPolylineRenderer(polyline: polyline)
    renderer.strokeColor = .blue
    renderer.lineWidth = 3
    return renderer
  }
}
