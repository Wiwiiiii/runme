import UIKit
import Foundation
import Alamofire
import SwiftyJSON

class ProfilCreationViewController: UIViewController {

  @IBOutlet weak var tailleProfil: UITextField!
  @IBOutlet weak var nomProfil: UITextField!
  @IBOutlet weak var ageProfil: UITextField!
  @IBOutlet weak var prenomProfil: UITextField!
  @IBOutlet weak var mailProfil: UITextField!
  @IBOutlet weak var poidsProfil: UITextField!
  @IBOutlet weak var sexeProfil: UISegmentedControl!
  struct ProfilVarGlobales {
      static var IDProfil = 0
  }
  override func viewDidLoad() {
    super.viewDidLoad()
  }

  @IBAction func createProfil(_ sender: Any) {
    let castTailleProfil = String(self.tailleProfil.text ?? "1.50")
    let castPoidsProfil = String(self.poidsProfil.text ?? "60.0")
    let castAgeProfil = String(self.ageProfil.text ?? "50" )
    let castNomProfil = String(self.nomProfil.text ?? "Merrien")
    let castPrenomProfil = String(self.prenomProfil.text ?? "Trystan")
    let castMailProfil = String(self.mailProfil.text ?? "trystanmerrien.fr")
    let castSexeProfil = "Autre"
    ProfilVarGlobales.IDProfil+=1
    let castIDProfil = String(ProfilVarGlobales.IDProfil)
    print(castIDProfil)
    print(ProfilVarGlobales.IDProfil)
    // swiftlint:disable line_length
    AF.request("http://149.91.89.160:500/graphql?query=mutation%7B%20%20createUtilisateur(%0A%20%20%20%20id%3A%20"+castIDProfil+"%2C%0A%20%20%20%20sexe%3A%20%22"+castSexeProfil+"%22%2C%0A%20%20%20%20taille%3A%20"+castTailleProfil+"%2C%0A%20%20%20%20nom%3A%20%22"+castNomProfil+"%22%2C%0A%20%20%20%20age%3A%20"+castAgeProfil+"%2C%0A%20%20%20%20prenom%3A%20%22"+castPrenomProfil+"%22%2C%0A%20%20%20%20email%3A%20%22"+castMailProfil+"%22%2C%0A%20%20%20%20poids%3A%20"+castPoidsProfil+"%0A%20%20)%0A%20%20%7B%0A%20%20%20%20%20%20id%2C%0A%20%20%20%20sexe%2C%0A%20%20%20%20taille%2C%0A%20%20%20%20nom%2C%0A%20%20%20%20age%2C%0A%20%20%20%20prenom%2C%0A%20%20%20%20email%2C%0A%20%20%20%20poids%0A%20%20%7D%0A%0A%7D", method: .post, encoding: JSONEncoding.default)
        .responseJSON { response in
            if let valueSafe = response.value {
                //let json = JSON(valueSafe)
            } else {
                print("erreur dans le create du profil")
            }
    }
    // swiftlint:enable line_length

    /*let profil = self.createProfil(sexe: sexeProfil.titleForSegment(at: sexeProfil.selectedSegmentIndex),
                                   taille: tailleProfil.text?.doubleValueOrNil,
                                   nom: nomProfil.text,
                                   age: ageProfil.text?.intValueOrNil,
                                   prenom: prenomProfil.text,
                                   email: mailProfil.text,
                                   poids: poidsProfil.text?.doubleValueOrNil)*/

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

extension Int: Sequence {
    public func makeIterator() -> CountableRange<Int>.Iterator {
        return (0..<self).makeIterator()
    }
}
