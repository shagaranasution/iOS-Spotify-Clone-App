//
//  SCActionLabelView.swift
//  SpotifyClone
//
//  Created by Shagara F Nasution on 20/09/23.
//

import UIKit

protocol SCActionLabelViewDelegate: AnyObject {
    func scActionLabelViewDidTapButton(_ view: SCActionLabelView)
}

final class SCActionLabelView: UIView {
    
    public weak var delegate: SCActionLabelViewDelegate?
    
    // MARK: - UI
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 3
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.setTitleColor(.link, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        isHidden = true
        addSubviews(label, button)
        addConstraints()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor),
            label.widthAnchor.constraint(equalTo: widthAnchor),
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            button.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 32),
            button.widthAnchor.constraint(equalTo: widthAnchor),
            button.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }
    
    private func setupActions() {
        button.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
    }
    
    @objc
    private func tapButton() {
        delegate?.scActionLabelViewDidTapButton(self)
    }
    
    public func configure(with viewModel: SCActionLabelViewViewModel) {
        label.text = viewModel.text
        button.setTitle(viewModel.actionTitle, for: .normal)
    }
    
}
