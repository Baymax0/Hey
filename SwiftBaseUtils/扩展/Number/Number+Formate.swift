//
//  Number+Formate.swift
//  BaseUtilsDemo
//
//  Created by 李志伟 on 2020/12/11.
//  Copyright © 2020 yimi. All rights reserved.
//

import UIKit

enum NumberFormateType:String{
    // 精确位数
    case float_0    // 整数
    case float_1    // 小数点后1位
    case float_2    // 小数点后2位

    // 格式化
    case comma // 大数字 用逗号： 77,335,444
    case hideDot      // 当小数点后为0 省略

    // 单位
    case fileSize   // 带单位后缀 22MB 4.123GB
}

protocol BMNumberFormate {
    func getFormateString(_ formates:[NumberFormateType]) -> String
}


extension String : BMNumberFormate{
    func getFormateString(_ formates: [NumberFormateType]) -> String {
        guard let fl = Double(self) else { return "0"}
        return fl.getFormateString(formates)
    }
}

extension Double : BMNumberFormate{
    func getFormateString(_ formates:[NumberFormateType]) -> String{
        var fl = self
        var result = "" //结果
        var suffix = ""   //后缀
        
        for t in formates{
            if t == .fileSize{
                var temp:Double = fl
                suffix = "B"
                if temp >= 1024{
                    temp = temp/1024
                    suffix = "KB"
                }
                if temp >= 1024{
                    temp = temp/1024
                    suffix = "MB"
                }
                if temp >= 1024{
                    temp = temp/1024
                    suffix = "GB"
                }
                fl = temp
            }
        }
        
        for t in formates{
            if t == .float_0{
                result = String(format: "%0.0f", fl)
            }
            if t == .float_1{
                result = String(format: "%0.1f", fl)
            }
            if t == .float_2{
                result = String(format: "%0.2f", fl)
            }
        }
        
        for t in formates{
            if t == .hideDot{
                // 小数点后全为0时 才隐藏 变为整数
                if result.hasSuffix(".00"){
                    result = String(format: "%0.0f", fl)
                }
                if result.hasSuffix(".0"){ //3.01不会出发此后缀条件
                    result = String(format: "%0.0f", fl)
                }
            }
            
            if t == .comma{
                // 根据整数位的长度 加 ","
                let length = String(format: "%0.0f", fl).count
                var index = 3
                while length > index {
                    result.insert(",", at: result.index(result.startIndex, offsetBy: (result.count-index)))
                    index = index + 4
                }
            }
        }
        
        result = result + suffix
        return result
    }
}
