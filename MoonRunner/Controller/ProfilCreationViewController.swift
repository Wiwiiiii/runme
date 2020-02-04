import UIKit
import Foundation

class ProfilCreationViewController: UIViewController {

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

    let profil = self.createProfil(sexe: sexeProfil.titleForSegment(at: sexeProfil.selectedSegmentIndex),
                                   taille: tailleProfil.text?.doubleValueOrNil,
                                   nom: nomProfil.text,
                                   age: ageProfil.text?.intValueOrNil,
                                   prenom: prenomProfil.text,
                                   email: mailProfil.text,
                                   poids: poidsProfil.text?.doubleValueOrNil)

    //ToyService.shared.add(toy: toy)

    navigationController?.popViewController(animated: true)
  }


  /// Creation d'un profil depuis le model profile
  /// - Parameter sexe: String?
  /// - Parameter taille: Double?
  /// - Parameter nom: String?
  /// - Parameter age: Int?
  /// - Parameter prenom: String?
  /// - Parameter email: String?
  /// - Parameter poids: Double?
  private func createProfil(sexe: String?, taille: Double?, nom: String?,
                            age: Int?, prenom: String?, email: String?,
                            poids: Double?) -> Profil {

    return Profil(sexe: sexe, taille: taille, nom: nom, age: age,
                  prenom: prenom, email: email, poids: poids)
  }


}
