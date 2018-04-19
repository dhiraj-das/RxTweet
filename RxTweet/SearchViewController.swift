//
//  SearchViewController.swift
//  RxTweet
//
//  Created by Dhiraj Das on 4/19/18.
//  Copyright © 2018 Dhiraj Das. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchbar: UISearchBar!
    
    //var viewModel = SearchViewViewModel(service: <#T##SearchService#>)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TwitterService.shared.fetchTweets(searchQuery: "tesla") { (tweets, error) in
            print(tweets ?? error ?? "nothing printed")
        }
    }


}

