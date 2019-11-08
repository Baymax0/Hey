//
//  Const.swift
//  wangfuAgent
//
//  Created by lzw on 2018/7/11.
//  Copyright © 2018 zhuanbangTec. All rights reserved.
//

import UIKit

let YES = true
let NO = false

/// 屏幕的宽度
let KScreenWidth    = UIScreen.main.bounds.width
/// 屏幕的高度
let KScreenHeight   = UIScreen.main.bounds.height
/// 是否是IphoneX
let KIsIphoneX      = KScreenHeight == 812 ? true:false
/// 导航栏高度
let KNaviBarH       = CGFloat(KScreenHeight == 812 ? 88.0:64.0)
/// 导航栏 缩小版 高度
let KNaviBarSmallH       = CGFloat(KScreenHeight == 812 ? 64.0:64.0)
///导航栏高度
let KTabBarH        = CGFloat(KScreenHeight == 812 ? 83.0:49.0)

/// 375下的尺寸
let KRatio375       = UIScreen.main.bounds.width / 375.0

let KPageSize:Int = 10

let KDefaultAvatar = "default-avatar"
let KDefaultImg = "default-img"


let requestLog = false





