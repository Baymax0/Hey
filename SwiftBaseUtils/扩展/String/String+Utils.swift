//
//  Sting+Utils.swift
//  wangfuAgent
//
//  Created by lzw on 2018/7/18.
//  Copyright © 2018 zhuanbangTec. All rights reserved.
//

import UIKit
import Foundation


// MARK: -  ----------------------  ------------------------
extension Optional where Wrapped == String{
    /// if nil or "" return false
    var notEmpty: Bool {
        if self == nil{
            return false
        }
        return !self!.isEmpty
    }
    
    /// if nil return 0
    var bm_count:Int{
        if self == nil{
            return 0
        }else{
            return self!.count
        }
    }
    
    func toInt() -> Int{
        if self == nil{
            return 0
        }else{
            if let i = Int(self!){
                return i
            }else{
                return 0
            }
        }
    }
    
    func toFloat() -> Float{
        if self == nil{
            return 0
        }else{
            if let i = Float(self!){
                return i
            }else{
                return 0
            }
        }
    }
    
    func toDouble() -> Double{
        if self == nil{
            return 0
        }else{
            if let i = Double(self!){
                return i
            }else{
                return 0
            }
        }
    }
}
// MARK: -  ---------------------- 文字宽高 ------------------------
extension String{
    func stringWidth(_ fontSize:CGFloat) -> CGFloat{
        let font:UIFont = UIFont.systemFont(ofSize: fontSize)
        let attributes = [NSAttributedString.Key.font:font]
        let option = NSStringDrawingOptions.usesLineFragmentOrigin
        let rect:CGRect = self.boundingRect(with: CGSize(width: 2000.0, height: fontSize*1.4), options: option, attributes: attributes, context: nil)
        return rect.size.width
    }
    
    func stringHeight(_ fontSize:CGFloat, width:CGFloat) -> CGFloat{
        let font:UIFont = UIFont.systemFont(ofSize: fontSize)
        let attributes = [NSAttributedString.Key.font:font]
        let option = NSStringDrawingOptions.usesLineFragmentOrigin
        var rect:CGRect!

        if self.count != 0 {
            rect = self.boundingRect(with: CGSize(width: width, height: 2000), options: option, attributes: attributes, context: nil)
        }else{
            rect = " ".boundingRect(with: CGSize(width: width, height: 2000), options: option, attributes: attributes, context: nil)
        }
        return rect.size.height
    }
}

// MARK: -  ---------------------- 判断 ------------------------
extension String{
    
    /// if nil or "" return false
    var notEmpty: Bool {
        return !self.isEmpty
    }
    
    ///判断 是否 是 数字
    var isPurnInt:Bool {
        let scan: Scanner = Scanner(string: self)
        var val:Int = 0
        return scan.scanInt(&val) && scan.isAtEnd
    }
}



extension String{
    
    /// 用于textviewDelegate里 获得输入后的问字
    mutating func replace(nsRange:NSRange,text:String){
        guard
            let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex),
            let to16 = utf16.index(from16, offsetBy: nsRange.length, limitedBy: utf16.endIndex),
            let from = String.Index(from16, within: self),
            let to = String.Index(to16, within: self)
            else { return }
        let range = from ..< to
        self.replaceSubrange(range, with: text)
    }
    
    func substring(_ toIndex:Int) -> String {
        if self.count == 0 {
            return ""
        }
        let index = self.index(self.startIndex, offsetBy: toIndex)
        return String(self.prefix(upTo: index))
    }
    
    
    
    var urlEncode:String?{
        let new = self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        return new
    }

    var image:UIImage?{
        return UIImage(named: self)
    }

    func  toInt() -> Int{
        if let i = Int(self){
            return i
        }else{
            return 0
        }
    }
    
    func toFloat() -> Float{
        if let i = Float(self){
            return i
        }else{
            return 0
        }
    }
    
    func toDouble() -> Double{
        if let i = Double(self){
            return i
        }else{
            return 0
        }
    }
    ///去除前后空格
    func clearSpace() -> String {
        let s = self.trimmingCharacters(in: .whitespaces)
        return s
    }
}

// MARK: -  ---------------------- 时间 ------------------------
extension String{
    /// "yyyy-MM-dd HH:mm:ss"  ->   Date()  字符串转时间
    func toDate(_ dateFormat:String = "yyyy-MM-dd HH:mm:ss") -> Date!{
        let formatter = DateFormatter()
        formatter.locale = Locale.init(identifier: "zh_CN")
        formatter.dateFormat = dateFormat
        let date = formatter.date(from: self)
        return date!
    }
    
    /// "yyyy-MM-dd HH:mm:ss"  ->  1348747434  字符串转时间戳
    func toTimeInterval(_ dateFormat:String? = "yyyy-MM-dd HH:mm:ss") -> TimeInterval {
        if self.isEmpty {
            return 0
        }
        let format = DateFormatter.init()
        format.dateStyle = .medium
        format.timeStyle = .short
        if dateFormat == nil {
            format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        }else{
            format.dateFormat = dateFormat
        }
        let date = format.date(from: self)
        let d = date!.timeIntervalSince1970
        return d
    }
    
    /// 转变日期字符串的样式
    func changeDateStrFormate(fromFormate:String = "yyyy-MM-dd HH:mm:ss",toFormate:String = "yyyy-MM-dd") -> String{
        if self.count == 0 {
            return ""
        }
        
        let timeZone = TimeZone.init(identifier: "UTC")
        let formatter = DateFormatter()
        formatter.timeZone = timeZone
        formatter.locale = Locale.init(identifier: "zh_CN")
        formatter.dateFormat = fromFormate
        let date = formatter.date(from: self)
        let s = date?.toString(toFormate)
        return s!
    }
    
    
    
}







