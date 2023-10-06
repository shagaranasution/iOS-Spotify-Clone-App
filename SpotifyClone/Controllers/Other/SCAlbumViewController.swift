//
//  SCAlbumViewController.swift
//  SpotifyClone
//
//  Created by Shagara F Nasution on 29/08/23.
//

import UIKit

final class SCAlbumViewController: UIViewController {
    
    private var album: SCAlbum? {
        didSet {
            guard let album = album else {
                return
            }
            
            title = album.name
        }
    }
    
    private var tracks: [SCTrack] = []
    private var viewModels: [SCTrackCollectionViewCellViewModel] = []
    private var orientation: UIDeviceOrientation {
        return UIDevice.current.orientation
    }
    
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
    
    init(album: SCAlbum) {
        self.album = album
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
        fetchAlbum()
        addGestures()
        setupNavBarRightButtonItem()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    // MARK: - Private methods
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func addGestures() {
        let gesture = UILongPressGestureRecognizer(
            target: self,
            action: #selector(handleLongPressGesture(_:))
        )
        collectionView.addGestureRecognizer(gesture)
    }
    
    private func setupNavBarRightButtonItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .action,
            target: self,
            action: #selector(tapRightBarButton)
        )
    }
    
    @objc func tapRightBarButton() {
        guard let album = album else { return }
        let actionSheet = UIAlertController(
            title: album.name,
            message: "Would you like to add this album to library?",
            preferredStyle: .actionSheet
        )
        actionSheet.addAction(
            UIAlertAction(
                title: "Cance",
                style: .cancel
            )
        )
        actionSheet.addAction(
            UIAlertAction(
                title: "Add to Library",
                style: .default,
                handler: { [weak self] _ in
                    self?.putAlbumToLibrary(album: album)
                }
            )
        )
        
        present(actionSheet, animated: true)
    }
    
    private func putAlbumToLibrary(album: SCAlbum) {
        SCAPICaller.shared.addAlbumToLibrary(
            album: album
        ) { isSuccess in
            if isSuccess {
                NotificationCenter.default.post(name: .albumSavedNotification, object: nil)
            }
        }
    }
    
    @objc
    private func handleLongPressGesture(_ gesture: UILongPressGestureRecognizer) {
        guard gesture.state == .began else {
            return
        }
        
        let touchPoint = gesture.location(in: collectionView)
        guard let indexPath = collectionView.indexPathForItem(at: touchPoint) else {
            return
        }
        
        let model = tracks[indexPath.item]
        let alertController = UIAlertController(
            title: model.name,
            message: "Would you like to add this song to playlist?",
            preferredStyle: .actionSheet
        )
        alertController.addAction(UIAlertAction(
            title: "Add to Playlist",
            style: .default,
            handler: { [weak self] _ in
                DispatchQueue.main.async {
                    let vc = SCLibraryPlaylistsViewController()
                    vc.registerDidSelectHandler { playlist in
                        SCAPICaller.shared.addTrackToPlaylist(
                            track: model,
                            playlist: playlist
                        ) { isSuccess in
                            if isSuccess {
                                print("Success adding \(model.name) to \(playlist.name)")
                            }
                        }
                    }
                    vc.title = "Select Playlist"
                    self?.present(
                        UINavigationController(rootViewController: vc),
                        animated: true
                    )
                }
            }
        ))
        alertController.addAction(UIAlertAction(title: "cancel", style: .cancel))
        
        present(alertController, animated: true)
    }
    
    private func fetchAlbum() {
        guard let album = album else {
            return
        }
        
        SCAPICaller.shared.getAlbum(album: album) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    guard let strongSelf = self else {
                        return
                    }
                    strongSelf.viewModels = model.tracks.items.compactMap({ track in
                        SCTrackCollectionViewCellViewModel(track: track)
                    })
                    strongSelf.tracks = model.tracks.items.compactMap { $0 }
                    for index in 0..<strongSelf.tracks.count {
                        strongSelf.tracks[index].album = album
                    }
                    strongSelf.collectionView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
}

// MARK: - Extension UICollectionView Delegate

extension SCAlbumViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
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
        return CGSize(width: collectionView.bounds.width, height: 70)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
              let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: SCTracklistHeaderCollectionReusableView.identifier,
                for: indexPath
              ) as? SCTracklistHeaderCollectionReusableView else {
            return UICollectionReusableView()
        }
        
        if let album = self.album {
            headerView.configure(
                with: SCTracklistHeaderCollectionReusableViewViewModel(
                    type: .album(model: album)
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
        }
        
        return CGSize(width: collectionView.frame.size.width, height: view.frame.size.height * 0.47)
    }
    
}

extension SCAlbumViewController: SCTracklistHeaderCollectionReusableViewDelegate {
    
    func scTracklistHeaderCollectionReusableView(_ view: SCTracklistHeaderCollectionReusableView, didTapPlayAll: Void) {
        SCPlaybackPresenter.shared.startPlayback(from: self, tracks: tracks, startAt: 0)
    }
    
}
