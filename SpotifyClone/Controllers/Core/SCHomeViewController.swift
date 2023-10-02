//
//  SCHomeViewController.swift
//  SpotifyClone
//
//  Created by Shagara F Nasution on 22/08/23.
//

import UIKit

enum BrowseSectionType {
    case newReleases(viewModels: [SCNewReleaseCollectionViewCellViewModel])
    case featurePlaylists(viewModels: [SCFeaturePlaylistCollectionViewCellViewModel])
    case recommendedTracks(viewModels: [SCTrackCollectionViewCellViewModel])
    
    public var title: String {
        switch self {
        case .newReleases:
            return "New Released Albums"
        case .featurePlaylists:
            return "Featured Playlists"
        case .recommendedTracks:
            return "Recommended"
        }
    }
}

final class SCHomeViewController: UIViewController {
    
    private var sections: [BrowseSectionType] = []
    private var newAlbums: [SCAlbum] = []
    private var playlists: [SCSimplifiedPlaylist] = []
    private var tracks: [SCTrack] = []
    
    private var collectionView: UICollectionView?
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.tintColor = .label
        spinner.hidesWhenStopped = true
        
        return spinner
    }()
    
    // MARK: - UIViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNavBarRightButtonItem()
        fetchData()
        let collectionView = createCollectionView()
        self.collectionView = collectionView
        view.addSubviews(collectionView, spinner)
        addGestures()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.frame = view.bounds
        spinner.center = view.center
    }
    
    // MARK: Private Methods
    
    private func fetchData() {
        let group = DispatchGroup()
        group.enter()
        group.enter()
        group.enter()
        
        var newReleasesResponse: SCGetNewReleasesResponse?
        var featuredPlaylistsReponse: SCGetFeaturedPlaylistsResponse?
        var recommendationsResponse: SCGetRecommendationsResponse?
        
        SCAPICaller.shared.getNewReleases { result in
            defer {
                group.leave()
            }
            switch result {
            case .success(let model):
                newReleasesResponse = model
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        SCAPICaller.shared.getFeaturedPlaylists { result in
            defer {
                group.leave()
            }
            switch result {
            case .success(let model):
                featuredPlaylistsReponse = model
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        SCAPICaller.shared.getRecommendationGenres { result in
            switch result {
            case .success(let model):
                var seeds: Set<SCGenre> = []
                while seeds.count < 5 {
                    if let genre = model.genres.randomElement() {
                        seeds.insert(genre)
                    }
                }
                
                SCAPICaller.shared.getRecommendations(
                    genres: seeds
                ) { recommendationsResult in
                    defer {
                        group.leave()
                    }
                    switch recommendationsResult {
                    case .success(let model):
                        recommendationsResponse = model
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            guard let newAlbums = newReleasesResponse?.albums.items,
                  let playlists = featuredPlaylistsReponse?.playlists.items,
                  let tracks = recommendationsResponse?.tracks else {
                return
            }
            
            self?.configureViewModels(
                newAlbums: newAlbums,
                playlists: playlists,
                tracks: tracks
            )
            
            self?.collectionView?.reloadData()
        }
    }
    
    private func addGestures() {
        guard let collectionView = collectionView else {
            return
        }
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture(_:)))
        collectionView.addGestureRecognizer(longPressGesture)
    }
    
    @objc
    private func handleLongPressGesture(_ gesture: UILongPressGestureRecognizer) {
        guard gesture.state == .began else {
            return
        }
        
        let touchPoint = gesture.location(in: collectionView)
        guard let indexPath = collectionView?.indexPathForItem(at: touchPoint),
              indexPath.section == 2 else {
            return
        }
        
        let model = tracks[indexPath.row]
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
                            playlist: playlist) { isSuccess in
                                guard isSuccess else{
                                    return
                                }
                                
                                print("Success adding \(model.name) to playlist")
                            }
                    }
                    vc.title = "Select Playlist"
                    self?.present(UINavigationController(rootViewController: vc), animated: true)
                }
            }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alertController, animated: true)
    }
    
    private func configureViewModels(
        newAlbums: [SCAlbum],
        playlists: [SCSimplifiedPlaylist],
        tracks: [SCTrack]
    ) {
        self.newAlbums = newAlbums
        self.playlists = playlists
        self.tracks = tracks
        
        sections.append(.newReleases(
            viewModels: newAlbums.compactMap({ album in
                SCNewReleaseCollectionViewCellViewModel(album: album)
            }))
        )
        sections.append(.featurePlaylists(
            viewModels: playlists.compactMap({ playlist in
                SCFeaturePlaylistCollectionViewCellViewModel(playlist: playlist)
            }))
        )
        sections.append(.recommendedTracks(
            viewModels: tracks.compactMap({ track in
                SCTrackCollectionViewCellViewModel(track: track)
            }))
        )
    }
    
    private func setupNavBarRightButtonItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "gear"),
            style: .done,
            target: self,
            action: #selector(tapSettings)
        )
    }
    
    @objc
    private func tapSettings() {
        let vc = SCSettingsViewController()
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

// MARK: - Extension CollectionView Creation
extension SCHomeViewController {
    
    private func createCollectionView() -> UICollectionView {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            return self?.createSectionLayout(ofSection: sectionIndex)
        }
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.register(SCNewReleaseCollectionViewCell.self,
                                forCellWithReuseIdentifier: SCNewReleaseCollectionViewCell.identifier)
        collectionView.register(SCFeaturePlaylistCollectionViewCell.self,
                                forCellWithReuseIdentifier: SCFeaturePlaylistCollectionViewCell.identifier)
        collectionView.register(SCTrackCollectionViewCell.self,
                                forCellWithReuseIdentifier: SCTrackCollectionViewCell.identifier)
        collectionView.register(SCHeaderTitleCollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: SCHeaderTitleCollectionReusableView.identifier)
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        
        return collectionView
    }
    
    private func createSectionLayout(ofSection index: Int) -> NSCollectionLayoutSection {
        let suplementaryItems = [
            NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(50)
                ),
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
        ]
        
        switch index {
        case 0:
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                   heightDimension: .absolute(390/3))
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 8, trailing: 8)
            
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.95),
                                                   heightDimension: .absolute(390)),
                subitems: [item]
            )
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .groupPaging
            section.boundarySupplementaryItems = suplementaryItems
            
            return section
        case 1:
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(200),
                                                   heightDimension: .absolute(200))
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 8, trailing: 8)
            
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(200),
                                                   heightDimension: .absolute(400)),
                subitems: [item]
            )
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            section.boundarySupplementaryItems = suplementaryItems
            
            return section
        case 2:
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                   heightDimension: .fractionalHeight(1))
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 8, trailing: 8)
            
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                   heightDimension: .absolute(70)),
                subitems: [item]
            )
            
            let section = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = suplementaryItems
            
            return section
        default:
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                   heightDimension: .fractionalHeight(1))
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                   heightDimension: .absolute(100)),
                subitems: [item]
            )
            
            let section = NSCollectionLayoutSection(group: group)
            
            return section
        }
    }
    
}

