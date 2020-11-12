//
//  Date+Utils.swift
//  wangfuAgent
//
//  Created by lzw on 2018/8/6.
//  Copyright © 2018 zhuanbangTec. All rights reserved.
//

import Foundation

extension Optional where Wrapped == Date{
    public var isToday: Bool{
        if self == nil {
            return false
        }else{
            return self!.isToday
        }
    }
}


extension Date {
    func toString(_ dateFormat:String="yyyy-MM-dd HH:mm") -> String {
        let timeZone = TimeZone(identifier: "Asia/Shanghai")
        let formatter = DateFormatter()
        formatter.timeZone = timeZone
        formatter.locale = Locale.init(identifier: "zh_CN")
        formatter.dateFormat = dateFormat
        let date = formatter.string(from: self)
        return date
    }
    
    func toTimeInterval() -> TimeInterval {
        return self.timeIntervalSince1970
    }

    var yearString:String{
        return toString("yyyy")
    }
    
    var monthString:String{
        return toString("MM")
    }
    
    var dayString:String{
        return toString("dd")
    }
    
    var hourString:String{
        return toString("HH")
    }
    
    var minuteString:String{
        return toString("mm")
    }
    
    var secendString:String{
        return toString("ss")
    }
    
    var weekend:Int{
        let interval = Int(self.timeIntervalSince1970) + NSTimeZone.local.secondsFromGMT()
        let days = Int(interval/86400) // 24*60*60
        let weekday = ((days + 4)%7+7)%7
        return weekday == 0 ? 7 : weekday
    }
    
    // 是否是今天
    public var isToday: Bool{
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        return format.string(from: self) == format.string(from: Date())
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
