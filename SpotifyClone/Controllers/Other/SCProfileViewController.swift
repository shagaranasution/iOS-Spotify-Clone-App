//
//  SCProfileViewController.swift
//  SpotifyClone
//
//  Created by Shagara F Nasution on 22/08/23.
//

import UIKit
import SDWebImage

final class SCProfileViewController: UIViewController {
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.isHidden = true
        tableView.separatorStyle = .none
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        return tableView
    }()
    
    private var models: [String] = []
    
    // MARK: - UIViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Profile"
        view.backgroundColor = .systemBackground
        fetchProfile()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.bounds
    }
    
    // MARK: - Private Methods
    
    private func fetchProfile() {
        SCAPICaller.shared.getCurrentUserProfile { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    self?.showProfile(with: model)
                case .failure:
                    self?.showProfileError()
                }
            }
        }
    }
    
    private func createTableHeader(with string: String?) {
        guard let urlString = string,
              let url = URL(string: urlString) else {
            return
        }
        let headerView = UIView(
            frame: CGRect(x: 0,
                          y: 0,
                          width: view.width,
                          height: view.width/1.5)
        )
        let imageSize: CGFloat = headerView.height/2
        let imageView = UIImageView(
            frame: CGRect(x: 0,
                          y: 0,
                          width: imageSize,
                          height: imageSize)
        )
        headerView.addSubview(imageView)
        imageView.contentMode = .scaleAspectFill
        imageView.center = headerView.center
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = imageSize/2
        imageView.sd_setImage(with: url)
        tableView.tableHeaderView = headerView
    }
    
    private func showProfile(with model: SCUserProfile) {
        tableView.isHidden = false
        models.append("Full Name: \(model.displayName)")
        models.append("Email Address: \(model.email)")
        models.append("User ID: \(model.id)")
        models.append("Plan: \(model.product)")
        createTableHeader(with: model.images.first?.url)
        tableView.reloadData()
    }
    
    private func showProfileError() {
        let label = UILabel(frame: .zero)
        label.text = "Failed to load profile."
        label.sizeToFit()
        label.textColor = .secondaryLabel
        view.addSubview(label)
        label.center = view.center
    }
    
    
}

extension SCProfileViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = models[indexPath.row]
        cell.selectionStyle = .none
        
        return cell
    }
    
}
