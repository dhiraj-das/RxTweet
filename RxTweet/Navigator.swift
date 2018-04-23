//
//  Navigator.swift
//  RxTweet
//
//  Created by Dhiraj Das on 4/23/18.
//  Copyright © 2018 Dhiraj Das. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa

class Navigator {
    lazy private var defaultStoryboard = UIStoryboard(name: "Main", bundle: nil)
    
    // MARK: - Segues List
    enum Segue {
        case profile(user: User)
    }
    
    // MARK: - Invoke Segue
    func show(segue: Segue, sender: UIViewController) {
        switch segue {
        case .profile(let user):
            let viewModel = ProfileViewModel(user: user)
            show(target: ProfileViewController.createWith(navigator: self,
                                                          storyboard: sender.storyboard ?? defaultStoryboard,
                                                          viewModel: viewModel), sender: sender)
        }
    }
    
    private func show(target: UIViewController, sender: UIViewController) {
        if let navigationController = sender as? UINavigationController {
            navigationController.pushViewController(target, animated: false)
            return
        }
        
        if let navigationController = sender.navigationController {
            navigationController.pushViewController(target, animated: true)
        } else {
            sender.present(target, animated: true, completion: nil)
        }
    }
}
