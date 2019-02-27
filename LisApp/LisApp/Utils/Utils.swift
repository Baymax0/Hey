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
    
    static func isDirectory2(_ path:String) -> Bool {
        if Utils.isVideoFile(path){
            return false
        }
        if Utils.isImageFile(path){
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
    
}

