//
//  BMCacheKey.swift
//  BaseUtilsDemo
//
//  Created by yimi on 2019/8/7.
//  Copyright © 2019 yimi. All rights reserved.
//

import UIKit
import HandyJSON

class Person:HandyJSON {
    var name:String!
    required init() {}
}

// 支持基础数据类型，自定义模型<:HandyJSON>,数组，字典
extension BMDefaultsKeys{
    // userId 和 sessionId 已封装进 请求库
    static let userId = BMCacheKey<String?>("userId")
    static let sessionId = BMCacheKey<String?>("sessionId")
    
    static let p = BMCacheKey<Person?>("sessionId2")

}




