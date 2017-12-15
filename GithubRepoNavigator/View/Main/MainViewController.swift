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
import RxCocoa

class MainViewController: UITableViewController {

    let disposeBag = DisposeBag()
    let provider = MoyaProvider<GithubRepoEndpoint>()
    var repositoryModel:RepositoryModel!
    var searchController:UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchController = UISearchController(searchResultsController: nil)
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.autocapitalizationType = .none
        
        tableView.register(RepositoryInfoCell.self, forCellReuseIdentifier: RepositoryInfoCell.reuseIdentifier)
//        tableView.register(EmptyCell.self, forCellReuseIdentifier: EmptyCell.reuseIdentifier)
//        tableView.register(LoadingCell.self, forCellReuseIdentifier: LoadingCell.reuseIdentifier)
//        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.tableHeaderView = searchController.searchBar
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension

        setupRx()
//        loadNextPage(reset: true)
        
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
        
        
    }
}
extension MainViewController {
    func setupRx() {
        
        repositoryModel = RepositoryModel(provider: provider)
        let repositoryListObserver = repositoryModel.repositoryListObserver()
        
        let searchTextObsesrver = searchController.searchBar.rx.text.orEmpty
        .debounce(0.5, scheduler: MainScheduler.instance)
        .distinctUntilChanged()
        
        Observable.combineLatest(repositoryListObserver, searchTextObsesrver)
            .flatMapLatest { ( repos, searchText ) in
                return Observable.just(searchText.count > 0 ? repos.filter{$0.loginID.contains(searchText)} : repos)
            }
            .bind(to:tableView.rx.items) { tableView, row, item in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: RepositoryInfoCell.reuseIdentifier, for: IndexPath(row: row, section: 0)) as? RepositoryInfoCell else {
                    fatalError("expected RepositoryInfoCell but actual \(tableView.dequeueReusableCell(withIdentifier: RepositoryInfoCell.reuseIdentifier, for: IndexPath(row: row, section: 0)))")
                }
                
                cell.avatarView.af_setImage(withURL: item.avatarURL)
                cell.nameField.text = item.loginID
                return cell
            }
            .disposed(by: disposeBag)
        
    }
}
