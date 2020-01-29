//
import Foundation
import UIKit
//
class ProfilTableViewController: UITableViewController {
  //
  // Liaison interface - controller
  
  override func viewDidLoad() {
  super.viewDidLoad()
  loadSampleProfils()
  }
    
  var profils = [Profil]()
  
  
  private func loadSampleProfils() {
    
    guard let profil1 = Profil(sexe: "Homme", taille: 1.20, nom: "Caprese Salad", age: 15, prenom: "Tanguy", email: "wiwi@gmail.com", poids: 4.5) else {
        fatalError("Unable to instantiate profil1")
    }
    
    guard let profil2 = Profil(sexe: "Homme", taille: 1.20, nom: "Caprese Salad", age: 15, prenom: "Tanguy", email: "wiwi@gmail.com", poids: 4.5) else {
        fatalError("Unable to instantiate profil2")
    }
    
    guard let profil3 = Profil(sexe: "Homme", taille: 1.20, nom: "Caprese Salad", age: 15, prenom: "Tanguy", email: "wiwi@gmail.com", poids: 4.5) else {
        fatalError("Unable to instantiate profil3")
    }
    
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
      
      // Fetches the appropriate meal for the data source layout.
      let profil = profils[indexPath.row]
      
      cell.sexeLabelCellProfil.text = profil.sexe
    cell.tailleLabelCellProfil.text?.doubleValueOrNil = profil.taille
      cell.prenomLabelCellProfil.text = profil.prenom
    cell.poidsLabelCellProfil.text?.intValueOrNil = profil.poids
      //cell.imageLabelCellProfil.text = profil.image
      cell.nomLabelCellProfil.text = profil.nom
      cell.ageLabelCellProfil.text?.doubleValueOrNil = profil.age
      
      return cell
      
      return cell
  }
}
