//
//  Any+Utils.swift
//  wangfuAgent
//
//  Created by lzw on 2018/7/30.
//  Copyright © 2018 zhuanbangTec. All rights reserved.
//

import UIKit

extension Optional where Wrapped == Int{
    //判断 是否 是 数字
    func toString(_ defaultVal:String? = nil) -> String?{
        if self == nil{
            return defaultVal
        }else{
            return self!.toString()
        }
    }
}

extension Int{
    func toString() -> String{
        return String(self)
    }
}

extension Int64{
    func fileSizeString() -> String? {
        var temp:Double = Double(self)
        var size = "B"
        if temp <= 0{
            return nil
        }
        temp = temp/1024
        size = "KB"
        if temp>1024{
            temp = temp/1024
            size = "MB"
        }
        if temp>1024{
            temp = temp/1024
            size = "GB"
        }
        let result = String(format: "%@%@", temp.pretyString(true),size)
        return result
    }
}


extension Float{

    /// 格式化 浮点数 以1，000，000 形式表示100W
    func pretyFloatStr() -> String {
        var result = String(format: "%0.2f", self)
        var index:Int = 6
        while result.count > index {
            result.insert(",", at: result.index(result.startIndex, offsetBy: (result.count-index)))
            index = index + 4
        }
        return result
    }
    
    /// 格式化输出 hideDot末尾为.00时  省略
    func pretyString(_ hideDot :Bool = false) -> String {
        let result = String(format: "%0.2lf", self)
        if hideDot{
            if result.contains(".00"){
                return String(format: "%0.0lf", self)
            }
        }
        return result
    }
    
    func fileSizeString() -> String? {
        var temp:Float = 0.0
        var size = ""
        if self <= 0{
            return nil
        }
        if self>1024{
            temp = temp/1024
            size = "kB"
        }
        if self>1024{
            temp = temp/1024
            size = "MB"
        }
        if self>1024{
            temp = temp/1024
            size = "GB"
        }
        let result = String(format: "%@%@", temp.pretyString(true),size)
        return result
    }
    
    
}

extension Double{
    //格式化 浮点数
    func pretyFloatStr() -> String {
        var result = String(format: "%0.2lf", self)
        var index:Int = 6
        while result.count > index {
            result.insert(",", at: result.index(result.startIndex, offsetBy: (result.count-index)))
            index = index + 4
        }
        return result
    }
    
    /// 格式化输出 hideDot末尾为.00时  省略
    func pretyString(_ hideDot :Bool = false) -> String {
        let result = String(format: "%0.2lf", self)
        if hideDot{
            if result.contains(".00"){
                return String(format: "%0.0lf", self)
            }
        }
        return result
    }
    
    func fileSizeString() -> String? {
        var temp:Double = self
        var size = "B"
        if temp <= 0{
            return nil
        }
        temp = temp/1024
        size = "KB"
        if temp>1024{
            temp = temp/1024
            size = "MB"
        }
        if temp>1024{
            temp = temp/1024
            size = "GB"
        }
        let result = String(format: "%@%@", temp.pretyString(true),size)
        return result
    }
}


