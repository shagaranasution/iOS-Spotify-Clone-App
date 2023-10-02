//
//  SCPlayerControlsView.swift
//  SpotifyClone
//
//  Created by Shagara F Nasution on 14/09/23.
//

import UIKit
import AVFoundation

protocol SCPlayerControlsViewDelegate: AnyObject {
    func scPlayerControlsView(_ view: SCPlayerControlsView, didTapBackwardButton completion: ((AVPlayer.TimeControlStatus) -> Void)?)
    func scPlayerControlsView(_ view: SCPlayerControlsView, didTapForwardButton completion: ((AVPlayer.TimeControlStatus) -> Void)?)
    func scPlayerControlsView(_ view: SCPlayerControlsView, didTapPlayPauseButton completion: ((AVPlayer.TimeControlStatus) -> Void)?)
    func scPlayerControlsView(_ view: SCPlayerControlsView, didSlideVolumeSlider value: Float)
}

final class SCPlayerControlsView: UIView {
    
    public weak var delegate: SCPlayerControlsViewDelegate?
    
    // MARK: - UI
    
    private lazy var playPauseButtonImageConfiguration: UIImage.SymbolConfiguration = UIImage.SymbolConfiguration(
        pointSize: 56,
        weight: .light
    )
    
    private lazy var playButtonImage: UIImage? = UIImage(
        systemName: "play.circle",
        withConfiguration: playPauseButtonImageConfiguration
    )
    
    private lazy var pauseButtonImage: UIImage? = UIImage(
        systemName: "pause.circle",
        withConfiguration: playPauseButtonImageConfiguration
    )
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.text = "This is My Song"
        
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.text = "This is My Album"
        
        return label
    }()
    
    private lazy var labelsStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 8
        view.addArrangedSubviews(nameLabel, subtitleLabel)
        
        return view
    }()
    
    private lazy var volumeSlider: UISlider = {
        let slider = UISlider()
        slider.value = 0.5
        slider.tintColor = .label
        slider.thumbTintColor = .label
        
        return slider
    }()
    
    private lazy var backwardButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(
            systemName: "backward.end.fill",
            withConfiguration: UIImage.SymbolConfiguration(
                pointSize: 26,
                weight: .regular
            )
            
        )
        button.setImage(image, for: .normal)
        
        return button
    }()
    
    private lazy var forwardButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(
            systemName: "forward.end.fill",
            withConfiguration: UIImage.SymbolConfiguration(
                pointSize: 26,
                weight: .light
            )
        )
        button.setImage(image, for: .normal)
        
        return button
    }()
    
    private lazy var playPauseButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        button.setImage(pauseButtonImage, for: .normal)
        
        return button
    }()
    
    private lazy var horizontalStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillProportionally
        view.addArrangedSubviews(backwardButton, playPauseButton, forwardButton)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var verticalStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .equalSpacing
        view.addArrangedSubviews(labelsStackView, volumeSlider, horizontalStackView)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        clipsToBounds = true
        setupViews()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    private func setupViews() {
        addSubview(verticalStackView)
        
        NSLayoutConstraint.activate([
            verticalStackView.widthAnchor.constraint(equalTo: widthAnchor),
            verticalStackView.heightAnchor.constraint(equalTo: heightAnchor),
        ])
    }
    
    private func setupActions() {
        backwardButton.addTarget(self, action: #selector(tapBackwardButton), for: .touchUpInside)
        forwardButton.addTarget(self, action: #selector(tapForwardButton), for: .touchUpInside)
        playPauseButton.addTarget(self, action: #selector(tapPlayPauseButton), for: .touchUpInside)
        volumeSlider.addTarget(self, action: #selector(slideVolumeSlider(_:)), for: .valueChanged)
    }
    
    private func setPlayPauseButtonImage(with timeControlStatus: AVPlayer.TimeControlStatus) {
        switch timeControlStatus {
        case .playing:
            playPauseButton.setImage(pauseButtonImage, for: .normal)
        case .paused:
            playPauseButton.setImage(playButtonImage, for: .normal)
        default:
            break
        }
    }
    
    @objc
    private func tapBackwardButton() {
        delegate?.scPlayerControlsView(self, didTapBackwardButton: { [weak self] timeControlStatus in
            self?.setPlayPauseButtonImage(with: timeControlStatus)
        })
    }
    
    @objc
    private func tapForwardButton() {
        delegate?.scPlayerControlsView(self, didTapForwardButton: { [weak self] timeControlStatus in
            self?.setPlayPauseButtonImage(with: timeControlStatus)
        })
    }
    
    @objc
    private func tapPlayPauseButton() {
        delegate?.scPlayerControlsView(self, didTapPlayPauseButton: { [weak self] timeControlStatus in
            self?.setPlayPauseButtonImage(with: timeControlStatus)
        })
    }
    
    @objc
    private func slideVolumeSlider(_ slider: UISlider) {
        delegate?.scPlayerControlsView(self, didSlideVolumeSlider: slider.value)
    }
    
    // MARK: - Public Methods
    
    public func configure(with viewModel: SCPlayerControlsViewViewModel) {
        nameLabel.text = viewModel.getTitle()
        subtitleLabel.text = viewModel.getSubtitle()
    }
    
}
