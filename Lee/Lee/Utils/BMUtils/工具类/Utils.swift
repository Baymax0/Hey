//
//  Utils.swift
//  wangfuAgent
//
//  Created by lzw on 2018/7/17.
//  Copyright © 2018 zhuanbangTec. All rights reserved.
//

import UIKit
import Foundation

import SwiftyUserDefaults

class Utils: NSObject {
    
    static let appCurVersion:String = {
        let s = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
        let arr = s.components(separatedBy: ".")
        let result = "\(arr[0]).\(arr[1])"
        return result
    }()
    
    static let appCurVersionInt:Int = {
        let ver = Utils.appCurVersion
        let arr = ver.components(separatedBy: ".")
        let a = arr[0].toInt()
        let b = arr[1].toInt()
        let result = a * 1000 + b
        return result
    }()

    static let deviceSysVersion:String = {
        return UIDevice.current.systemVersion
    }()

    static let deviceUUID:String? = {
        return UIDevice.current.identifierForVendor?.uuidString
    }()

    //显示登录
    static func pushLoginView(_ animation:Bool = true) -> Void {
//        Cache.loginout()
//        //防止 重复 弹出 登录页
//        if BaseVC.currentVC != "LoginVC" {
//            let vc = UIApplication.shared.keyWindow?.rootViewController
//            vc?.present(LoginVC(), animated: animation, completion: nil)
//        }
    }

    
}

