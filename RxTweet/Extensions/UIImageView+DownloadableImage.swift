//
//  UIImageView+DownloadableImage.swift
//  RxTweet
//
//  Created by Dhiraj Das on 4/22/18.
//  Copyright © 2018 Dhiraj Das. All rights reserved.
//

import RxSwift
import RxCocoa
import UIKit

extension Reactive where Base: UIImageView {
    
    var downloadableImage: Binder<DownloadableImage>{
        return downloadableImageAnimated(nil)
    }
    
    func downloadableImageAnimated(_ transitionType:String?) -> Binder<DownloadableImage> {
        return Binder(base) { imageView, image in
            for subview in imageView.subviews {
                subview.removeFromSuperview()
            }
            switch image {
            case .content(let image):
                (imageView as UIImageView).rx.image.on(.next(image))
            case .offlinePlaceholder:
                let label = UILabel(frame: imageView.bounds)
                label.textAlignment = .center
                label.font = UIFont.systemFont(ofSize: 35)
                label.text = "⚠️"
                imageView.addSubview(label)
            }
        }
    }
}
