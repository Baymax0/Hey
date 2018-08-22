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
///导航栏高度
let KNaviBarH       = CGFloat(KScreenHeight == 812 ? 88.0:64.0)
///导航栏高度
let KTabBarH        = CGFloat(KScreenHeight == 812 ? 83.0:49.0)

/// 375下的尺寸
let KRatio375       = UIScreen.main.bounds.width / 375.0

/// 服务器地址
let KServer_Host    = "https://api.163.gg"
let KServer_Image   = "https://img.163.gg"
let KServer_Web     = "https://www.163.gg"

/// 颜色
func KRGB(_ red:CGFloat, _ green:CGFloat, _ blue:CGFloat) -> UIColor {
    return UIColor.init(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: 1)
}
let KBlue = KRGB(36,141,245)

let KRed = KRGB(254,110,111)

let KOrange = KRGB(255,98,59)

let KTextBlack = KRGB(66,66,66)

let KTextGray = KRGB(153,153,153)

let KTextLightGray = KRGB(183,183,183)

//背景视图灰色
let KBGGray = KRGB(247,247,247)

//背景视图灰色 中的  分割线
let KBGGrayLine = KRGB(230,230,230)


let KPageSize:Int = 10










