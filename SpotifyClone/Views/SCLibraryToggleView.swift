//
//  SCLibraryToggleView.swift
//  SpotifyClone
//
//  Created by Shagara F Nasution on 19/09/23.
//

import UIKit

protocol SCLibraryToggleViewDelegate: AnyObject {
    func scLibraryToggleViewDidTapPlaylistButton(_ view: SCLibraryToggleView)
    func scLibraryToggleViewDidTapAlbumButton(_ view: SCLibraryToggleView)
}

final class SCLibraryToggleView: UIView {
    
    enum State {
        case playlist
        case album
    }
    
    public weak var delegate: SCLibraryToggleViewDelegate?
    
    private var state: State = .playlist
    
    public var currentState: State {
        return state
    }
    
    // MARK: - UI
    
    private lazy var playlistButton: UIButton = {
        let button = UIButton()
        button.setTitle("Playlists", for: .normal)
        button.setTitleColor(.label, for: .selected)
        button.setTitleColor(.secondaryLabel, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints  = false
        
        return button
    }()
    
    private lazy var albumButton: UIButton = {
        let button = UIButton()
        button.setTitle("Albums", for: .normal)
        button.setTitleColor(.label, for: .selected)
        button.setTitleColor(.secondaryLabel, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private lazy var indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGreen
        
        return view
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews(playlistButton, albumButton, indicatorView)
        addConstraints()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutIndicatorView()
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            playlistButton.topAnchor.constraint(equalTo: topAnchor),
            playlistButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            playlistButton.widthAnchor.constraint(equalToConstant: 100),
            playlistButton.heightAnchor.constraint(equalToConstant: 45),
            
            albumButton.topAnchor.constraint(equalTo: topAnchor),
            albumButton.leadingAnchor.constraint(equalTo: playlistButton.trailingAnchor),
            albumButton.widthAnchor.constraint(equalToConstant: 100),
            albumButton.heightAnchor.constraint(equalToConstant: 45),
        ])
    }
    
    private func layoutIndicatorView() {
        switch state {
        case .playlist:
            indicatorView.frame = CGRect(
                x: playlistButton.frame.origin.x,
                y: playlistButton.height,
                width: 100,
                height: 3
            )
            playlistButton.isSelected = true
            albumButton.isSelected = false
        case .album:
            indicatorView.frame = CGRect(
                x: playlistButton.width,
                y: playlistButton.height,
                width: 100,
                height: 3
            )
            playlistButton.isSelected = false
            albumButton.isSelected = true
        }
    }
    
    private func setupActions() {
        playlistButton.addTarget(self, action: #selector(tapPlaylistButton), for: .touchUpInside)
        albumButton.addTarget(self, action: #selector(tapAlbumButton), for: .touchUpInside)
    }
    
    @objc
    private func tapPlaylistButton() {
        state = .playlist
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.layoutIndicatorView()
        }
        delegate?.scLibraryToggleViewDidTapPlaylistButton(self)
    }
    
    @objc
    private func tapAlbumButton() {
        state = .album
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.layoutIndicatorView()
        }
        delegate?.scLibraryToggleViewDidTapAlbumButton(self)
    }
    
    public func update(forState state: State) {
        self.state = state
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.layoutIndicatorView()
        }
    }
    
}
