//
//  ProfileViewController.swift
//  RxTweet
//
//  Created by Dhiraj Das on 4/22/18.
//  Copyright © 2018 Dhiraj Das. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ProfileViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var linkLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    private var disposeBag = DisposeBag()
    private var viewModel: ProfileViewModel!
    private var navigator: Navigator!
    
    static func createWith(navigator: Navigator, storyboard: UIStoryboard, viewModel: ProfileViewModel) -> ProfileViewController {
        let viewController = storyboard.instantiateViewController(ofType: ProfileViewController.self)
        viewController.navigator = navigator
        viewController.viewModel = viewModel
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        bindUI()
    }
    
    private func bindUI() {
        guard let _viewModel = viewModel else {
            return
        }
        
        _viewModel.name
            .map(Optional.init)
            .drive(self.profileNameLabel.rx.text)
            .disposed(by: disposeBag)
        
        _viewModel.description
            .map(Optional.init)
            .drive(self.descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        _viewModel.location
            .map(Optional.init)
            .drive(self.locationLabel.rx.text)
            .disposed(by: disposeBag)
        
        _viewModel.url
            .map(Optional.init)
            .drive(self.linkLabel.rx.text)
            .disposed(by: disposeBag)
        
        _viewModel.handle
            .map(Optional.init)
            .drive(self.handleLabel.rx.text)
            .disposed(by: disposeBag)
        
        _viewModel.profileImage
            .drive(self.imageView.rx.downloadableImageAnimated(kCATransitionFade))
            .disposed(by: disposeBag)
    }
}
