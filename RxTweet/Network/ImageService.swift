//
//  ImageService.swift
//  RxTweet
//
//  Created by Dhiraj Das on 4/22/18.
//  Copyright © 2018 Dhiraj Das. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire

enum DownloadableImage{
    case content(image: UIImage)
    case offlinePlaceholder
}

class ImageService {
    
    let disposeBag = DisposeBag()
    
    func imageFromURL(urlString: String) -> Observable<UIImage> {
        if let url = URL(string: urlString) {
            
            let request = Alamofire.request(url, method: .get)
            
            return Observable.create({ (observer) in
                request.responseData(completionHandler: { (response) in
                    switch response.result {
                    case .success(let value):
                        guard let image = UIImage(data: value) else {
                            observer.onError(APIError.unknown)
                            return
                        }
                        observer.onNext(image)
                        observer.onCompleted()
                    case .failure(let error):
                        observer.onError(error)
                    }
                })
                return Disposables.create()
            })
        }
        return Observable.error(APIError.invalidURL)
    }
}
