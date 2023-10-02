//
//  SCLibraryTableViewCell.swift
//  SpotifyClone
//
//  Created by Shagara F Nasution on 21/09/23.
//

import UIKit

final class SCLibraryTableViewCell: UITableViewCell {
    
    public static let identifier = "SCLibraryTableViewCell"
    
    // MARK: - UI
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.numberOfLines = 1
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 1
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var artworkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .systemGray
        imageView.image = UIImage(systemName: "music.note")
        imageView.tintColor = .systemGray3
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()

    // MARK: - Initialization

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews(artworkImageView, titleLabel, subtitleLabel)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        subtitleLabel.text = nil
        artworkImageView.image = nil
    }
    
    private func addConstraints() {
        let imageSize: CGFloat = 80
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            artworkImageView.widthAnchor.constraint(equalToConstant: imageSize),
            artworkImageView.heightAnchor.constraint(equalToConstant: imageSize),
            artworkImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            artworkImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),

            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: imageSize/2 - 16),
            titleLabel.leadingAnchor.constraint(equalTo: artworkImageView.trailingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            subtitleLabel.leadingAnchor.constraint(equalTo: artworkImageView.trailingAnchor, constant: 16),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])
    }
    
    public func configure(with viewModel: SCLibraryTableViewCellViewModel) {
        titleLabel.text = viewModel.getTitle()
        subtitleLabel.text = viewModel.getSubtitle()
        artworkImageView.sd_setImage(with: viewModel.getArtworkImageURL()) { [weak self] image, _, _, _ in
            if image == nil {
                self?.artworkImageView.image = UIImage(systemName: "music.note")
                self?.artworkImageView.contentMode = .scaleAspectFit
            } else {
                self?.artworkImageView.contentMode = .scaleAspectFill
            }
        }
    }
    
}
