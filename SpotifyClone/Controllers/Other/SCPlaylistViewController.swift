//
//  SCPlaylistViewController.swift
//  SpotifyClone
//
//  Created by Shagara F Nasution on 22/08/23.
//

import UIKit

final class SCPlaylistViewController: UIViewController {
    
    private var playlist: SCSimplifiedPlaylist? {
        didSet {
            guard let playlist = playlist else {
                return
            }
            
            title = playlist.name
        }
    }
    
    private var viewModels: [SCTrackCollectionViewCellViewModel] = []
    private var tracks: [SCTrack] = []
    private(set) var isOwner = false
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.register(
            SCTrackCollectionViewCell.self,
            forCellWithReuseIdentifier: SCTrackCollectionViewCell.identifier
        )
        collectionView.register(
            SCTracklistHeaderCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SCTracklistHeaderCollectionReusableView.identifier
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    // MARK: - Initialization
    
    init(playlist: SCSimplifiedPlaylist) {
        self.playlist = playlist
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    // MARK: - UIViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        setupCollectionView()
        addConstraints()
        fetchPlaylist()
        configureRightBarNavigationItem()
        addGestures()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    // MARK: - Private methods
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func configureRightBarNavigationItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .action,
            target: self,
            action: #selector(tapShareButton)
        )
    }
    
    private func addGestures() {
        let gesture = UILongPressGestureRecognizer(
            target: self,
            action: #selector(hadleLongPressGesture(_:))
        )
        collectionView.addGestureRecognizer(gesture)
    }
    
    @objc
    private func hadleLongPressGesture(_ gesture: UILongPressGestureRecognizer) {
        guard gesture.state == .began else {
            return
        }
        
        let touchPoint = gesture.location(in: collectionView)
        guard let indexPath = collectionView.indexPathForItem(at: touchPoint) else {
            return
        }
        
        presentActionSheet(forSelectedTrackAt: indexPath)
    }
    
    private func presentActionSheet(forSelectedTrackAt indexPath: IndexPath) {
        let actionSheetMessage = isOwner ?
        "Would you like to remove this song from playlist?"
        : "Would you like to add this song to playlist?"
        let actionSheetActionTitle = isOwner ?
        "Remove from Playlist"
        : "Add to Playlist"
        let model = tracks[indexPath.item]
        
        let actionSheet = UIAlertController(
            title: model.name,
            message: actionSheetMessage,
            preferredStyle: .actionSheet
        )
        actionSheet.addAction(UIAlertAction(
            title: actionSheetActionTitle,
            style: .default,
            handler: { [weak self] _ in
                guard let strongSelf = self else {
                    return
                }
                if strongSelf.isOwner {
                    strongSelf.handleRemoveTrackFromPlaylistAction(at: indexPath)
                } else {
                    strongSelf.handleAddingTrackToPlaylistAction(with: model)
                }
            }
        ))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(actionSheet, animated: true)
    }
    
    private func handleRemoveTrackFromPlaylistAction(at indexPath: IndexPath) {
        guard let playlist = self.playlist,
              let track = tracks.first(where: { item in
                  item.id == tracks[indexPath.row].id
              }) else {
            return
        }

        SCAPICaller.shared.removeTrackFromPlaylist(
            track: track,
            playlist: playlist
        ) { [weak self] isSuccess in
            DispatchQueue.main.async {
                guard let strongSelf = self else {
                    return
                }
                
                if isSuccess {
                    strongSelf.tracks.remove(at: indexPath.row)
                    strongSelf.viewModels.remove(at: indexPath.row)
                    strongSelf.collectionView.reloadData()
                }
            }
        }
    }
    
    private func handleAddingTrackToPlaylistAction(with model: SCTrack) {
        let vc = SCLibraryPlaylistsViewController()
        vc.registerDidSelectHandler { playlist in
            SCAPICaller.shared.addTrackToPlaylist(
                track: model,
                playlist: playlist
            ) { isSuccess in
                DispatchQueue.main.async {
                    if isSuccess {
                        print("Success adding \(model.name) to \(playlist.name)")
                    }
                }
            }
        }
        vc.title = "Select Playlist"
        present(UINavigationController(rootViewController: vc), animated: true)
    }
    
    @objc
    private func tapShareButton() {
        guard let url = URL(string: playlist?.externalUrls.spotify ?? "") else {
            return
        }
        let vc = UIActivityViewController(
            activityItems: [url],
            applicationActivities: []
        )
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    
    private func fetchPlaylist() {
        guard let playlist = playlist else {
            return
        }
        
        SCAPICaller.shared.getPlaylist(playlist: playlist) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    self?.tracks = model.tracks.items.compactMap { $0.track }
                    self?.viewModels = model.tracks.items.compactMap({ playlist in
                        guard let track = playlist.track else {
                            return nil
                        }
                        return SCTrackCollectionViewCellViewModel(track: track)
                    })
                    self?.collectionView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    // MARK: - Public Mathods
    
    public func setIsOwner(_ isOwner: Bool) {
        self.isOwner = isOwner
    }
}

extension SCPlaylistViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SCTrackCollectionViewCell.identifier,
            for: indexPath
        ) as? SCTrackCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: viewModels[indexPath.item])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        SCPlaybackPresenter.shared.startPlayback(from: self, tracks: tracks, startAt: indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width - 8, height: 70)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
              let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: SCTracklistHeaderCollectionReusableView.identifier,
                for: indexPath
              ) as? SCTracklistHeaderCollectionReusableView,
              kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        
        if let playlist = self.playlist {
            headerView.configure(
                with: SCTracklistHeaderCollectionReusableViewViewModel(
                    type: .playlist(model: playlist)
                )
            )
        }
        headerView.delegate = self
        
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        // TODO: Make size dynamic following total height of its contents
        if let windowScene = view.window?.windowScene {
            let orientation = windowScene.interfaceOrientation
            switch orientation {
            case .portrait, .portraitUpsideDown:
                return CGSize(width: collectionView.frame.size.width, height: view.frame.size.height * 0.47)
            case .landscapeLeft, .landscapeRight:
                return CGSize(width: collectionView.frame.size.width, height: 350)
            default:
                return CGSize(width: collectionView.frame.size.width, height: view.frame.size.height * 0.47)
            }
        } else {
            return CGSize(width: collectionView.frame.size.width, height: view.frame.size.height * 0.47)
        }
        
    }
    
}

// MARK: - Extension SCPlaylistHeaderCollectionReusableViewDelegate

extension SCPlaylistViewController: SCTracklistHeaderCollectionReusableViewDelegate {
    
    func scTracklistHeaderCollectionReusableView(_ view: SCTracklistHeaderCollectionReusableView, didTapPlayAll: Void) {
        SCPlaybackPresenter.shared.startPlayback(from: self, tracks: tracks, startAt: 0)
    }
    
}
