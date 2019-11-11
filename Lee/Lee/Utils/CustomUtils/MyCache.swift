//
//  MyCache.swift
//  Lee
//
//  Created by yimi on 2019/11/8.
//  Copyright © 2019 baymax. All rights reserved.
//

import UIKit
import HandyJSON

// 支持基础数据类型，自定义模型<:HandyJSON>,数组，字典
extension BMDefaultsKeys{
    // userId 和 sessionId 已封装进 请求库
    static let newsList = BMCacheKey<Array<IdailyNewsModel>?>("newsList")

    
}

