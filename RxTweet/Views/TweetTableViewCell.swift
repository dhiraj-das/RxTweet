//
//  TweetTableViewCell.swift
//  RxTweet
//
//  Created by Dhiraj Das on 4/21/18.
//  Copyright © 2018 Dhiraj Das. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

public class TweetTableViewCell: UITableViewCell {
    
    @IBOutlet var tweetLabel: UILabel!
    @IBOutlet var createdDateLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var disposeBag: DisposeBag?
    
    var viewModel: SearchResultViewModel? {
        didSet {
            guard let _viewModel = viewModel else {
                return
            }
            disposeBag = DisposeBag()
            
            _viewModel.tweetText
                .map(Optional.init)
                .drive(self.tweetLabel.rx.text)
                .disposed(by: disposeBag!)
            
            _viewModel.personName
                .map(Optional.init)
                .drive(self.nameLabel.rx.text)
                .disposed(by: disposeBag!)
            
            _viewModel.createdDate
                .map(Optional.init)
                .drive(self.createdDateLabel.rx.text)
                .disposed(by: disposeBag!)
        }
    }
    
    override public func prepareForReuse() {
        super.prepareForReuse()
        self.viewModel = nil
        self.disposeBag = nil
    }
    
}
