import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class ProfilTableViewController: UITableViewController {

  // Liaison interface - controller

  override func viewDidLoad() {
    super.viewDidLoad()
     // swiftlint:disable line_length

      // swiftlint:enable line_length
    loadSampleProfils()
  }

  var profils = [Profil]()

  private func loadSampleProfils() {

    let profil1 = Profil(sexe: "Homme", taille: 1.20, nom: "Caprese Salad", age: 15, prenom: "Tanguy", email: "wiwi@gmail.com", poids: 4.5)

    let profil2 = Profil(sexe: "Homme", taille: 1.20, nom: "Caprese Salad", age: 15, prenom: "Tanguy", email: "wiwi@gmail.com", poids: 4.5)

    let profil3 = Profil(sexe: "Homme", taille: 1.20, nom: "Caprese Salad", age: 15, prenom: "Tanguy", email: "wiwi@gmail.com", poids: 4.5)

    profils += [profil1, profil2, profil3]

  }

  override func numberOfSections(in tableView: UITableView) -> Int {
      return 1
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return profils.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cellIdentifier = "ProfilCell"
      guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ProfilCell  else {
          fatalError("La cellule n'est pas une instance de ProfilCell.")
      }

      let profil = profils[indexPath.row]
      cell.sexeLabelCellProfil.text = profil.sexe
      cell.prenomLabelCellProfil.text = profil.prenom
      cell.nomLabelCellProfil.text = profil.nom

      return cell
  }
}
