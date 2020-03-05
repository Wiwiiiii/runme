import Foundation
import UIKit
import AVFoundation

class OptionsViewController: UIViewController {

  @IBOutlet weak var soundSegment: UISegmentedControl!

  let musicPlayer: AVAudioPlayer = AVAudioPlayer()
  var isMuted: Bool = false

  override func viewDidLoad() {
    super.viewDidLoad()

  }

  @IBAction func soundButton(_ sender: Any) {
    if soundSegment.selectedSegmentIndex == 0 {
      isMuted = false
      musicPlayer.volume = 1
      musicPlayer.play()
    } else if soundSegment.selectedSegmentIndex == 1 {
         isMuted = true
         musicPlayer.volume = 0
         musicPlayer.stop()
    }
  }

  @IBAction func langueButton(_ sender: Any) {
  }

  @IBAction func sombreButton(_ sender: Any) {
  }
  @IBAction func viderCache(_ sender: Any) {
  }
  @IBAction func saveButton(_ sender: Any) {
  }
}
