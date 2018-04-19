//
//  SearchViewViewModel.swift
//  RxTweet
//
//  Created by Dhiraj Das on 4/19/18.
//  Copyright © 2018 Dhiraj Das. All rights reserved.
//

import RxSwift
import RxCocoa

class SearchViewViewModel {
    
    let searchService: TwitterService
    var data: Driver<String>?
    
    init(service: TwitterService) {
        searchService = service
        
//        data = markService.get()
//            .map { result in
//                switch result {
//                case.success(let marks):
//                    return marks.map { mark in
//                        return mark
//                    }
//                case .error(let error):
//                    print(error)
//                }
//
//            }.asDriver(onErrorJustReturn: .error(.other))
    }
}
