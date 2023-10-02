//
//  SCFeaturePlaylistCollectionViewCell.swift
//  SpotifyClone
//
//  Created by Shagara F Nasution on 28/08/23.
//

import UIKit

final class SCFeaturePlaylistCollectionViewCell: UICollectionViewCell {
    
    private let playlistCoverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .init(systemName: "photo")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let playlistNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.numberOfLines = 2
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let creatorNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .thin)
        label.numberOfLines = 2
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    static let identifier = "FeaturePlaylistCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureContentView()
        contentView.addSubviews(playlistCoverImageView, playlistNameLabel, creatorNameLabel)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        playlistNameLabel.text = nil
        creatorNameLabel.text = nil
        playlistCoverImageView.image = nil
    }
    
    private func configureContentView() {
        contentView.backgroundColor = .secondarySystemBackground
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true
    }
    
    private func addConstraints() {
        let imageSize: CGFloat = 105
        
        NSLayoutConstraint.activate([
            playlistCoverImageView.widthAnchor.constraint(equalToConstant: imageSize),
            playlistCoverImageView.heightAnchor.constraint(equalToConstant: imageSize),
            playlistCoverImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            playlistCoverImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            playlistNameLabel.bottomAnchor.constraint(equalTo: creatorNameLabel.topAnchor, constant: -8),
            playlistNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            playlistNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25),
            
            creatorNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            creatorNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            creatorNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25),
        ])
    }
    
    public func configure(with viewModel: SCFeaturePlaylistCollectionViewCellViewModel) {
        playlistNameLabel.text = viewModel.playlistName
        creatorNameLabel.text = viewModel.creatorName
        playlistCoverImageView.sd_setImage(with: viewModel.artworkURL)
    }
    
}
