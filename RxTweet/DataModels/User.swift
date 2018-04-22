//
//  User.swift
//  RxTweet
//
//  Created by Dhiraj Das on 4/22/18.
//  Copyright © 2018 Dhiraj Das. All rights reserved.
//

import Foundation
import RealmSwift

class User: Object {
    
    @objc dynamic var id: Int64 = 0
    @objc dynamic var name = ""
    @objc dynamic var profileImageURL = ""
    @objc dynamic var profileDescription = ""
    @objc dynamic var location = ""
    @objc dynamic var url = ""
    @objc dynamic var screenName = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(data: Any) {
        self.init()
        guard let _data = data as? [String: Any] else { return }
        
        id = _data["id"] as? Int64 ?? 0
        name = _data["name"] as? String ?? ""
        screenName = _data["screen_name"] as? String ?? ""
        profileImageURL = _data["profile_image_url_https"] as? String ?? ""
        profileDescription = _data["description"] as? String ?? ""
        location = _data["location"] as? String ?? ""
        url = _data["url"] as? String ?? ""
    }
}
