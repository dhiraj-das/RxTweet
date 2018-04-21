//
//  SearchResultViewModel.swift
//  RxTweet
//
//  Created by Dhiraj Das on 4/19/18.
//  Copyright © 2018 Dhiraj Das. All rights reserved.
//

import RxSwift
import RxCocoa

class SearchResultViewModel {
    
    var tweetText: Driver<String>
    var createdDate: Driver<String>
    var personName: Driver<String>
    //var profileImage: Driver<URL>
    var tweet: Tweet
    
    init(tweet: Tweet) {
        self.tweet = tweet
        self.createdDate = Driver.never()
        self.tweetText = Driver.never()
        
        tweetText = Observable
            .just(tweet.text)
            .asDriver(onErrorJustReturn: "")
        
        personName = Observable
            .just(tweet.name)
            .asDriver(onErrorJustReturn: "")
        
        if let date = tweet.created {
            createdDate = Observable
                .just(DateFormatter.cellDateFormat().string(from: date))
                .asDriver(onErrorJustReturn: "")
        }
    }
}
