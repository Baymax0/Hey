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

    static func isDirectory(_ path:String) -> Bool {
        var isDirectory:ObjCBool = false
        FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory)
        if isDirectory.boolValue == false{
            return false
        }else{
            return true
        }
    }
    
    static func isDirectory2(_ name:String) -> Bool {
        if Utils.isVideoFile(name){
            return false
        }
        if Utils.isImageFile(name){
            return false
        }
        
        return true
    }
    
    static func isVideoFile(_ path:String) -> Bool {
        if path.contains(".mp4") {
            return true
        }
        if path.contains(".mov") {
            return true
        }
        if path.contains(".MOV") {
            return true
        }
        if path.contains(".avi") {
            return true
        }
        if path.contains(".flv") {
            return true
        }
        if path.contains(".mkv") {
            return true
        }
        if path.contains(".rmvb") {
            return true
        }
        if path.contains(".3gp") {
            return true
        }
        return false
    }
    
    static func isImageFile(_ path:String) -> Bool {
        if path.contains(".jpg") {
            return true
        }
        if path.contains(".JPG") {
            return true
        }
        if path.contains(".jpeg") {
            return true
        }
        if path.contains(".JPEG") {
            return true
        }
        if path.contains(".png") {
            return true
        }
        if path.contains(".PNG") {
            return true
        }
        if path.contains(".bmp") {
            return true
        }
        if path.contains(".BMP") {
            return true
        }
        if path.contains(".gif") {
            return true
        }
        if path.contains(".GIF") {
            return true
        }
        return false
    }
    
    static func random(_ max:UInt32 = 10) -> Int {
        return Int(arc4random() % max) + 1
    }
    
    
}

