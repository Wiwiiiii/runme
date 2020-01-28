//
import UIKit
import Foundation
//
class ProfilCreationViewController: UIViewController {
  // Liaison interface - controller
  //
  @IBOutlet weak var tailleProfil: UITextField!
  @IBOutlet weak var nomProfil: UITextField!
  @IBOutlet weak var ageProfil: UITextField!
  @IBOutlet weak var prenomProfil: UITextField!
  @IBOutlet weak var mailProfil: UITextField!
  @IBOutlet weak var poidsProfil: UITextField!
  @IBOutlet weak var sexeProfil: UISegmentedControl!
  override func viewDidLoad() {
    super.viewDidLoad()
  }

  
  
  @IBAction func createProfil(_ sender: Any) {
    guard let sexe = sexeProfil.titleForSegment(at: sexeProfil.selectedSegmentIndex),
        let taille = Double(tailleProfil.text!),
        let nom = nomProfil.text,
        let age = Int(ageProfil.text!),
        let prenom = prenomProfil.text,
        let email = mailProfil.text,
        let poids = Double(poidsProfil.text!)
    else {
            return
    }

    let profil = Profil(sexe: sexe, taille: taille, nom: nom, age: age, prenom: prenom, email: email, poids: poids)
    //ToyService.shared.add(toy: toy)

    navigationController?.popViewController(animated: true)
  }
}
