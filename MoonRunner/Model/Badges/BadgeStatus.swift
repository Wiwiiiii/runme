//
//
import Foundation
//
// Définit la structure BadgeStatus et les multiplicateurs qui déterminent combien le temps d'un utilisateur doit s'améliorer
// pour gagner un badge argent ou or.
//
struct BadgeStatus {
  let badge: Badge
  let earned: Run?
  let silver: Run?
  let gold: Run?
  let best: Run?
  //
  static let silverMultiplier = 1.05
  static let goldMultiplier = 1.1
  //
  /*
   Cette méthode compare chacune des courses de l'utilisateur aux exigences de distance pour chaque badge, créant les associations et renvoyant un tableau de valeurs BadgeStatus pour chaque badge gagné.
   La première fois qu'un utilisateur gagne un badge, la vitesse de cette course devient la référence utilisée pour déterminer si les courses suivantes se sont suffisamment améliorées pour se qualifier pour les versions argent ou or.
   Enfin, elle permet de suivre la course la plus rapide de l'utilisateur jusqu'à la distance de chaque badge.
   */
  static func badgesEarned(runs: [Run]) -> [BadgeStatus] {
    return Badge.allBadges.map { badge in
      var earned: Run?
      var silver: Run?
      var gold: Run?
      var best: Run?
      //
      for run in runs where run.distance > badge.distance {
         if earned == nil {
          earned = run
        }
        //
        let earnedSpeed = earned!.distance / Double(earned!.duration)
        let runSpeed = run.distance / Double(run.duration)
        //
        if silver == nil && runSpeed > earnedSpeed * silverMultiplier {
          silver = run
        }
        //
        if gold == nil && runSpeed > earnedSpeed * goldMultiplier {
          gold = run
        }
        //
        if let existingBest = best {
          let bestSpeed = existingBest.distance / Double(existingBest.duration)
          if runSpeed > bestSpeed {
            best = run
          }
        } else {
          best = run
        }
      }
      //
      return BadgeStatus(badge: badge, earned: earned, silver: silver, gold: gold, best: best)
    }
  }
}