// MARK: - Extension UICollectionViewDelegate
extension SCHomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let section = sections[section]
        switch section {
        case .newReleases(let viewModels):
            return viewModels.count
        case .featurePlaylists(let viewModels):
            return viewModels.count
        case .recommendedTracks(let viewModels):
            return viewModels.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = sections[indexPath.section]
        switch section {
        case .newReleases(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: SCNewReleaseCollectionViewCell.identifier,
                for: indexPath
            ) as? SCNewReleaseCollectionViewCell else {
                break
            }
            cell.configure(with: viewModels[indexPath.item])
            
            return cell
        case .featurePlaylists(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: SCFeaturePlaylistCollectionViewCell.identifier,
                for: indexPath
            ) as? SCFeaturePlaylistCollectionViewCell else {
                break
            }
            cell.configure(with: viewModels[indexPath.item])
            
            return cell
        case .recommendedTracks(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: SCTrackCollectionViewCell.identifier,
                for: indexPath
            ) as? SCTrackCollectionViewCell else {
                break
            }
            cell.configure(with: viewModels[indexPath.item])
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        switch sections[indexPath.section] {
        case .newReleases:
            let album = newAlbums[indexPath.item]
            let vc = SCAlbumViewController(album: album)
            vc.title = album.name
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
        case .featurePlaylists:
            let playlist = playlists[indexPath.item]
            let vc = SCPlaylistViewController(playlist: playlist)
            vc.title = playlist.name
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
        case .recommendedTracks:
            SCPlaybackPresenter.shared.startPlayback(from: self, track: tracks[indexPath.item])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
              let titleView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: SCHeaderTitleCollectionReusableView.identifier,
                for: indexPath
              ) as? SCHeaderTitleCollectionReusableView else {
            return UICollectionReusableView()
        }
        titleView.configure(with: sections[indexPath.section].title)
        
        return titleView
    }
    
}

