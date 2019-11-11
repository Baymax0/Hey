//
//  Date+Utils.swift
//  wangfuAgent
//
//  Created by lzw on 2018/8/6.
//  Copyright © 2018 zhuanbangTec. All rights reserved.
//

import Foundation
// MARK: -  ---------------------- protocol ------------------------

protocol BMDateUtils {
    // 转位 String 类型
    func toString(_ dateFormat:String) -> String
    
    var yearString:String { get }
    
    var monthString:String { get }
    
    var dayString:String { get }
    // 通过字符串 和 格式 创建Date类型
    static func date(from string:String, formate:String) -> Date?
    // 获得前进或倒退的时间
    func addTime(_ time:TimeInterval) -> Date
}

protocol BMDateUtils_String {
    func toDate(_ formate:String) -> Date?
    
    func toDateString(_ fromFormate:String, toFormate:String) -> String
}

// MARK: -  ---------------------- implement ------------------------

extension Date :BMDateUtils {

    func toString(_ dateFormat:String="yyyy-MM-dd HH:mm") -> String {
        let timeZone = TimeZone.init(identifier: "UTC")
        let formatter = DateFormatter()
        formatter.timeZone = timeZone
        formatter.locale = Locale.init(identifier: "zh_CN")
        formatter.dateFormat = dateFormat
        let date = formatter.string(from: self)
//        return date.components(separatedBy: " ").first!
        return date 
    }

    var yearString:String{
        return toString("yyyy")
    }
    
    var monthString:String{
        return toString("MM")
    }
    
    var dayString:String{
        return toString("yyyy-MM-dd")
    }

    static func date(from string:String, formate:String) -> Date?{
        let timeZone = TimeZone.init(identifier: "UTC")
        let formatter = DateFormatter()
        formatter.timeZone = timeZone
        formatter.locale = Locale.init(identifier: "zh_CN")
        formatter.dateFormat = formate
        let date = formatter.date(from: string)
        return date
    }
    
    func addTime(_ time:TimeInterval) -> Date {
        let t = self.timeIntervalSince1970 + time
        return Date.init(timeIntervalSince1970: t)
    }
}

extension String : BMDateUtils_String{
    func toDate(_ formate:String) -> Date?{
        let timeZone = TimeZone.init(identifier: "UTC")
        let formatter = DateFormatter()
        formatter.timeZone = timeZone
        formatter.locale = Locale.init(identifier: "zh_CN")
        formatter.dateFormat = formate
        let date = formatter.date(from: self)
        return date
    }
    
    func toDateString(_ fromFormate:String = "yyyy-MM-dd HH:mm:ss",toFormate:String = "yyyy-MM-dd") -> String{
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


extension Int{
    func toDate() -> Date{
        let data = Date(timeIntervalSince1970: TimeInterval(self))
        return data
    }
}
