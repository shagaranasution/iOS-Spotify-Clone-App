//
//  SCSearchResultsTableViewCell.swift
//  SpotifyClone
//
//  Created by Shagara F Nasution on 11/09/23.
//

import UIKit

final class SCSearchResultsTableViewCell: UITableViewCell {
    
    public static let identifier = "SCSearchResultsTableViewCell"
    
    private var viewModel: SCSearchResultsTableViewCellViewModel?
    private let imageSize: CGFloat = 36
    private var nameLabelConstraintTop: NSLayoutConstraint!
    private var nameLabelContraintY: NSLayoutConstraint!
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let artworkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .label
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessoryType = .disclosureIndicator
        backgroundColor = .systemBackground
        contentView.addSubviews(artworkImageView, nameLabel)
        addBaseConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        nameLabel.text = nil
        artworkImageView.image = nil
        if viewModel?.getSubtitle() != nil {
            subtitleLabel.text = nil
        }
    }
    
    private func addBaseConstraints() {
        NSLayoutConstraint.activate([
            artworkImageView.widthAnchor.constraint(equalToConstant: imageSize),
            artworkImageView.heightAnchor.constraint(equalToConstant: imageSize),
            artworkImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            artworkImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
        ])
        
        nameLabel.leadingAnchor.constraint(equalTo: artworkImageView.trailingAnchor, constant: 8).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8).isActive = true
        
        nameLabelConstraintTop = nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8)
        nameLabelContraintY =  nameLabel.centerYAnchor.constraint(equalTo: artworkImageView.centerYAnchor)
        nameLabelConstraintTop.isActive = false
        nameLabelContraintY.isActive = false
    }
    
    private func setupSubtitleLabel(string: String) {
        contentView.addSubview(subtitleLabel)
        subtitleLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4).isActive = true
        subtitleLabel.leadingAnchor.constraint(equalTo: artworkImageView.trailingAnchor, constant: 8).isActive = true
        subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8).isActive = true
        subtitleLabel.text = string
    }
    
    private func setupNameLabelConstraints(withSubtitleExistance isSubstitleExist: Bool) {
        nameLabelConstraintTop.isActive = isSubstitleExist
        nameLabelContraintY.isActive = !isSubstitleExist
    }
    
    public func configure(with viewModel: SCSearchResultsTableViewCellViewModel) {
        self.viewModel = viewModel
        nameLabel.text = viewModel.getName()
        artworkImageView.sd_setImage(with: viewModel.getArtworkURL())
        
        if let subtitle = viewModel.getSubtitle() {
            setupNameLabelConstraints(withSubtitleExistance: true)
            setupSubtitleLabel(string: subtitle)
            artworkImageView.layer.cornerRadius = 0
        } else {
            setupNameLabelConstraints(withSubtitleExistance: false)
            artworkImageView.layer.cornerRadius = imageSize / 2
        }
    }
    
}
