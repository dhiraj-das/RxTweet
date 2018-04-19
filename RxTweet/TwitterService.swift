//
//  TwitterService.swift
//  RxTweet
//
//  Created by Dhiraj Das on 4/19/18.
//  Copyright © 2018 Dhiraj Das. All rights reserved.
//

import Foundation
import Alamofire

enum APIError: Error {
    case invalidURL
    case unknown
}

class TwitterService {
    
    static let shared = TwitterService()
    static let kConsumerKey = "Wau2JpjqydnYVZKN2Oh4UbRD7"
    static let kConsumerSecretKey = "NN19rUTPs4yJbWktNcBl6dnBdmaoQj4mxYhfy72X6WthRZno2A"
    static let kTwitterAuthAPI = "https://api.twitter.com/oauth2/token"
    static let kTwitterSearchAPI = "https://api.twitter.com/1.1/search/tweets.json"
    
    private init() {}
    
    func fetchTweets(searchQuery: String, completion: @escaping ((_ tweets: [String]?, _ error: Error?) -> Void)) {
        fetchAuthToken { (token, error) in
            guard let _token = token, error == nil else {
                completion(nil, error)
                return
            }
            
            guard let searchURL = URL(string: TwitterService.kTwitterSearchAPI) else {
                completion(nil, APIError.invalidURL)
                return
            }
            
            var headers = HTTPHeaders()
            headers["Authorization"] = "Bearer " + _token
            var parameters = Parameters()
            parameters["q"] = searchQuery
            
            let request = Alamofire.request(searchURL,
                                            method: .get,
                                            parameters: parameters,
                                            encoding: URLEncoding.default,
                                            headers: headers)
            request.responseJSON { (response) in
                switch response.result {
                case .success:
                    guard let json = response.result.value as? [String: Any] else {
                        completion(nil, APIError.unknown)
                        return
                    }
                    
                    print(json)
                case .failure(let error):
                    completion(nil, error)
                }
            }
        }
    }
    
    func fetchAuthToken(completion: @escaping ((_ token: String?, _ error: Error?) -> Void)) {
        guard let authURL = URL(string: TwitterService.kTwitterAuthAPI) else {
            completion(nil, APIError.invalidURL)
            return
        }
        
        var headers = HTTPHeaders()
        headers["Authorization"] = "Basic " + base64EncodedTokenString()
        var parameters = Parameters()
        parameters["grant_type"] = "client_credentials"
        
        let request = Alamofire.request(authURL,
                                        method: .post,
                                        parameters: parameters,
                                        encoding: URLEncoding.httpBody,
                                        headers: headers)
        request.responseJSON { (response) in
            switch response.result {
            case .success:
                guard let json = response.result.value as? [String: Any] else {
                    completion(nil, APIError.unknown)
                    return
                }
                
                if let token = json["access_token"] as? String {
                    completion(token, nil)
                    return
                }
                completion(nil, APIError.unknown)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    private func base64EncodedTokenString() -> String {
        let consumerKeyRFC1738 = TwitterService.kConsumerKey.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let consumerSecretRFC1738 = TwitterService.kConsumerSecretKey.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let concatenateKeyAndSecret = consumerKeyRFC1738! + ":" + consumerSecretRFC1738!
        let secretAndKeyData = concatenateKeyAndSecret.data(using: String.Encoding.ascii, allowLossyConversion: true)
        let base64EncodeKeyAndSecret = secretAndKeyData?.base64EncodedString(options: NSData.Base64EncodingOptions())
        return base64EncodeKeyAndSecret!
    }
}
