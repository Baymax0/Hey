//
//  JsonExtension.swift
//  LisApp
//
//  Created by yimi on 2019/3/6.
//  Copyright © 2019 baymax. All rights reserved.
//

import Foundation


extension Dictionary {
    func toJsonString() -> String?{
        if (!JSONSerialization.isValidJSONObject(self)) {
            print("无法解析出JSONString")
            return ""
        }
        let data : Data! = try? JSONSerialization.data(withJSONObject: self, options: [])
        let JSONString = String(data: data, encoding: .utf8)
        return JSONString
    }
}

extension String {
    func toJsonDictonary() -> Dictionary<String,Any>?{
        let jsonData:Data = self.data(using: .utf8)!
        let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        return dict as? Dictionary<String,Any>
    }
    
    func toJsonArray() -> Array<Any>?{
        let jsonData:Data = self.data(using: .utf8)!
        let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        return dict as? Array<Any>
    }
}

