//
//  SCLibraryPlaylistsViewController.swift
//  SpotifyClone
//
//  Created by Shagara F Nasution on 19/09/23.
//

import UIKit

final class SCLibraryPlaylistsViewController: UIViewController {
    
    private var playlists: [SCSimplifiedPlaylist] = []
    private var didSelectHandler: ((SCSimplifiedPlaylist) -> Void)?
    
    // MARK: - UI
    
    private lazy var noCreatedPlaylistView = SCActionLabelView()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SCLibraryTableViewCell.self,
                           forCellReuseIdentifier: SCLibraryTableViewCell.identifier)
        tableView.backgroundColor = .systemBackground
        tableView.separatorStyle = .none
        tableView.isHidden = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNoCreatedPlaylistView()
        noCreatedPlaylistView.delegate = self
        view.addSubview(tableView)
        layoutTableView()
        tableView.delegate = self
        tableView.dataSource = self
        
        if didSelectHandler != nil {
            fetchPlaylists()
            navigationItem.leftBarButtonItem = UIBarButtonItem(
                barButtonSystemItem: .cancel,
                target: self,
                action: #selector(tapLeftBarButton)
            )
            navigationItem.leftBarButtonItem?.tintColor = .label
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        noCreatedPlaylistView.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        noCreatedPlaylistView.center = view.center
    }
    
    // MARK: - Private Methods
    
    @objc
    private func tapLeftBarButton() {
        dismiss(animated: true)
    }
    
    private func setupNoCreatedPlaylistView() {
        noCreatedPlaylistView.configure(
            with: SCActionLabelViewViewModel(
                text: "You don't have any playlists yet.",
                actionTitle: "Create"
            )
        )
        view.addSubviews(noCreatedPlaylistView)
    }
    
    private func layoutTableView() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func updateUI() {
        noCreatedPlaylistView.isHidden = !playlists.isEmpty
        tableView.isHidden = playlists.isEmpty
        tableView.reloadData()
    }
    
    // MARK: - Public Methods
    
    public func fetchPlaylists() {
        SCAPICaller.shared.getCurrentUserPlaylists { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    self?.playlists = model
                    self?.updateUI()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    public func presentPlaylistCreationAlert() {
        let alert = UIAlertController(
            title: "New Playlist",
            message: "Enter playlist name.",
            preferredStyle: .alert
        )
        alert.addTextField { textField in
            textField.placeholder = "My Playlist"
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Create", style: .default, handler: { _ in
            guard let field = alert.textFields?.first,
                  let text = field.text,
                  !text.trimmingCharacters(in: .whitespaces).isEmpty else {
                return
            }
            SCAPICaller.shared.createPlaylist(with: text) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let playlist):
                        self?.playlists.append(playlist)
                        self?.tableView.reloadData()
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
        }))
        present(alert, animated: true)
    }
    
    public func registerDidSelectHandler(_ block: @escaping (SCSimplifiedPlaylist) -> Void) {
        self.didSelectHandler = block
    }
    
}

// MARK: - Extension TableView Delegate

extension SCLibraryPlaylistsViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SCLibraryTableViewCell.identifier,
            for: indexPath
        ) as? SCLibraryTableViewCell else {
            return UITableViewCell()
        }
        let playlist = playlists[indexPath.row]
        let cellViewModel = SCLibraryTableViewCellViewModel(
            title: playlist.name,
            subtitle: playlist.owner.displayName,
            artworkImageURLString: playlist.images.first?.url
        )
        cell.configure(with: cellViewModel)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let playlist = playlists[indexPath.row]
        guard didSelectHandler == nil else {
            didSelectHandler?(playlist)
            dismiss(animated: true)
            return
        }
        let vc = SCPlaylistViewController(playlist: playlist)
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.title = playlist.name
        vc.setIsOwner(true)
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

// MARK: - Extension ActionLabelView Delegate

extension SCLibraryPlaylistsViewController: SCActionLabelViewDelegate {
    
    func scActionLabelViewDidTapButton(_ view: SCActionLabelView) {
        presentPlaylistCreationAlert()
    }
    
}
