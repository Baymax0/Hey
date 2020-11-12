//
//  UIView+IBInspectable.swift
//  wangfuAgent
//
//  Created by lzw on 2018/8/8.
//  Copyright © 2018 zhuanbangTec. All rights reserved.
//

import Foundation
import UIKit

extension UIView{
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    func showWithAnimation(_ time:Double = 0.2){
        self.alpha = 0
        UIView.animate(withDuration: time) {
            self.alpha = 1
        }
    }
    
    func showWithAnimation(delay:Double, _ time:Double = 0.2){
        self.alpha = 0
        UIView.animate(withDuration: time, delay: delay) {
            self.alpha = 1
        } completion: { (_) in
            
        }
    }
    
    var x:CGFloat{
        get{
            return self.frame.origin.x
        }
        set{
            self.frame.origin.x = newValue
        }
    }
    var y:CGFloat{
        get{
            return self.frame.origin.y
        }
        set{
            self.frame.origin.y = newValue
        }
    }
    var w:CGFloat{
        get{
            return self.frame.width
        }
        set{
            self.frame.size.width = newValue
        }
    }
    var h:CGFloat{
        get{
            return self.frame.height
        }
        set{
            self.frame.size.height = newValue
        }
    }
    
    var centerX:CGFloat{
        get{
            return self.center.x
        }
        set{
            self.center.x = newValue
        }
    }
    var centerY:CGFloat{
        get{
            return self.center.y
        }
        set{
            self.center.y = newValue
        }
    }
    var maxY:CGFloat{
        return self.frame.maxY
    }
    var maxX:CGFloat{
        return self.frame.maxX
    }
    ///生成图片
    func toImage() -> UIImage?{
        
        UIGraphicsBeginImageContextWithOptions(self.frame.size, false, UIScreen.main.scale)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let img: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return img
    }
    ///删除一个view 下的所有子view
    func clearAll(){
        if self.subviews.count > 0 {
            self.subviews.forEach({ $0.removeFromSuperview()})
        }
    }
}

