//
//  Const.swift
//  wangfuAgent
//
//  Created by lzw on 2018/7/11.
//  Copyright © 2018 zhuanbangTec. All rights reserved.
//

import UIKit
@_exported import HandyJSON
@_exported import Kingfisher

let YES = true
let NO = false

let KPageSize:Int = 10
let KReloadIntervalTime:Double = 600

func judgeScream() -> Bool {
    if #available(iOS 11.0, *) {
        let a = UIApplication.shared.keyWindow!.safeAreaInsets.bottom
        return a != 0 ? true:false
    } else {
        return false
    }
}

/// 屏幕的宽度
let KScreenWidth    = UIScreen.main.bounds.width
/// 屏幕的高度
let KScreenHeight   = UIScreen.main.bounds.height
/// 是否是IphoneX
let KIsIphoneX      = judgeScream()
/// 导航栏下内容高度
let KHeightInNav    = KScreenHeight - KNaviBarH
/// 导航栏高度
let KNaviBarH       = CGFloat(KIsIphoneX ? 88.0:64.0)
/// tabbar高度
let KTabBarH        = CGFloat(KIsIphoneX ? 83.0:49.0)
/// 底部多余的高度
let KBottomH        = CGFloat(KIsIphoneX ? 34:0)
/// 375下的尺寸  size*KRatio375
let KRatio375       = UIScreen.main.bounds.width / 375.0


let noti = NotificationCenter.default

extension NSNotification.Name {
    static let needRelogin = NSNotification.Name("needRelogin")
}



