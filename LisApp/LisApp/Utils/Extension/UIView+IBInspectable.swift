//
//  UIView+IBInspectable.swift
//  wangfuAgent
//
//  Created by lzw on 2018/8/8.
//  Copyright © 2018 zhuanbangTec. All rights reserved.
//

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
    
    var w:CGFloat{
        get{ return self.frame.size.width }
        set{
            var r = self.frame
            r.size.width = newValue
            self.frame = r
        }
    }
    var h:CGFloat{
        get{ return self.frame.size.height }
        set{
            var r = self.frame
            r.size.height = newValue
            self.frame = r
        }
    }
    var x:CGFloat{
        get{ return self.frame.origin.x }
        set{
            var r = self.frame
            r.origin.x = newValue
            self.frame = r
        }
    }
    var y:CGFloat{
        get{ return self.frame.origin.y }
        set{
            var r = self.frame
            r.origin.y = newValue
            self.frame = r
        }
    }
    var maxX:CGFloat{
        return self.frame.maxX
    }
    var maxY:CGFloat{
        return self.frame.maxY
    }
    
    
}



extension UITextField{
    @IBInspectable var showBorder: Bool {
        get {
            return borderStyle != .none
        }
        set {
            if newValue == false{
                borderStyle = .none
            }
        }
    }
}


