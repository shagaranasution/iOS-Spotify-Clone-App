//
//  SCSearchResultsViewController.swift
//  SpotifyClone
//
//  Created by Shagara F Nasution on 22/08/23.
//

import UIKit

protocol SCSearchResultsViewControllerDelegate: AnyObject {
    func scSearchResultsViewController(_ viewController: SCSearchResultsViewController, didSelect result: SCSearchResult)
    func scSearchResultsViewController(_ viewController: SCSearchResultsViewController, didLongPress result: SCSearchResult)
}

final class SCSearchResultsViewController: UIViewController {
    
    public weak var delegate: SCSearchResultsViewControllerDelegate?
    
    private var viewModel: SCSearchResultsViewControllerViewModel? {
        didSet {
            guard viewModel != nil else {
                return
            }
            view.backgroundColor = .systemBackground
            tableView.isHidden = false
            tableView.reloadData()
        }
    }
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .systemBackground
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(SCSearchResultsTableViewCell.self,
                           forCellReuseIdentifier: SCSearchResultsTableViewCell.identifier)
        tableView.isHidden = true
        
        return tableView
    }()
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        view.addSubview(tableView)
        addConstraints()
        tableView.delegate = self
        tableView.dataSource = self
        addGestures()
    }
    
    // MARK: - Private Methods
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    private func addGestures() {
        let longPressGesture = UILongPressGestureRecognizer(
            target: self,
            action: #selector(handleLongPressGesture(_:))
        )
        tableView.addGestureRecognizer(longPressGesture)
    }
    
    @objc
    private func handleLongPressGesture(_ gesture: UILongPressGestureRecognizer) {
        guard gesture.state == .began else {
            return
        }
        let touchPoint = gesture.location(in: tableView)
        guard let indexPath = tableView.indexPathForRow(at: touchPoint),
        let result = viewModel?.sections[indexPath.section].items else {
            return
        }
        
        delegate?.scSearchResultsViewController(self, didLongPress: result[indexPath.row])
    }
    
    // MARK: - Public Methods
    
    public func update(with viewModel: SCSearchResultsViewControllerViewModel) {
        self.viewModel = viewModel
    }
    
}

extension SCSearchResultsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.sections.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.sections[section].items.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = self.viewModel,
              let cell = tableView.dequeueReusableCell(withIdentifier: SCSearchResultsTableViewCell.identifier)
                as? SCSearchResultsTableViewCell else {
            return UITableViewCell()
        }
        let cellViewModel = SCSearchResultsTableViewCellViewModel(
            name: viewModel.getName(forItemAtIndex: indexPath.item, section: indexPath.section),
            subtitle: viewModel.getSubtitle(forItemAtIndex: indexPath.item, section: indexPath.section),
            artworkUrlString: viewModel.getArtworkURL(forItemAtIndex: indexPath.item, section: indexPath.section)
        )
        cell.configure(with: cellViewModel)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel?.sections[section].title
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let results = viewModel?.sections[indexPath.section].items else {
            return
        }
        delegate?.scSearchResultsViewController(self, didSelect: results[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
    
}
