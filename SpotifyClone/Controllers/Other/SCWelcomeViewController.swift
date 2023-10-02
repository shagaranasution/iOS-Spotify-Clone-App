//
//  SCWelcomeViewController.swift
//  SpotifyClone
//
//  Created by Shagara F Nasution on 22/08/23.
//

import UIKit

final class SCWelcomeViewController: UIViewController {
    
    // MARK: - UI
    
    private let coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "sc_welcome_cover")
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    private let overlayView: UIView = {
        let view = UIImageView()
        view.backgroundColor = .black
        view.alpha = 0.3
        
        return view
    }()
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "sc_logo_circle")
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private let headingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 32, weight: .semibold)
        label.text = "Listen to Millions\nof Songs on\nThe Go."
        label.numberOfLines = 0
        label.textColor = .white
        label.textAlignment = .center
        
        return label
    }()
    
    private let signInButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("Sign In with Spotify", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 4
        button.clipsToBounds = true
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Spotify"
        let textAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
        ]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.largeTitleTextAttributes = textAttributes
        view.backgroundColor = .systemGreen
        view.addSubviews(
            coverImageView,
            overlayView,
            logoImageView,
            headingLabel,
            signInButton
        )
        signInButton.addTarget(self, action: #selector(tapSignIn), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layoutViews()
    }
    
    private func layoutHeadingLabel() {
        headingLabel.frame = CGRect(x: view.safeAreaLeft + 30,
                                    y: logoImageView.bottom + 16,
                                    width: view.safeAreaRight - 50,
                                    height: 150)
        
        guard let windowScene = view.window?.windowScene else {
            return
        }
        
        switch windowScene.interfaceOrientation {
        case .portrait, .portraitUpsideDown:
            headingLabel.isHidden = false
        case .landscapeLeft, .landscapeRight:
            headingLabel.isHidden = true
        default:
            break
        }
    }
    
    private func layoutViews() {
        coverImageView.frame = view.bounds
        overlayView.frame = view.bounds
        logoImageView.frame = CGRect(x: view.width/2 - 120/2,
                                     y: view.height/2 - 120,
                                     width: 120,
                                     height: 120)
        layoutHeadingLabel()
        signInButton.frame = CGRect(x: view.safeAreaLeft + 30,
                                    y: view.safeAreaBottom - 72,
                                    width: view.safeAreaRight - 50,
                                    height: 50)
    }
    
    @objc
    private func tapSignIn() {
        let vc = SCAuthViewController()
        vc.completionHandler = { [weak self] success in
            DispatchQueue.main.async {
                self?.handleSignIn(success: success)
            }
        }
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func handleSignIn(success: Bool) {
        guard success else {
            let alert = UIAlertController(title: "Oops",
                                          message: "Something went wrong when signing in.",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
            present(alert, animated: true)
            return
        }
        let mainAppTabBarVC = SCTabBarViewController()
        mainAppTabBarVC.modalPresentationStyle = .fullScreen
        present(mainAppTabBarVC, animated: true)
    }
    
}
