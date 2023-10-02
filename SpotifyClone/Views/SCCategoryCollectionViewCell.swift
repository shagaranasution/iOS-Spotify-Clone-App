//
//  SCCategoryCollectionViewCell.swift
//  SpotifyClone
//
//  Created by Shagara F Nasution on 06/09/23.
//

import UIKit

final class SCCategoryCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "SCGenreCollectionViewCell"
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let outerImageView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 70, height: 70))
        view.clipsToBounds = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.4
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowRadius = 4
        view.layer.shadowPath = UIBezierPath(roundedRect: view.bounds, cornerRadius: 8).cgPath
        view.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 4)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .white
        let image = UIImage(
            systemName: "music.quarternote.3",
            withConfiguration: UIImage.SymbolConfiguration(
                pointSize: 48,
                weight: .regular
            )
        )
        imageView.contentMode = .scaleAspectFill
        imageView.image = image
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let contenViewBackgrounColors: [UIColor] = [
        UIColor.systemGreen,
        UIColor.systemYellow,
        UIColor.systemPink,
        UIColor.systemPurple,
        UIColor.systemTeal,
        UIColor.gray,
        UIColor.systemBrown,
    ]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true
        contentView.addSubviews(outerImageView, nameLabel)
        outerImageView.addSubview(imageView)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        imageView.image = nil
    }
    private func addConstraints() {
        NSLayoutConstraint.activate([
            outerImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: contentView.bounds.height * 0.17),
            outerImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 8),
            outerImageView.widthAnchor.constraint(equalToConstant: 70),
            outerImageView.heightAnchor.constraint(equalToConstant: 70),
            
            imageView.topAnchor.constraint(equalTo: outerImageView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: outerImageView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: outerImageView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: outerImageView.trailingAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: outerImageView.leadingAnchor, constant: -8),
        ])

    }
    
    public func configure(with viewModel: SCCategoryCollectionViewCellViewModel) {
        contentView.backgroundColor = contenViewBackgrounColors.randomElement()
        nameLabel.text = viewModel.name
        imageView.sd_setImage(with: viewModel.artworkURL)
    }
    
}
