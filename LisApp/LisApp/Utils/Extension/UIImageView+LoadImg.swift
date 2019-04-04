//
//  UIImageView+LoadImg.swift
//  MySugarHeap
//
//  Created by lzw on 2018/8/31.
//  Copyright © 2018 lizhiwei. All rights reserved.
//

import UIKit

protocol CustomImageLoader {
    func loadImage(_ urlString:String, placeHolder:String?) ->  Void
    func loadDiskImage(_ urlString:String, placeHolder:String?) -> Void
}

extension UIImageView : CustomImageLoader{
    
    //普通加载图片  只缓存到内存  不存在本地
    func loadImage(_ urlString:String, placeHolder:String? = nil) ->  Void{
//        self.kf.setImage(
//            with: urlString.resource,
//            placeholder: placeHolder?.image,
//            options: [.transition(ImageTransition.fade(0.3)),
//                      .cacheMemoryOnly],
//            progressBlock: nil,
//            completionHandler: nil
//        )

    }
    //默认缓存在本地的
    func loadDiskImage(_ urlString:String, placeHolder:String? = nil) -> Void {
//        self.kf.setImage(
//            with: urlString.resource,
//            placeholder: placeHolder?.image,
//            options: [.transition(ImageTransition.fade(0.5))],
//            progressBlock: nil,
//            completionHandler: nil
//        )
    }
}
