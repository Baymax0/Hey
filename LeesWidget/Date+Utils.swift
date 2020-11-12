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
    
    /// 返回时间戳
    var timeStamp:TimeInterval { get }
    
    /// 返回年份
    var yearString:String { get }
    
    /// 返回月份
    var monthString:String { get }
    
    /// 返回日
    var dayString:String { get }
    
    /// 转为格式化字符串
    func toString(_ dateFormat:String, _ isChinese:Bool) -> String
//    func toString(_ dateFormat:String) -> String
    
    /// 获得前进或倒退的时间
    /// Date().addTime(10.hour)
    /// Date().addTime(10.min)
    /// Date().addTime(3.day)
    func addTime(_ time:TimeInterval) -> Date
}

protocol BMDateUtils_String {
    
    func toDate(_ formate:String) -> Date?
    
}







// MARK: -  ---------------------- implement ------------------------
extension Int{
    var sec : TimeInterval{
        return Double(self) * 1
    }
    var min : TimeInterval{
        return Double(self) * 60
    }
    var hour : TimeInterval{
        return Double(self) * 3600
    }
    var day : TimeInterval{
        return Double(self) * 86400
    }
}

extension Date :BMDateUtils {

    func toString(_ dateFormat:String="yyyy-MM-dd HH:mm", _ isChinese:Bool = true) -> String {
        let timeZone = TimeZone.init(identifier: "Asia/Shanghai")
        let formatter = DateFormatter()
        formatter.timeZone = timeZone
        if isChinese {
            formatter.locale = Locale.init(identifier: "zh_CN")
        }
        formatter.dateFormat = dateFormat
        let date = formatter.string(from: self)
        return date
    }
    
    var timeStamp:TimeInterval{
        return self.timeIntervalSince1970
    }

    var yearString:String{
        return toString("yyyy")
    }
    
    /// 返回 03
    var monthString:String{
        return toString("MM")
    }
    /// 返回 03月
    var monthString_Chn:String{
           return toString("MMM", true)
       }
    /// 返回 Mar
    var monthString_Eng:String{
        return toString("MMM", false)
    }
    
    var dayString:String{
        return toString("dd")
    }
    
    var weekend:Int{
        let interval = Int(self.timeIntervalSince1970) + NSTimeZone.local.secondsFromGMT()
        let days = Int(interval/86400) // 24*60*60
        let weekday = ((days + 4)%7+7)%7
        return weekday == 0 ? 7 : weekday
    }
    
    func addTime(_ time:TimeInterval) -> Date {
        let t = self.timeIntervalSince1970 + time
        return Date.init(timeIntervalSince1970: t)
    }
}

extension String : BMDateUtils_String{
    
    func toDate(_ formate:String = "yyyy-MM-dd HH:mm:ss") -> Date?{
        let timeZone = TimeZone.init(identifier: "UTC")
        let formatter = DateFormatter()
        formatter.timeZone = timeZone
        formatter.locale = Locale.init(identifier: "zh_CN")
        formatter.dateFormat = formate
        let date = formatter.date(from: self)
        return date
    }
}

