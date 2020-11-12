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
    
    // userId 和 sessionId 已封装进 请求库
    static let userId = BMCacheKey<String?>("userId")
    static let sessionId = BMCacheKey<String?>("sessionId")
    static let foldSetting = BMCacheKey<FoldSetting?>("foldSetting")
    static let ImgTags = BMCacheKey<String?>("ImgTags")

    static let imageTagsDic = BMCacheKey<Dictionary<String,Any>?>("imageTagsDic")
    
    // 请求默认参数
    static let oneRequestDic = BMCacheKey<Dictionary<String,Any>?>("oneRequestDic")
    // 首页列表每日详情缓存字典，日期“2020-10-01”作为key
    static let one_DayInfo_Dic = BMCacheKey<Dictionary<String,Any>?>("one_DayInfo_Dic")
}

