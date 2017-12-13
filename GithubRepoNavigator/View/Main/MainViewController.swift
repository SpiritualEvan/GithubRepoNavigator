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
import Moya


class MainViewController: UIViewController {

    var tableView:UITableView!
    let disposeBag = DisposeBag()
    var provider:MoyaProvider<GithubRepoEndpoint>!
//    var searchController:UISearchController!
    
    var repositories = [RepositoryInfo]()
//    var filteredRepositories = [RepositoryInfo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRx()
        
//        searchController = UISearchController(searchResultsController: nil)
//        searchController.searchResultsUpdater = self
//        searchController.dimsBackgroundDuringPresentation = false
//        searchController.searchBar.sizeToFit()
//        searchController.searchBar.autocapitalizationType = .none
        
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(RepositoryInfoCell.self, forCellReuseIdentifier: RepositoryInfoCell.reuseIdentifier)
        tableView.register(EmptyCell.self, forCellReuseIdentifier: EmptyCell.reuseIdentifier)
        tableView.register(LoadingCell.self, forCellReuseIdentifier: LoadingCell.reuseIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
//        tableView.tableHeaderView = searchController.searchBar
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            tableView.widthAnchor.constraint(equalTo: view.widthAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor)
        ])
        loadNextPage(reset: true)
    }
    
    func setupRx() {
        
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
//        if searchController.isActive {
//            return 0 < filteredRepositories.count ? filteredRepositories.count : 1
//        }else {
//            return repositories.count + 1
//        }
        return repositories.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        if searchController.isActive {
//            if 0 < filteredRepositories.count {
//                let cell = tableView.dequeueReusableCell(withIdentifier: RepositoryInfoCell.reuseIdentifier, for: indexPath) as! RepositoryInfoCell
//                cell.avatarView.image = nil
//                cell.nameField.text = nil
//                return cell
//
//            // return empty cell
//            }else {
//                let cell = tableView.dequeueReusableCell(withIdentifier: EmptyCell.reuseIdentifier, for: indexPath) as! EmptyCell
//                return cell
//            }
//        }else {
//            if indexPath.row < repositories.count {
                let cell = tableView.dequeueReusableCell(withIdentifier: RepositoryInfoCell.reuseIdentifier, for: indexPath) as! RepositoryInfoCell
                cell.avatarView.image = nil
                cell.nameField.text = nil
                return cell
//            }else {
//                let cell = tableView.dequeueReusableCell(withIdentifier: LoadingCell.reuseIdentifier, for: indexPath) as! LoadingCell
//                return cell
//            }
            
//        }
        
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        switch cell {
        case is RepositoryInfoCell:
            let repositoryInfoCell = cell as! RepositoryInfoCell
            // setup cell with model
//            let repositoryInfo = searchController.isActive ? filteredRepositories[indexPath.row] : repositories[indexPath.row]
            let repositoryInfo = repositories[indexPath.row]
            if let avatarURL = repositoryInfo.avatar {
                repositoryInfoCell.avatarView.af_setImage(withURL: avatarURL)
            }
            repositoryInfoCell.nameField.text = repositoryInfo.owner
            
            if indexPath.row + 1 == repositories.count {
                loadNextPage(reset: false)
            }
        case is LoadingCell:
            let loadingCell = cell as! LoadingCell
            loadingCell.loadingIndicator.startAnimating()
        default:
            break
        }
    }
//    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        switch cell {
//        case is LoadingCell:
//            let loadingCell = cell as! LoadingCell
//            loadingCell.loadingIndicator.stopAnimating()
//        default: break
//        }
//    }
}
//extension MainViewController: UISearchResultsUpdating {
//
//    @objc func reloadTable() {
//        let searchText = searchController.searchBar.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
//        if nil != searchText && 0 < searchText!.count {
//            filteredRepositories = repositories.filter { $0.owner.contains(searchText!) }
//        }else {
//            filteredRepositories = repositories
//        }
//        tableView.reloadData()
//    }
//    func updateSearchResults(for searchController: UISearchController) {
//        // debounce 0.5 sec
//        NSObject.cancelPreviousPerformRequests(withTarget: self, selector:#selector(MainViewController.reloadTable), object:nil)
//        self.perform(#selector(MainViewController.reloadTable), with: nil, afterDelay: 0.5)
//    }
//
//
//}

