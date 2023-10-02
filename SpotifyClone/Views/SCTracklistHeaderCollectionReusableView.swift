//
//  SCTracklistHeaderCollectionReusableView.swift
//  SpotifyClone
//
//  Created by Shagara F Nasution on 31/08/23.
//

import UIKit

protocol SCTracklistHeaderCollectionReusableViewDelegate: AnyObject {
    func scTracklistHeaderCollectionReusableView(_ view: SCTracklistHeaderCollectionReusableView, didTapPlayAll: Void)
}

final class SCTracklistHeaderCollectionReusableView: UICollectionReusableView {
    
    public static let identifier = "SCTracklistHeaderCollectionReusableView"
    public weak var delegate: SCTracklistHeaderCollectionReusableViewDelegate?
    
    private var playlistCoverImageViewWidthConstraint: NSLayoutConstraint?
    private var playlistCoverImageViewHeightConstraint: NSLayoutConstraint?
    private var coverImageSize: CGFloat {
        return height / 1.8
    }
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let ownerLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .light)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let playlistCoverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(systemName: "music.note")
        imageView.tintColor = .secondaryLabel
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let playAllButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGreen
        button.tintColor = .label
        let image = UIImage(
            systemName: "play.fill",
            withConfiguration: UIImage.SymbolConfiguration(
                pointSize: 30,
                weight: .regular
            )
        )
        button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        button.layer.cornerRadius = 25
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews(
            playlistCoverImageView,
            nameLabel,
            descriptionLabel,
            ownerLabel,
            playAllButton
        )
        addConstraints()
        playAllButton.addTarget(self, action: #selector(tapPlayAllButton), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playlistCoverImageViewWidthConstraint?.constant = coverImageSize
        playlistCoverImageViewHeightConstraint?.constant = coverImageSize
        layoutIfNeeded()
    }
    
    private func addConstraints() {
        playlistCoverImageViewWidthConstraint = playlistCoverImageView.widthAnchor.constraint(equalToConstant: coverImageSize)
        playlistCoverImageViewHeightConstraint = playlistCoverImageView.heightAnchor.constraint(equalToConstant: coverImageSize)
        
        NSLayoutConstraint.activate([
            playlistCoverImageViewWidthConstraint!,
            playlistCoverImageViewHeightConstraint!,
            playlistCoverImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            playlistCoverImageView.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            
            nameLabel.topAnchor.constraint(equalTo: playlistCoverImageView.bottomAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: playAllButton.leadingAnchor, constant: -8),
            
            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            descriptionLabel.trailingAnchor.constraint(equalTo: playAllButton.leadingAnchor, constant: -8),
            
            ownerLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            ownerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            ownerLabel.trailingAnchor.constraint(equalTo: playAllButton.leadingAnchor, constant: -8),
            
            playAllButton.widthAnchor.constraint(equalToConstant: 50),
            playAllButton.heightAnchor.constraint(equalToConstant: 50),
            playAllButton.centerYAnchor.constraint(equalTo: descriptionLabel.centerYAnchor),
            playAllButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
        ])
    }
    
    @objc
    private func tapPlayAllButton() {
        delegate?.scTracklistHeaderCollectionReusableView(self, didTapPlayAll: ())
    }
    
    public func configure(with viewModel: SCTracklistHeaderCollectionReusableViewViewModel) {
        nameLabel.text = viewModel.playlistName
        descriptionLabel.text = viewModel.description
        ownerLabel.text = viewModel.ownerName
        playlistCoverImageView.sd_setImage(with: viewModel.artworkURL) { [weak self] image, _, _, _ in
            if image == nil {
                self?.playlistCoverImageView.image = UIImage(systemName: "music.note")
                self?.playlistCoverImageView.contentMode = .scaleAspectFit
            } else {
                self?.playlistCoverImageView.contentMode = .scaleAspectFill
            }
        }
    }
    
    
}
