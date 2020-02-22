import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class ProfilTableViewController: UITableViewController {

  // Liaison interface - controller

  override func viewDidLoad() {
    super.viewDidLoad()
     // swiftlint:disable line_length
    /*AF.request("http://149.91.89.160:500/graphql?query=%0Aquery%7B%0A%20%20%20utilisateurs%7B%0A%20%20%20%20%20%20id%2C%0A%20%20%20%20%20%20sexe%2C%0A%20%20%20%20%20%20taille%2C%0A%20%20%20%20%20%20nom%2C%0A%20%20%20%20age%2C%0A%20%20%20%20prenom%2C%0A%20%20%20%20email%2C%0A%20%20%20%20poids%0A%20%20%7D%0A%7D", method: .get, encoding: JSONEncoding.default)
                .responseJSON { response in
                    print(response.request)  // original URL request
                    print(response.response) // HTTP URL response
                    print(response.data)     // server data
                    print(response.result)   // result of response serialization

                    switch response.result {

                    case .success(var json):
                        print(json)
                        /*do{
                          let jsonDict = try JSONSerialization.jsonObject(with: json) as? NSDictionary
                          for data in jsonDict {
                            print(data)
                          }
                        } catch let error as NSError {
                            print(error)
                        }*/
                    case .failure(let error):
                        print(error)

    }
    }*/

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
