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

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchbar: UISearchBar!
    
    private let bag = DisposeBag()
    fileprivate var viewModel: SearchViewViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        viewModel = SearchViewViewModel(service: TwitterService())
        bindUI()
    }
    
    func bindUI() {
        
            
        
        
        
//        viewModel.tweets
//            .bindTo(tableView.rx.realmChanges(dataSource))
//            .addDisposableTo(bag)
//
//        viewModel.loggedIn
//            .drive(messageView.rx.isHidden)
//            .addDisposableTo(bag)
        
        //show message when no account available
    }
    
    private func configureTableView() {
        tableView.estimatedRowHeight = 90
        tableView.rowHeight = UITableViewAutomaticDimension
    }
}

