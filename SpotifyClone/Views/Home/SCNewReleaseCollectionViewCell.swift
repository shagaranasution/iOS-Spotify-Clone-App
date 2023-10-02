//
//  SCNewReleaseCollectionViewCell.swift
//  SpotifyClone
//
//  Created by Shagara F Nasution on 28/08/23.
//

import UIKit

final class SCNewReleaseCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "NewReleaseCollectionViewCell"
    
    private let albumCoverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private let albumNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let numberOfTracksLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureContentView()
        contentView.addSubviews(albumCoverImageView, albumNameLabel, artistNameLabel, numberOfTracksLabel)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        albumNameLabel.text = nil
        artistNameLabel.text = nil
        numberOfTracksLabel.text = nil
        albumCoverImageView.image = nil
    }
    
    private func configureContentView() {
        contentView.backgroundColor = .red
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true
        contentView.backgroundColor = .secondarySystemBackground
    }
    
    private func addConstraints() {
        let imageSize: CGFloat = contentView.height
        
        NSLayoutConstraint.activate([
            albumCoverImageView.widthAnchor.constraint(equalToConstant: imageSize),
            albumCoverImageView.heightAnchor.constraint(equalToConstant: imageSize),
            albumCoverImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            albumCoverImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            
            albumNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            albumNameLabel.leadingAnchor.constraint(equalTo: albumCoverImageView.trailingAnchor, constant: 8),
            albumNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -6),

            artistNameLabel.topAnchor.constraint(equalTo: albumNameLabel.bottomAnchor, constant: 6),
            artistNameLabel.leadingAnchor.constraint(equalTo: albumCoverImageView.trailingAnchor, constant: 8),
            artistNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -6),

            numberOfTracksLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            numberOfTracksLabel.leadingAnchor.constraint(equalTo: albumCoverImageView.trailingAnchor, constant: 8),
            numberOfTracksLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -6),
        ])
    }
    
    public func configure(with viewModel: SCNewReleaseCollectionViewCellViewModel) {
        albumNameLabel.text = viewModel.albumName
        artistNameLabel.text = viewModel.artistName
        numberOfTracksLabel.text = "Total tracks: \(viewModel.numberOfTracks)"
        albumCoverImageView.sd_setImage(with: viewModel.artworkURL)
    }
    
}
