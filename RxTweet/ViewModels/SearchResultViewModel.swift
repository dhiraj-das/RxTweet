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
    var profileImage: Driver<DownloadableImage>
    var tweet: Tweet
    
    init(tweet: Tweet) {
        self.tweet = tweet
        self.createdDate = Driver.never()
        self.tweetText = Driver.never()
        self.profileImage = Driver.never()
        self.personName = Driver.never()
        
        tweetText = Observable
            .just(tweet.text)
            .asDriver(onErrorJustReturn: "")
        
        personName = Observable
            .just(tweet.user?.name ?? "")
            .asDriver(onErrorJustReturn: "")
        
        if let date = tweet.created {
            createdDate = Observable
                .just(DateFormatter.cellDateFormat().string(from: date))
                .asDriver(onErrorJustReturn: "")
        }
        fetchImage()
    }
    
    private func fetchImage() {
        let imageService = ImageService()
        profileImage = imageService.imageFromURL(urlString: tweet.user?.profileImageURL ?? "")
                .map({ DownloadableImage.content(image: $0) })
                .startWith(DownloadableImage.offlinePlaceholder)
                .asDriver(onErrorJustReturn: DownloadableImage.offlinePlaceholder)
    }
}
