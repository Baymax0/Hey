//
//  Date+Utils.swift
//  wangfuAgent
//
//  Created by lzw on 2018/8/6.
//  Copyright © 2018 zhuanbangTec. All rights reserved.
//

import Foundation

extension Date {

    func toString(_ dateFormat:String="yyyy-MM-dd HH:mm") -> String {
        let formatter = DateFormatter()
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


}



