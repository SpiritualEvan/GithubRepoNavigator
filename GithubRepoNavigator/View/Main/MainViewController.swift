//
//  ViewController.swift
//  GithubRepoNavigator
//
//  Created by Won Cheul Seok on 2017. 12. 10..
//  Copyright © 2017년 Evan Seok. All rights reserved.
//

import UIKit
import RxSwift
import AlamofireImage

class MainViewController: UIViewController {

    static let RepositoryInfoCellIdentifier = "RepositoryInfoCellIdentifier"
    
    var tableView:UITableView!
    let disposeBag = DisposeBag()
    var searchController:UISearchController!
    
    var repositories = [RepositoryInfo]()
    var filteredRepositories = [RepositoryInfo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        searchController.searchBar.autocapitalizationType = .none
        
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: MainViewController.RepositoryInfoCellIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = searchController.searchBar
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            tableView.widthAnchor.constraint(equalTo: view.widthAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor)
        ])
        loadNextPage(reset: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    func showLoading(loading:Bool) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = loading
        self.view.isUserInteractionEnabled = !loading
    }
    
    func loadNextPage(reset:Bool) {
        
        showLoading(loading: true)
        
        RepositoryListFetcher.shared.nextPageObserver(reset:reset)
            .subscribe(onNext: { (results) in
                
                self.showLoading(loading: false)
                
                if true == reset {
                    self.repositories = results
                }else {
                    self.repositories.append(contentsOf: results)
                }
                
                self.tableView.reloadData()
                
            }, onError: { (error) in
                self.showLoading(loading: false)
                let errorVC = UIAlertController(title: nil, message: error.localizedDescription, preferredStyle: .alert)
                errorVC.addAction(UIAlertAction(title: nil, style: .default, handler: nil))
                self.present(errorVC, animated: true, completion: nil)
            }, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  searchController.isActive ? filteredRepositories.count : repositories.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // reset cell
        let cell = tableView.dequeueReusableCell(withIdentifier: MainViewController.RepositoryInfoCellIdentifier, for: indexPath)
        cell.imageView!.contentMode = .scaleAspectFill
        cell.imageView!.image = #imageLiteral(resourceName: "empty_avatar")
        cell.textLabel!.text = nil
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // setup cell with model
        let repositoryInfo = searchController.isActive ? filteredRepositories[indexPath.row] : repositories[indexPath.row]
        if let avatarURL = repositoryInfo.avatar {
            cell.imageView!.af_setImage(withURL: avatarURL)
        }
        cell.textLabel!.text = repositoryInfo.owner
        
        if indexPath.row + 1 == repositories.count {
            loadNextPage(reset: false)
        }
    }
}
extension MainViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if nil != searchText && 0 < searchText!.count {
            filteredRepositories = repositories.filter { $0.owner.contains(searchText!) }
        }else {
            filteredRepositories = repositories
        }
        
        tableView.reloadData()
    }
    
    
}
