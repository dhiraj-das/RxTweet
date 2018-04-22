//
//  ProfileViewModel.swift
//  RxTweet
//
//  Created by Dhiraj Das on 4/22/18.
//  Copyright © 2018 Dhiraj Das. All rights reserved.
//

import RxSwift
import RxCocoa

class ProfileViewModel {
    
    var user: User
    var name: Driver<String>
    var handle: Driver<String>
    var description: Driver<String>
    var location: Driver<String>
    var url: Driver<String>
    var profileImage: Driver<DownloadableImage>
    
    init(user: User) {
        self.user = user
        self.profileImage = Driver.never()
        self.name = Driver.never()
        self.handle = Driver.never()
        self.description = Driver.never()
        self.location = Driver.never()
        self.url = Driver.never()
        
        name = Observable
            .just(user.name)
            .asDriver(onErrorJustReturn: "")
        
        description = Observable
            .just(user.profileDescription)
            .asDriver(onErrorJustReturn: "")
        
        location = Observable
            .just(user.location)
            .asDriver(onErrorJustReturn: "")
        
        url = Observable
            .just(user.url)
            .asDriver(onErrorJustReturn: "")
        
        handle = Observable
            .just(user.screenName)
            .asDriver(onErrorJustReturn: "")
        
        fetchImage()
    }
    
    private func fetchImage() {
        let imageService = ImageService()
        profileImage = imageService.imageFromURL(urlString: user.profileImageURL)
            .map({ DownloadableImage.content(image: $0) })
            .startWith(DownloadableImage.offlinePlaceholder)
            .asDriver(onErrorJustReturn: DownloadableImage.offlinePlaceholder)
    }
}
