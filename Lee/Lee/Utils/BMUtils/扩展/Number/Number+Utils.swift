//
//  Any+Utils.swift
//  wangfuAgent
//
//  Created by lzw on 2018/7/30.
//  Copyright © 2018 zhuanbangTec. All rights reserved.
//

import UIKit

// MARK: -  ---------------------- protocol ------------------------
protocol BMNumberUtils {
    func toString() -> String?
}

protocol BMDoubleUtils {
    func toString() -> String?
    /// 格式化输出 eg f.toString("%0.2f")
    func toString(_ formate:String) -> String?
    
    ///  以 12,345.67 形式表示12345.678
    func pretyFloatStr() -> String
    
    /// 末尾保留两位小数 为0时省略
    func hideDotStr() -> String
}

// MARK: -  ---------------------- implement ------------------------

extension Optional : BMNumberUtils  where Wrapped == Int{
    //判断 是否 是 数字
    func toString() -> String?{
        if self == nil{
            return nil
        }else{
            return self!.toString()
        }
    }
}

extension Int : BMNumberUtils{
    func toString() -> String?{
        return String(self)
    }
}

extension String{
    func hideDot() -> String {
        if self.contains(".00"){
            return self.replacingOccurrences(of: ".00", with: "")
        }
        return self
    }
}


extension Float : BMNumberUtils, BMDoubleUtils{
    func toString() -> String?{
        return String(self)
    }
    func toString(_ formate:String) -> String?{
        return String(format: formate, self)
    }
    /// 格式化 浮点数 以1,000,000.00 形式表示1000000
    func pretyFloatStr() -> String {
        var result = String(format: "%0.2f", self)
        var index:Int = 6
        while result.count > index {
            result.insert(",", at: result.index(result.startIndex, offsetBy: (result.count-index)))
            index = index + 4
        }
        return result
    }
    
    func hideDotStr() -> String {
        var result = String(format: "%0.2f", self)
        if result.hasSuffix(".00"){
            result = String(format: "%0.0f", self)
        }else if result.hasSuffix("0"){
            result = String(format: "%0.1f", self)
        }
        return result
    }
}

extension Double{
    func toString() -> String?{
        return String(self)
    }
    func toString(_ formate:String) -> String?{
        return String(format: formate, self)
    }
    /// 格式化 浮点数 以1,000,000.00 形式表示100W
    func pretyFloatStr() -> String {
        var result = String(format: "%0.2f", self)
        var index:Int = 6
        while result.count > index {
            result.insert(",", at: result.index(result.startIndex, offsetBy: (result.count-index)))
            index = index + 4
        }
        return result
    }
}





