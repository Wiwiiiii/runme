import UIKit
import CoreData

class BadgesTableViewController: UITableViewController {

  // Lorsque la vue se charge, on demande au CoreData une liste de toutes les courses terminées et triées par date
  // On l'utilise pour créer la liste des badges gagnés.
  var statusList: [BadgeStatus]!

  override func viewDidLoad() {
    super.viewDidLoad()
    statusList = BadgeStatus.badgesEarned(runs: getRuns())
  }

  private func getRuns() -> [Run] {
    let fetchRequest: NSFetchRequest<Run> = Run.fetchRequest()
    let sortDescriptor = NSSortDescriptor(key: #keyPath(Run.timestamp), ascending: true)
    fetchRequest.sortDescriptors = [sortDescriptor]
    do {
      return try CoreDataStack.context.fetch(fetchRequest)
    } catch {
      return []
    }
  }
}

// MARK: - Table View Data Source

/*
Méthodes UITableViewDataSource standard requises par tous les UITableViewControllers
Renvoyant le nombre de lignes et les cellules configurées au tableau.
Tout comme dans la partie 1, vous réduisez le code «typé en chaîne» en
retirant la cellule de la file d'attente via une méthode générique
définie dans StoryboardSupport.swift.
 */
extension BadgesTableViewController {
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return statusList.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: BadgeCell = tableView.dequeueReusableCell(for: indexPath)
    cell.status = statusList[indexPath.row]
    return cell
  }
}

// MARK: - Navigation
// Permet de passer un BadgeStatus à BadgeDetailsViewController lorsque
//l'utilisateur appuie sur un badge dans le tableau.
extension BadgesTableViewController: SegueHandlerType {
  enum SegueIdentifier: String {
    case details = "BadgeDetailsViewController"
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    switch segueIdentifier(for: segue) {
    case .details:
      let destination = segue.destination as! BadgeDetailsViewController
      let indexPath = tableView.indexPathForSelectedRow!
      destination.status = statusList[indexPath.row]
    }
  }

  override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
    guard let segue = SegueIdentifier(rawValue: identifier) else { return false }
    switch segue {
    case .details:
      guard let cell = sender as? UITableViewCell else { return false }
      return cell.accessoryType == .disclosureIndicator
    }
  }
}
