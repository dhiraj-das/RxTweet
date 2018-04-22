//
//  SearchViewController.swift
//  RxTweet
//
//  Created by Dhiraj Das on 4/19/18.
//  Copyright © 2018 Dhiraj Das. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SearchViewController: UIViewController {

    @IBOutlet weak var emptyLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchbar: UISearchBar!
    
    private let disposeBag = DisposeBag()
    private let apiService = TwitterService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureTableDataSource()
        configureTableViewCellSelection()
    }
    
    private func configureTableView() {
        tableView.estimatedRowHeight = 90
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.register(UINib.init(nibName: String(describing: TweetTableViewCell.self),
                                      bundle: nil),
                           forCellReuseIdentifier: String(describing: TweetTableViewCell.self))
    }
    
    private func configureTableDataSource() {
        let results = searchbar.rx.text.orEmpty
            .asDriver()
            .throttle(0.3)
            .distinctUntilChanged()
            .flatMapLatest { [unowned self] (query) in
                self.apiService.fetchAuthToken()
                    .observeOn(SchedulerHelper.backgroundWorkScheduler())
                    .flatMap({ self.apiService.fetchTweets(token: $0, searchQuery: query) })
                    .retry(3)
                    .startWith([])
                    .asDriver(onErrorJustReturn: [])
            }
            .map { (results) in
                results.map(SearchResultViewModel.init)
        }
        
        results
            .drive(tableView.rx.items(cellIdentifier: String(describing: TweetTableViewCell.self),
                                      cellType: TweetTableViewCell.self)) { (row, viewModel, cell) in
                                cell.viewModel = viewModel
            }
            .disposed(by: disposeBag)

        results
            .map { $0.count != 0 }
            .drive(self.emptyLabel.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
    private func configureTableViewCellSelection() {
        tableView.rx.modelSelected(SearchResultViewModel.self)
            .subscribe(onNext: { [weak self] (searchResultViewModel) in
                guard let profileViewController = self?.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController else { return }
                guard let user = searchResultViewModel.tweet.user else { return }
                profileViewController.viewModel = ProfileViewModel(user: user)
                self?.navigationController?.pushViewController(profileViewController, animated: true)
            })
            .disposed(by: disposeBag)
    }
}

