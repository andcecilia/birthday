//
//  ViewController.swift
//  Birthday
//
//  Created by Cecilia Andrea Pesce on 14/07/22.
//

import UIKit
import Lottie

class ViewController: UIViewController {
    
    @IBOutlet weak var erickImageView: UIImageView!
    @IBOutlet weak var happyBirthdayButton: UIButton!
    @IBOutlet weak var stitchCakeImageView: UIImageView!
    @IBOutlet weak var confettiAnimationView: AnimationView!
    
    lazy var confetti = Animation.named("confetti", bundle: .main)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        erickImageView.isHidden = true
        stitchCakeImageView.isHidden = true
    }
    
    @IBAction func didTapHappyBirthdayButton(_ sender: Any) {
        happyBirthdayButton.isHidden = true
        erickImageView.isHidden = false
        stitchCakeImageView.isHidden = false
        throwConfetti()
    }
    
    func throwConfetti() {
        confettiAnimationView.animation = confetti
        confettiAnimationView.contentMode = .scaleAspectFill
        confettiAnimationView.loopMode = .playOnce
        confettiAnimationView.play()
    }
    
}

