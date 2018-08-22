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


