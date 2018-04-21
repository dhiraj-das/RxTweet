//
//  Tweet.swift
//  RxTweet
//
//  Created by Dhiraj Das on 4/19/18.
//  Copyright © 2018 Dhiraj Das. All rights reserved.
//

import Foundation
import RealmSwift

class Tweet: Object {
    
    @objc dynamic var id: Int64 = 0
    @objc dynamic var text = ""
    @objc dynamic var name = ""
    @objc dynamic var created: Date?
    @objc dynamic var profileImageURL = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(data: Any) {
        self.init()
        guard let _data = data as? [String: Any] else { return }
        
        id = _data["id"] as? Int64 ?? 0
        text = _data["text"] as? String ?? ""
        
        if let user = _data["user"] as? [String: Any] {
            name = user["name"] as? String ?? ""
            profileImageURL = user["profile_image_url"] as? String ?? ""
        }
        
        if let date = _data["created_at"] as? String {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM dd HH:mm:ss Z yyyy"
            created = formatter.date(from: date)
        }
    }
}
