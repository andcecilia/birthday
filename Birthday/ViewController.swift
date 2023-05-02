//
//  ViewController.swift
//  Birthday
//
//  Created by Cecilia Andrea Pesce on 14/07/22.
//

import UIKit
import Foundation
import Lottie
import SnapKit
import AVKit
import AVFoundation

class ViewController: UIViewController {
    
    let downloadService = DownloadService()
    
    lazy var downloadsSession: URLSession = {
        let configuration = URLSessionConfiguration.background(withIdentifier: "com.cecilia.Birthday.bkgsessionconfiguration")
        return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }()
    
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
    
    lazy var playButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemBlue
        button.setTitle("Play", for: .normal)
        button.layer.cornerRadius = 7
        button.addTarget(self, action: #selector(playMusic), for: .touchUpInside)
        return button
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.color = .blue
        activityIndicator.style = .large
        return activityIndicator
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
        playButton.isHidden = true
        activityIndicator.isHidden = true
    }
    
    func configureViews() {
        view.addSubview(erickImageView)
        view.addSubview(playButton)
        view.addSubview(activityIndicator)
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
        
        playButton.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.height.equalTo(48)
            $0.width.equalTo(210)
        }
        
        activityIndicator.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
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
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        downloadService.downloadsSession = downloadsSession
        
        for url in urlDownloads {
            downloadService.startDownload(URL(string: url)!)
        }
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
    
    @objc func playMusic(_ sender: UIButton) {
        let playerViewController = AVPlayerViewController()
        present(playerViewController, animated: true, completion: nil)
//        let url = localFilePath(for: URL(string: urlDownloads[0])!)
        let url = URL(string: String(describing: urlDownloads.first!))!
        let player = AVPlayer(url: url)
        playerViewController.player = player
        player.play()
    }
   
    let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    func localFilePath(for url: URL) -> URL {
        return documentsPath.appendingPathComponent(url.lastPathComponent)
    }
}

extension ViewController: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        guard let sourceURL = downloadTask.originalRequest?.url else { return }
        
        downloadService.activeDownloads[sourceURL] = nil
        let destinationURL = localFilePath(for: sourceURL)
        
        let fileManager = FileManager.default
        try? fileManager.removeItem(at: destinationURL)
        do {
            try fileManager.copyItem(at: location, to: destinationURL)
        } catch let erro {
            print("No copy file to disk: \(erro.localizedDescription)")
        }
    }
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData  bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        if let url = downloadTask.originalRequest?.url, let _ = downloadService.activeDownloads[url] {
            let progress = round(Float(totalBytesWritten) / Float(totalBytesExpectedToWrite) * 100)
            
            print("carregando: \(progress) %")
            if progress == 100 {
                DispatchQueue.main.async {
                    self.confettiAnimationView.isHidden = true
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                    self.playButton.isHidden = false
                }
            }
        }
    }
}


extension ViewController: URLSessionDelegate {
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        OperationQueue.main.addOperation {
            
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate,
               let completionHandler = appDelegate.backgroundSessionCompletionHandler {
                appDelegate.backgroundSessionCompletionHandler = nil
                completionHandler()
            }
        }
    }
}

