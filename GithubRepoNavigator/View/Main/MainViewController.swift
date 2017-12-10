//
//  ViewController.swift
//  GithubRepoNavigator
//
//  Created by Won Cheul Seok on 2017. 12. 10..
//  Copyright © 2017년 Evan Seok. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    static let RepositoryInfoCellIdentifier = "RepositoryInfoCellIdentifier"
    
    var tableView:UITableView!
    var repositories = [RepositoryInfo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: MainViewController.RepositoryInfoCellIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            tableView.widthAnchor.constraint(equalTo: view.widthAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor)
        ])
        RepositoryListFetcher.shared.beginFetch { (results, error) in
            guard nil == error else {
                let errorAlertVC = UIAlertController(title: nil, message: error?.localizedDescription, preferredStyle: .alert)
                errorAlertVC.addAction(UIAlertAction(title: "close", style: .default, handler: nil))
                self.present(errorAlertVC, animated: true, completion: nil)
                return
            }
            guard let results = results else {
                let errorAlertVC = UIAlertController(title: nil, message: "There was no error but nil results returned", preferredStyle: .alert)
                errorAlertVC.addAction(UIAlertAction(title: "close", style: .default, handler: nil))
                self.present(errorAlertVC, animated: true, completion: nil)
                return
            }
            self.repositories = results
            self.tableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MainViewController.RepositoryInfoCellIdentifier, for: indexPath)
        let repositoryInfo = repositories[indexPath.row]
        if let avatarURL = repositoryInfo.avatar {
            do {
                cell.imageView!.image = UIImage(data: try Data(contentsOf: avatarURL))!
            }catch {
                print(error)
            }
        }
        cell.textLabel!.text = repositoryInfo.owner
        return cell
    }
}

