//
//  SCTrackCollectionViewCell.swift
//  SpotifyClone
//
//  Created by Shagara F Nasution on 28/08/23.
//

import UIKit

final class SCTrackCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "SCTrackCollectionViewCell"
    
    private let albumCoverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let trackNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .thin)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureContentView()
        contentView.addSubviews(albumCoverImageView, trackNameLabel, artistNameLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        trackNameLabel.text = nil
        artistNameLabel.text = nil
        albumCoverImageView.image = nil
    }
    
    private func configureContentView() {
        contentView.backgroundColor = .secondarySystemBackground
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true
    }
    
    private func setupContraints(with viewModel: SCTrackCollectionViewCellViewModel) {
        let imageSize = contentView.height
        
        if viewModel.album != nil {
            NSLayoutConstraint.activate([
                albumCoverImageView.widthAnchor.constraint(equalToConstant: imageSize),
                albumCoverImageView.heightAnchor.constraint(equalToConstant: imageSize),
                albumCoverImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
                albumCoverImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                
                trackNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
                trackNameLabel.leadingAnchor.constraint(equalTo: albumCoverImageView.trailingAnchor, constant: 8),
                trackNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
               
                artistNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
                artistNameLabel.leadingAnchor.constraint(equalTo: albumCoverImageView.trailingAnchor, constant: 8),
                artistNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            ])
        } else {
            NSLayoutConstraint.activate([
                trackNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
                trackNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
                trackNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
               
                artistNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
                artistNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
                artistNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            ])
        }
    }
    
    public func configure(with viewModel: SCTrackCollectionViewCellViewModel) {
        trackNameLabel.text = viewModel.trackName
        artistNameLabel.text = viewModel.artistName
        if viewModel.album != nil {
            albumCoverImageView.isHidden = false
            albumCoverImageView.sd_setImage(with: viewModel.artworkURL)
        } else {
            albumCoverImageView.isHidden = true
        }
        setupContraints(with: viewModel)
    }
    
}
