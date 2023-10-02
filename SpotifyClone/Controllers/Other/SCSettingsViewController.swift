//
//  SCSettingsViewController.swift
//  SpotifyClone
//
//  Created by Shagara F Nasution on 22/08/23.
//

import UIKit

final class SCSettingsViewController: UIViewController {
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "cell")
        
        return tableView
    }()
    
    private var sections: [SCSettingSection] = []
    
    // MARK: - UIViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Settings"
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        configureModels()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.bounds
    }
    
    // MARK: - Private Methods
    
    private func configureModels() {
        sections.append(
            SCSettingSection(
                title: "Profile",
                options: [
                    SCSettingSectionOption(title: "View Your Profile", handler: { [weak self] in
                        self?.viewProfile()
                    })
                ])
        )
        
        sections.append(
            SCSettingSection(
                title: "Account",
                options: [
                    SCSettingSectionOption(title: "Sign Out", handler: { [weak self] in
                        self?.tapSignOut()
                    })
                ])
        )
    }
    
    private func viewProfile() {
        let vc = SCProfileViewController()
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func tapSignOut() {
        let alertController = UIAlertController(
            title: "Sign Out",
            message: "Are you sure to sign out?",
            preferredStyle: .alert
        )
        alertController.addAction(
            UIAlertAction(title: "Cancel", style: .cancel)
        )
        alertController.addAction(
            UIAlertAction(
                title: "Sign Out",
                style: .destructive,
                handler: { [weak self] _ in
                    self?.handleSignOut()
                }
            )
        )
        
        present(alertController, animated: true)
    }
    
    private func handleSignOut() {
        SCAuthManager.shared.singOut { [weak self] isSignOut in
            if isSignOut {
                DispatchQueue.main.async {
                    let vc = UINavigationController(
                        rootViewController: SCWelcomeViewController()
                    )
                    vc.navigationBar.prefersLargeTitles = true
                    vc.navigationItem.largeTitleDisplayMode = .always
                    vc.modalPresentationStyle = .fullScreen
                    self?.present(
                        vc,
                        animated: true,
                        completion: {
                            self?.navigationController?.popToRootViewController(animated: false)
                        })
                }
            }
        }
    }
    
}

extension SCSettingsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = sections[indexPath.section].options[indexPath.row]
        let tableView = tableView.dequeueReusableCell(withIdentifier: "cell",
                                                      for: indexPath)
        tableView.textLabel?.text = model.title
        
        return tableView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = sections[indexPath.section].options[indexPath.row]
        model.handler()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
    
}
