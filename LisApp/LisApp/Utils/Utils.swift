//
//  Utils.swift
//  MySugarHeap
//
//  Created by lzw on 2018/9/3.
//  Copyright © 2018 lizhiwei. All rights reserved.
//

import Foundation
import SystemConfiguration

class Utils: NSObject {

    static func isDirectory(_ path:String) -> Bool {
        var isDirectory:ObjCBool = false
        FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory)
        if isDirectory.boolValue == false{
            return false
        }else{
            return true
        }
    }
    
    static func isVideoFile(_ path:String) -> Bool {
        if path.contains(".mp4") {
            return true
        }
        if path.contains(".mov") {
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
    
}

