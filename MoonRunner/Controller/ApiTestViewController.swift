import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class ApiTestViewController : UIViewController {

  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var timeLabel: UILabel!

  // Liaison interface - controller

  override func viewDidLoad() {
    super.viewDidLoad()
      // swiftlint:disable line_length
      AF.request("http://149.91.89.160:500/graphql?query=%0Aquery%7B%0A%20%20%20utilisateurs%7B%0A%20%20%20%20%20%20id%2C%0A%20%20%20%20%20%20sexe%2C%0A%20%20%20%20%20%20taille%2C%0A%20%20%20%20%20%20nom%2C%0A%20%20%20%20age%2C%0A%20%20%20%20prenom%2C%0A%20%20%20%20email%2C%0A%20%20%20%20poids%0A%20%20%7D%0A%7D", method: .post, encoding: JSONEncoding.default)
      .responseJSON { response in
                    if let valueSafe = response.value {
                      let json = JSON(valueSafe)
                      let name = json["data"]["utilisateurs"].arrayValue[0]["nom"].stringValue
                      self.dateLabel.text = name
                    } else {
                      //TODO: Erreur ici
                    }
          }
    // swiftlint:disable line_length
}
}
