//
//  SCSearchViewController.swift
//  SpotifyClone
//
//  Created by Shagara F Nasution on 22/08/23.
//

import UIKit
import SafariServices

final class SCSearchViewController: UIViewController {
    
    private var categories: [SCCategory] = []
    private var timer: Timer?
    
    private let searchController: UISearchController = {
        let searchResultsVC = SCSearchResultsViewController()
        let searchVC = UISearchController(searchResultsController: searchResultsVC)
        searchVC.searchBar.placeholder = "Songs, Artists, Albums, Playlists"
        searchVC.searchBar.searchBarStyle = .minimal
        searchVC.definesPresentationContext = true
        
        return searchVC
    }()
    
    private var collectionView: UICollectionView?
    
    // MARK: - UIViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        let collectionView = createCollectionView()
        self.collectionView = collectionView
        view.addSubview(collectionView)
        addConstraints()
        fetchCategories()
    }
    
    // MARK: - Private Method
    
    private func addConstraints() {
        guard let collectionView = self.collectionView else {
            return
        }
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func fetchCategories() {
        SCAPICaller.shared.getCategories { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    self?.categories = model.categories.items
                    self?.collectionView?.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}

// MARK: - Extension CollectionView Creation

extension SCSearchViewController {
    
    private func createCollectionView() -> UICollectionView {
        let layout = UICollectionViewCompositionalLayout { [weak self] _, _ in
            self?.createSectionLayout()
        }
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(
            SCCategoryCollectionViewCell.self,
            forCellWithReuseIdentifier: SCCategoryCollectionViewCell.identifier
        )
        collectionView.delegate = self
        collectionView.dataSource = self
        
        return collectionView
    }
    
    private func createSectionLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.5),
                heightDimension: .fractionalHeight(1)
            )
        )
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 8,
            bottom: 0,
            trailing: 8
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(120)
            ),
            subitems: [item]
        )
        group.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 8,
            bottom: 16,
            trailing: 8
        )
        let sectionLayout = NSCollectionLayoutSection(group: group)
        
        return sectionLayout
    }
    
}

// MARK: - Extension UISearchResultsUpdating

extension SCSearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchResultsVC = searchController.searchResultsController as? SCSearchResultsViewController,
              let query = searchController.searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.count > 2 else {
            return
        }
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { _ in
            SCAPICaller.shared.getSearchResults(q: query) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let model):
                        let viewModel = SCSearchResultsViewControllerViewModel(model: model)
                        searchResultsVC.update(with: viewModel)
                        searchResultsVC.delegate = self
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
        })
    }
    
}

// MARK: - Extension UICollectionView Delegate

extension SCSearchViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SCCategoryCollectionViewCell.identifier,
            for: indexPath
        ) as? SCCategoryCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: SCCategoryCollectionViewCellViewModel(category: categories[indexPath.item]))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let category = categories[indexPath.item]
        let vc = SCCategoryPlaylistViewController(category: category)
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.title = category.name
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

// MARK: - Extension

extension SCSearchViewController: SCSearchResultsViewControllerDelegate {
    
    func scSearchResultsViewController(_ viewController: SCSearchResultsViewController, didSelect result: SCSearchResult) {
        switch result {
        case .albums(let model):
            let vc = SCAlbumViewController(album: model)
            vc.title = model.name
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
        case .playlists(let model):
            let vc = SCPlaylistViewController(playlist: model)
            vc.title = model.name
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
        case .tracks(let model):
            SCPlaybackPresenter.shared.startPlayback(from: self, track: model)
        case .artists(let model):
            guard let url = URL(string: model.externalUrls.spotify) else {
                return
            }
            let vc = SFSafariViewController(url: url)
            navigationController?.present(vc, animated: true)
        }
    }
    
    func scSearchResultsViewController(_ viewController: SCSearchResultsViewController, didLongPress result: SCSearchResult) {
        switch result {
        case .tracks(let model):
            let alertController = UIAlertController(
                title: model.name,
                message: "Would you like to add this song to playlist?",
                preferredStyle: .actionSheet
            )
            alertController.addAction(UIAlertAction(
                title: "Select to Playlist",
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
                        self?.present(UINavigationController(rootViewController: vc), animated: true)
                    }
                }
            ))
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            
            present(alertController, animated: true)
        default:
            break
        }
    }
    
}
