//
//  SCLibraryViewController.swift
//  SpotifyClone
//
//  Created by Shagara F Nasution on 22/08/23.
//

import UIKit

final class SCLibraryViewController: UIViewController {
    
    // MARK: - UI
    
    private lazy var playlistsVC: SCLibraryPlaylistsViewController = {
        let vc = SCLibraryPlaylistsViewController()
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        
        return vc
    }()
    private lazy var albumsVC: SCLibraryAlbumsViewController = {
        let vc = SCLibraryAlbumsViewController()
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        
        return vc
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var toggleView: SCLibraryToggleView = {
        let toggleView = SCLibraryToggleView()
        toggleView.translatesAutoresizingMaskIntoConstraints = false
        
        return toggleView
    }()
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        addBaseConstraints()
        addChildren()
        setupToggleView()
        updateNavigationBar()
        toggleView.delegate = self
        scrollView.delegate = self
        fetchData()
    }

    private func addBaseConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 55),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        let contentViewWidthConst = contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 2)
        contentViewWidthConst.isActive = true
        contentViewWidthConst.priority = UILayoutPriority(50)
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
        ])
    }
    
    private func addChildren() {
        addChild(playlistsVC)
        contentView.addSubview(playlistsVC.view)
        setupLibraryPlaylistsViewConstraints()
        playlistsVC.didMove(toParent: self)
        
        addChild(albumsVC)
        contentView.addSubview(albumsVC.view)
        setupLibraryAlbumssViewConstraints()
        albumsVC.didMove(toParent: self)
    }
    
    private func setupLibraryPlaylistsViewConstraints() {
        NSLayoutConstraint.activate([
            playlistsVC.view.topAnchor.constraint(equalTo: contentView.topAnchor),
            playlistsVC.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            playlistsVC.view.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            playlistsVC.view.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
        ])
    }
    
    private func setupLibraryAlbumssViewConstraints() {
        NSLayoutConstraint.activate([
            albumsVC.view.topAnchor.constraint(equalTo: contentView.topAnchor),
            albumsVC.view.leadingAnchor.constraint(equalTo: playlistsVC.view.trailingAnchor),
            albumsVC.view.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            albumsVC.view.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
        ])
    }
    
    private func setupToggleView() {
        view.addSubview(toggleView)
        NSLayoutConstraint.activate([
            toggleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            toggleView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            toggleView.widthAnchor.constraint(equalToConstant: 200),
            toggleView.heightAnchor.constraint(equalToConstant: 55),
        ])
    }
    
    private func updateNavigationBar() {
        switch toggleView.currentState {
        case .playlist:
            navigationItem.rightBarButtonItem = UIBarButtonItem(
                barButtonSystemItem: .add,
                target: self,
                action: #selector(tapRightBarButton)
            )
        case .album:
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    @objc
    private func tapRightBarButton() {
        playlistsVC.presentPlaylistCreationAlert()
    }
    
    private func fetchData() {
        switch toggleView.currentState {
        case .playlist:
            playlistsVC.fetchPlaylists()
        case .album:
            albumsVC.fetchAlbums()
        }
    }
    
}

// MARK: - Extension Scroll View Delegate

extension SCLibraryViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x >= self.view.width - 100 {
            toggleView.update(forState: .album)
        } else {
            toggleView.update(forState: .playlist)
        }
        fetchData()
        updateNavigationBar()
    }
    
}

// MARK: - Extension SCLibraryToggleView Delegate

extension SCLibraryViewController: SCLibraryToggleViewDelegate {
    
    func scLibraryToggleViewDidTapPlaylistButton(_ view: SCLibraryToggleView) {
        scrollView.setContentOffset(.zero, animated: true)
        fetchData()
        updateNavigationBar()
    }
    
    func scLibraryToggleViewDidTapAlbumButton(_ view: SCLibraryToggleView) {
        scrollView.setContentOffset(CGPoint(x: self.view.width, y: 0), animated: true)
        fetchData()
        updateNavigationBar()
    }
    
}
