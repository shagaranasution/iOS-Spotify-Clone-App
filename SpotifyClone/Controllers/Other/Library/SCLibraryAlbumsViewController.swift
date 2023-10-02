//
//  SCLibraryAlbumsViewController.swift
//  SpotifyClone
//
//  Created by Shagara F Nasution on 19/09/23.
//

import UIKit

final class SCLibraryAlbumsViewController: UIViewController {
    
    private var savedAlbums: [SCSavedAlbum] = []
    
    // MARK: - UI
    
    private lazy var noSavedAlbumView = SCActionLabelView()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemBackground
        tableView.separatorStyle = .none
        tableView.register(SCLibraryTableViewCell.self,
                           forCellReuseIdentifier: SCLibraryTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNoCreatedPlaylistView()
        view.addSubview(tableView)
        addConstraints()
        tableView.dataSource = self
        tableView.delegate = self
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleAlbumSavedNotification),
            name: .albumSavedNotification,
            object: nil
        )
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        noSavedAlbumView.frame = CGRect(
            x: view.width / 2 - 150/2,
            y: view.height / 2 - 150/2 - 30,
            width: 150,
            height: 150
        )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Private Methods
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func setupNoCreatedPlaylistView() {
        noSavedAlbumView.configure(
            with: SCActionLabelViewViewModel(
                text: "You don't have any saved album yet.",
                actionTitle: "Browse"
            )
        )
        view.addSubview(noSavedAlbumView)
        noSavedAlbumView.delegate = self
    }
    
    private func updateUI() {
        noSavedAlbumView.isHidden = !savedAlbums.isEmpty
        tableView.isHidden = savedAlbums.isEmpty
        tableView.reloadData()
    }
    
    @objc
    private func handleAlbumSavedNotification() {
        fetchAlbums()
    }
    
    // MARK: - Public Methods
    
    public func fetchAlbums() {
        SCAPICaller.shared.getUserSavedAlbums { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    DispatchQueue.main.async {
                        self?.savedAlbums = model.items
                        self?.updateUI()
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
}

extension SCLibraryAlbumsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedAlbums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SCLibraryTableViewCell.identifier,
            for: indexPath
        ) as? SCLibraryTableViewCell else {
            return UITableViewCell()
        }
        
        let album = savedAlbums[indexPath.row].album
        let cellViewModel = SCLibraryTableViewCellViewModel(
            title: album.name,
            subtitle: album.artists.compactMap { $0.name }.joined(separator: ", "),
            artworkImageURLString: album.images.first?.url
        )
        cell.configure(with: cellViewModel)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let album = savedAlbums[indexPath.row].album
        let vc = SCAlbumViewController(album: album)
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.title = album.name
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension SCLibraryAlbumsViewController: SCActionLabelViewDelegate {
    
    func scActionLabelViewDidTapButton(_ view: SCActionLabelView) {
        let vc = SCHomeViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
