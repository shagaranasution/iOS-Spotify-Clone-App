//
//  SCCategoryPlaylistViewController.swift
//  SpotifyClone
//
//  Created by Shagara F Nasution on 07/09/23.
//

import UIKit

final class SCCategoryPlaylistViewController: UIViewController {
    
    private var category: SCCategory?
    private var playlists: [SCSimplifiedPlaylist] = []
    
    private var collectionView: UICollectionView?
    
    // MARK: - Initialization
    
    init(category: SCCategory) {
        self.category = category
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    // MARK: - UIViewController Livecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        let collectionView = createCollectionView()
        self.collectionView = collectionView
        view.addSubview(collectionView)
        addConstraints()
        fetchCategoryPlaylists()
    }
    
    private func addConstraints() {
        guard let collectionView = self.collectionView else {
            return
        }
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    private func fetchCategoryPlaylists() {
        guard let category = self.category else {
            return
        }
        
        SCAPICaller.shared.getCategoryPlaylists(category: category) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    self?.playlists = model.playlists.items
                    self?.collectionView?.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
}

// MARK: - Extension UICollectionView Instance Creation

extension SCCategoryPlaylistViewController {
    
    private func createCollectionView() -> UICollectionView {
        let layout = UICollectionViewCompositionalLayout { [weak self] _, _ in
            return self?.createSectionLayout()
        }
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.register(SCFeaturePlaylistCollectionViewCell.self,
                                forCellWithReuseIdentifier: SCFeaturePlaylistCollectionViewCell.identifier)
        collectionView.backgroundColor = .systemBackground
        collectionView.translatesAutoresizingMaskIntoConstraints = false
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
            leading: 4,
            bottom: 0,
            trailing: 4
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(200)
            ),
            subitems: [item]
        )
        group.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading:8,
            bottom: 8,
            trailing: 8
        )
        
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
}

// MARK: - Extension UICollectionView Delegate

extension SCCategoryPlaylistViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return playlists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SCFeaturePlaylistCollectionViewCell.identifier,
            for: indexPath
        ) as? SCFeaturePlaylistCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(
            with: SCFeaturePlaylistCollectionViewCellViewModel(
                playlist: playlists[indexPath.item]
            )
        )
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let playlist = playlists[indexPath.item]
        let vc = SCPlaylistViewController(playlist: playlist)
        vc.title = playlist.name
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
