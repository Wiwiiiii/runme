import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class ApiTestViewController : UIViewController {
  struct JSONTest: Codable {
      let sexe: String
      let nom: String
  }

  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var timeLabel: UILabel!
  
  // Liaison interface - controller

  override func viewDidLoad() {
    super.viewDidLoad()
     // swiftlint:disable line_length
    AF.request("http://149.91.89.160:500/graphql?query=%0Aquery%7B%0A%20%20%20utilisateurs%7B%0A%20%20%20%20%20%20id%2C%0A%20%20%20%20%20%20sexe%2C%0A%20%20%20%20%20%20taille%2C%0A%20%20%20%20%20%20nom%2C%0A%20%20%20%20age%2C%0A%20%20%20%20prenom%2C%0A%20%20%20%20email%2C%0A%20%20%20%20poids%0A%20%20%7D%0A%7D", method: .get, encoding: JSONEncoding.default)
                .responseJSON { response in
                    print(response.request)  // original URL request
                    print(response.response) // HTTP URL response
                    print(response.data)     // server data
                    print(response.result)   // result of response serialization

                    switch response.result {

                    case .success(let json):
                        print(json)

                    case .failure(let error):
                        print(error)

    }
    }
    
    /*// 1
    let urlString = "http://149.91.89.160:500/graphql?query=%0Aquery%7B%0A%20%20%20utilisateurs%7B%0A%20%20%20%20%20%20id%2C%0A%20%20%20%20%20%20sexe%2C%0A%20%20%20%20%20%20taille%2C%0A%20%20%20%20%20%20nom%2C%0A%20%20%20%20age%2C%0A%20%20%20%20prenom%2C%0A%20%20%20%20email%2C%0A%20%20%20%20poids%0A%20%20%7D%0A%7D"
    guard let url = URL(string: urlString) else { return }
    
    // 2
    URLSession.shared.dataTask(with: url) { (data, response, error) in
        if error != nil {
            print(error!.localizedDescription)
        }

        guard let data = data else { return }
        do {
            // 3
            //Decode data
            let JSONData = try JSONDecoder().decode(JSONTest.self, from: data)
            print(JSONData)

            // 4
            //Get back to the main queue
            /*DispatchQueue.main.async {
                self.dateLabel.text = JSONData.utilisateurs[sexe]
                self.timeLabel.text = JSONData.time
            }*/

        } catch let jsonError {
            print(jsonError)
        }
        // 5
        }.resume()*/
}
}
