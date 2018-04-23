//
//  UIStoryboard+Extensions.swift
//  RxTweet
//
//  Created by Dhiraj Das on 4/23/18.
//  Copyright © 2018 Dhiraj Das. All rights reserved.
//

import UIKit

extension UIStoryboard {
    func instantiateViewController<T>(ofType type: T.Type) -> T {
        return instantiateViewController(withIdentifier: String(describing: type)) as! T
    }
}
