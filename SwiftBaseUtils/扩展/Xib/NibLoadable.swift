//
//  NibLoadable.swift
//  wenzhuanMerchants
//
//  Created by 蔡林海 on 2020/8/20.
//  Copyright © 2020 baymax. All rights reserved.
//

import UIKit

extension UIView{
    //在协议里面不允许定义class 只能定义static
    static func loadFromNib(_ nibname: String? = nil) -> Self {//Self (大写) 当前类对象
        let loadName = nibname ?? "\(self)"
        return Bundle.main.loadNibNamed(loadName, owner: nil, options: nil)?.first as! Self
    }
}


