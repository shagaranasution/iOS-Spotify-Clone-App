//
//  SCHeaderTitleCollectionReusableView.swift
//  SpotifyClone
//
//  Created by Shagara F Nasution on 05/09/23.
//

import UIKit

final class SCHeaderTitleCollectionReusableView: UICollectionReusableView {
        
    static let identifier = "SCHeaderTitleCollectionReusableView"
    
    private lazy var titleLabel: UILabel = {
        let title = UILabel()
        title.textColor = .label
        title.numberOfLines = 1
        title.font = UIFont.systemFont(ofSize: 22, weight: .regular)
        title.translatesAutoresizingMaskIntoConstraints = false
        
        return title
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
        ])
    }
    
    public func configure(with title: String) {
        titleLabel.text = title
    }
    
}
