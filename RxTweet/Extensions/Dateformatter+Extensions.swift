//
//  Dateformatter+Extensions.swift
//  RxTweet
//
//  Created by Dhiraj Das on 4/22/18.
//  Copyright © 2018 Dhiraj Das. All rights reserved.
//

import Foundation

extension DateFormatter {
    
    static func cellDateFormat() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE MMM dd"
        return formatter
    }
}
