//
//  SCPlayerViewController.swift
//  SpotifyClone
//
//  Created by Shagara F Nasution on 22/08/23.
//

import UIKit
import AVFoundation

protocol SCPlayerViewControllerDelegate: AnyObject {
    func scPlayerViewControllerDelegate(_ viewController: SCPlayerViewController, didTapBackward: ((AVPlayer.TimeControlStatus) -> Void)?)
    func scPlayerViewControllerDelegate(_ viewController: SCPlayerViewController, didTapForward: ((AVPlayer.TimeControlStatus) -> Void)?)
    func scPlayerViewControllerDelegate(_ viewController: SCPlayerViewController, didTapPlayPause: ((AVPlayer.TimeControlStatus) -> Void)?)
    func scPlayerViewControllerDelegate(_ viewController: SCPlayerViewController, didSlideVolumeSlider value: Float)
}

final class SCPlayerViewController: UIViewController {
    
    public var dataSource: SCPlayerDataSource?
    public var delegate: SCPlayerViewControllerDelegate?
    
    // MARK: - UI
    
    private let artworkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .systemGray
        imageView.image = UIImage(systemName: "music.note")
        imageView.tintColor = .secondaryLabel
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    private let playerControlsView: SCPlayerControlsView = {
        let view = SCPlayerControlsView()
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()
    
    private lazy var artworkImageSize: CGFloat = view.frame.width
    private lazy var artworkImageConstraintWidth: NSLayoutConstraint = artworkImageView.widthAnchor.constraint(equalToConstant: artworkImageSize)
    private lazy var artworkImageConstraintHeight: NSLayoutConstraint = artworkImageView.heightAnchor.constraint(equalToConstant: artworkImageSize)
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureBarButtons()
        view.addSubviews(artworkImageView, playerControlsView)
        addBaseConstraints()
        updateView()
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        view.addGestureRecognizer(panGesture)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        configureArtworkImageSizeConstraints(isActive: false)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureArtworkImageSizeConstraints(isActive: true)
    }
    
    // MARK: - Private Mathods
    
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        print("Panned")
    }
    
    private func updateView() {
        artworkImageView.sd_setImage(with: dataSource?.artworkImageURL) { [weak self] image, _, _, _ in
            if image == nil {
                self?.artworkImageView.image = UIImage(systemName: "music.note")
                self?.artworkImageView.contentMode = .scaleAspectFit
            }
        }
        let playerControlsViewModel = SCPlayerControlsViewViewModel(title: dataSource?.songTitle, subtitle: dataSource?.subtitle)
        playerControlsView.configure(with: playerControlsViewModel)
        playerControlsView.delegate = self
    }
    
    private func configureBarButtons() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close,
                                                           target: self,
                                                           action: #selector(tapLeftBarButton))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action,
                                                            target: self,
                                                            action: #selector(tapRightBarButton))
        navigationItem.leftBarButtonItem?.tintColor = .label
        navigationItem.rightBarButtonItem?.tintColor = .label
    }
    
    private func addBaseConstraints() {
        NSLayoutConstraint.activate([
            
            artworkImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            artworkImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            playerControlsView.topAnchor.constraint(equalTo: artworkImageView.bottomAnchor, constant: 24),
            playerControlsView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            playerControlsView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            playerControlsView.bottomAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
        ])
    }
    
    private func configureArtworkImageSizeConstraints(isActive: Bool) {
        guard isActive else {
            artworkImageConstraintWidth.isActive = false
            artworkImageConstraintHeight.isActive = false
            return
        }
        
        guard let imageSize = getArtworkImageSize() else {
            return
        }
        
        artworkImageConstraintWidth = artworkImageView.widthAnchor.constraint(equalToConstant: imageSize)
        artworkImageConstraintHeight = artworkImageView.heightAnchor.constraint(equalToConstant: imageSize)
        artworkImageConstraintWidth.isActive = true
        artworkImageConstraintHeight.isActive = true
    }
    
    private func getArtworkImageSize() -> CGFloat? {
        guard let windowScene = view.window?.windowScene else {
            return nil
        }
        
        switch windowScene.interfaceOrientation {
        case .portrait, .portraitUpsideDown:
            return view.frame.width
        case .landscapeLeft, .landscapeRight:
            return view.frame.width / 6
        default:
            return view.frame.width
        }
    }
    
    @objc
    private func tapLeftBarButton() {
        dismiss(animated: true)
    }
    
    @objc
    private func tapRightBarButton() {
        // do action
    }
    
}

// MARK: - Extension SCPlayerControls View Delegate

extension SCPlayerViewController: SCPlayerControlsViewDelegate {
    
    func scPlayerControlsView(_ view: SCPlayerControlsView, didTapBackwardButton completion: ((AVPlayer.TimeControlStatus) -> Void)?) {
        delegate?.scPlayerViewControllerDelegate(self, didTapBackward: completion)
        updateView()
    }
    
    func scPlayerControlsView(_ view: SCPlayerControlsView, didTapForwardButton completion: ((AVPlayer.TimeControlStatus) -> Void)?) {
        delegate?.scPlayerViewControllerDelegate(self, didTapForward: completion)
        updateView()
    }
    
    func scPlayerControlsView(_ view: SCPlayerControlsView, didTapPlayPauseButton completion: ((AVPlayer.TimeControlStatus) -> Void)?) {
        delegate?.scPlayerViewControllerDelegate(self, didTapPlayPause: completion)
    }
    
    func scPlayerControlsView(_ view: SCPlayerControlsView, didSlideVolumeSlider value: Float) {
        delegate?.scPlayerViewControllerDelegate(self, didSlideVolumeSlider: value)
    }
    
}
