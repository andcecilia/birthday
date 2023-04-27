//
//  ViewController.swift
//  Birthday
//
//  Created by Cecilia Andrea Pesce on 14/07/22.
//

import UIKit
import Lottie
import SnapKit

class ViewController: UIViewController {
    
    lazy var erickImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "erick")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var happyBirthdayButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Happy Birthday!", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.addTarget(self, action: #selector(didTapHappyBirthdayButton(_:)), for: .touchUpInside)
        
        return button
    }()
    
    lazy var stitchCakeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "stitchCake")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()

    lazy var confettiAnimationView: AnimationView = {
     let animation = AnimationView()
        animation.translatesAutoresizingMaskIntoConstraints = false
        return animation
    }()
    
    lazy var confetti = Animation.named("confetti", bundle: .main)
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white
        
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        setupConstraints()
        erickImageView.isHidden = true
        stitchCakeImageView.isHidden = true
    }
    
    func configureViews() {
        view.addSubview(erickImageView)
        view.addSubview(happyBirthdayButton)
        view.addSubview(stitchCakeImageView)
        view.addSubview(confettiAnimationView)
    }
    
    func setupConstraints() {
        erickImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(72)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(160)
        }
        
        happyBirthdayButton.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        
        stitchCakeImageView.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(72)
            $0.width.height.equalTo(160)
            $0.centerX.equalToSuperview()
        }
    }
    
    @objc func didTapHappyBirthdayButton(_ sender: UIButton!) {
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

