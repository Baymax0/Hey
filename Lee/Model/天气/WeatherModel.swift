//
//  WeatherModel.swift
//  Lee
//
//  Created by yimi on 2019/11/21.
//  Copyright © 2019 baymax. All rights reserved.
//

import UIKit
import HandyJSON

class WeatherApiModel: HandyJSON {
    var message : String!  // "success感谢又拍云(upyun.com)提供CDN赞助",
    var status : Int! // 200,
    var date : String! // "20191120",
    var time : String! // "2019-11-21 11:06:25",
    var data : WeatherToday! // {
    required init() {}
}

class WeatherToday: HandyJSON{
    var shidu : String!     // "61%",
    var pm25 : String!      // 113,
    var pm10 : String!      // 174,
    var quality : String!   // "轻度污染",
    var wendu : String!     // "7",
    var ganmao : String!    // "儿童、老年人及心脏、呼吸系统疾病患者人群应减少长时间或高强度户外锻炼",
    var forecast : Array<WeatherModel>!  // 未来15天天气
    
    required init() {}
}

class WeatherModel: HandyJSON {
    var date : String!      // "20",
    var high : String!      // "高温 10℃",
    var low : String!       // "低温 2℃",
    var ymd : String!       // "2019-11-20",
    var week : String!      // "星期三",
    var sunrise : String!   // "06:58",
    var sunset : String!    // "16:55",
    var aqi : String!       // 140,
    var fx : String!        // "东南风",
    var fl : String!        // "<3级",
    var type : String!      // "晴",
    var notice : String!    // "愿你拥有比阳光明媚的心情"
    required init() {}
}
