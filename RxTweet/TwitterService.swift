//
//  TwitterService.swift
//  RxTweet
//
//  Created by Dhiraj Das on 4/19/18.
//  Copyright © 2018 Dhiraj Das. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

enum APIError: Error {
    case invalidURL
    case unknown
    case noToken
}

class TwitterService {
    
    static let kConsumerKey = "Wau2JpjqydnYVZKN2Oh4UbRD7"
    static let kConsumerSecretKey = "NN19rUTPs4yJbWktNcBl6dnBdmaoQj4mxYhfy72X6WthRZno2A"
    static let kTwitterAuthAPI = "https://api.twitter.com/oauth2/token"
    static let kTwitterSearchAPI = "https://api.twitter.com/1.1/search/tweets.json"
    
    let disposeBag = DisposeBag()
    
    func fetchTweets(token: String, searchQuery: String) -> Observable<[Tweet]> {
        
        if let searchAPI = URL(string: TwitterService.kTwitterSearchAPI) {
            var headers = HTTPHeaders()
            headers["Authorization"] = "Bearer " + token
            var parameters = Parameters()
            parameters["q"] = searchQuery
            
            let request = Alamofire.request(searchAPI,
                                            method: .get,
                                            parameters: parameters,
                                            encoding: URLEncoding.default,
                                            headers: headers)
            
            return Observable.create({ (observer) in
                request.responseJSON(completionHandler: { (response) in
                    switch response.result {
                    case .success(let value):
                        guard let json = value as? [String: Any] else {
                            observer.onError(APIError.invalidURL)
                            return
                        }
                        if let statuses = json["statuses"] as? [Any] {
                            let tweets = statuses.flatMap({ Tweet(data: $0) })
                            observer.onNext(tweets)
                            observer.onCompleted()
                            return
                        }
                        observer.onError(APIError.noToken)
                        
                    case .failure(let error):
                        observer.onError(error)
                    }
                })
                return Disposables.create()
            })
        }
        return Observable.error(APIError.invalidURL)
        
        
        
//        fetchAuthToken { (token, error) in
//            guard let _token = token, error == nil else {
//                completion(nil, error)
//                return
//            }
//
//            guard let searchURL = URL(string: TwitterService.kTwitterSearchAPI) else {
//                completion(nil, APIError.invalidURL)
//                return
//            }
//
//            var headers = HTTPHeaders()
//            headers["Authorization"] = "Bearer " + _token
//            var parameters = Parameters()
//            parameters["q"] = searchQuery
//
//            let request = Alamofire.request(searchURL,
//                                            method: .get,
//                                            parameters: parameters,
//                                            encoding: URLEncoding.default,
//                                            headers: headers)
//            request.responseJSON { (response) in
//                switch response.result {
//                case .success:
//                    guard let json = response.result.value as? [String: Any] else {
//                        completion(nil, APIError.unknown)
//                        return
//                    }
//
//                    print(json)
//                case .failure(let error):
//                    completion(nil, error)
//                }
//            }
//        }
    }
    
    func fetchAuthToken() -> Observable<String> {
        
        if let authURL = URL(string: TwitterService.kTwitterAuthAPI) {
            var headers = HTTPHeaders()
            headers["Authorization"] = "Basic " + base64EncodedTokenString()
            var parameters = Parameters()
            parameters["grant_type"] = "client_credentials"

            let request = Alamofire.request(authURL,
                                            method: .post,
                                            parameters: parameters,
                                            encoding: URLEncoding.httpBody,
                                            headers: headers)
            
            return Observable.create({ (observer) in
                request.responseJSON(completionHandler: { (response) in
                    switch response.result {
                    case .success(let value):
                        guard let json = value as? [String: Any] else {
                            observer.onError(APIError.invalidURL)
                            return
                        }
                        
                        if let token = json["access_token"] as? String {
                            observer.onNext(token)
                            observer.onCompleted()
                            return
                        }
                        observer.onError(APIError.noToken)
                    
                    case .failure(let error):
                        observer.onError(error)
                    }
                })
                return Disposables.create()
            })
        }
        return Observable.error(APIError.invalidURL)
    }
    
    func base64EncodedTokenString() -> String {
        let consumerKeyRFC1738 = TwitterService.kConsumerKey.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let consumerSecretRFC1738 = TwitterService.kConsumerSecretKey.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let concatenateKeyAndSecret = consumerKeyRFC1738! + ":" + consumerSecretRFC1738!
        let secretAndKeyData = concatenateKeyAndSecret.data(using: String.Encoding.ascii, allowLossyConversion: true)
        let base64EncodeKeyAndSecret = secretAndKeyData?.base64EncodedString(options: NSData.Base64EncodingOptions())
        return base64EncodeKeyAndSecret!
    }
}
