//
//  SearchTweetCursor.swift
//  RxTweet
//
//  Created by Dhiraj Das on 4/23/18.
//  Copyright © 2018 Dhiraj Das. All rights reserved.
//

import Foundation

struct SearchTweetCursor {
    let maxId: Int64
    let sinceId: Int64
    
    init(max: Int64, since: Int64) {
        maxId = max
        sinceId = since
    }
    
    init?(data: Any) {
        guard let dict = data as? [String: Any],
            let _maxId = dict["max_id"] as? Int64,
            let _sinceId = dict["since_id"] as? Int64 else { return nil }
        maxId = _maxId
        sinceId = _sinceId
    }
    
    static var none: SearchTweetCursor {
        return SearchTweetCursor(max: Int64.max, since: 0)
    }
    
    static func currentCursor(lastCursor: SearchTweetCursor, tweets: [Tweet]) -> SearchTweetCursor {
        return tweets.reduce(lastCursor) { cursor, tweet in
            let max: Int64 = tweet.id < cursor.maxId ? tweet.id - 1 : cursor.maxId
            let since: Int64 = tweet.id > cursor.sinceId ? tweet.id : cursor.sinceId
            return SearchTweetCursor(max: max, since: since)
        }
    }
}

extension SearchTweetCursor: CustomStringConvertible {
    var description: String {
        return "[max: \(maxId), since: \(sinceId)]"
    }
}

extension SearchTweetCursor: Equatable {
    static func ==(lhs: SearchTweetCursor, rhs: SearchTweetCursor) -> Bool {
        return lhs.maxId==rhs.maxId && lhs.sinceId==rhs.sinceId
    }
}
