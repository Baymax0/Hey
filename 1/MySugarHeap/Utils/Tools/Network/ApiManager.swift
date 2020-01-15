//
//  ApiManager.swift
//  wangfuAgent
//
//  Created by lzw on 2018/8/16.
//  Copyright © 2018 zhuanbangTec. All rights reserved.
//

import UIKit

//接口协议
protocol ApiManager {
    var host: String {get}
    var api: String {get}
    var orignParam:Dictionary<String,Any>{get}
}

extension ApiManager{
    var url: URL {
        return "\(self.host)\(self.api)".url()!
    }
}

// MARK: ---------------------   堆糖接口   ---------------------
enum DTApiManager : ApiManager{
    case null
    case imageSearch //图片搜索
    case hotImg      //热门图片
    case groups      //图片分组
    case groupImage
    case subGroups   //详细分组
    case subGroupImage
}

extension DTApiManager{
    var host: String {
//        "103.21.119.229"
        return "https://221.228.82.177"
    }
    var api: String {
        switch self {
        case .null:
            return ""
        case .imageSearch:
            return "/napi/blog/list/by_search/"
        case .hotImg:
            return "/napi/index/hot/"

        case .groups:
            return "/napi/index/groups/"
        case .groupImage:
            return "/napi/blog/list/by_category/"

        case .subGroups:
            return "/napi/category/detail/"
        case .subGroupImage:
            return "/napi/blog/list/by_filter_id/"
        }
    }
    var orignParam:Dictionary<String,Any>{
        var param = Dictionary<String,Any>()
        param["screen_height"] = Int(KScreenHeight)
        param["screen_width"] = Int(KScreenWidth)
        param["platform_name"] = "iOS"
        param["platform_version"] = "11.4"
        param["device_platform"] = "iPhone10,3"
        param["device_name"] = "Unknown iPhone"
        param["uuid"] = "a1e06615cf440e391c94514ba0bcbae9abd280c1"
        param["app_version"] = "6.16.1 rv:198075"
        param["app_code"] = "gandalf"
        param["__domain"] = "www.duitang.com"
        param["locale"] = "zh_CN"
        return param
    }
}



// MARK: ---------------------   花瓣接口   ---------------------
enum HBApiManager : ApiManager{
    case myThemeList
    case themeImages(_:String)
}

extension HBApiManager{
    var host: String {
        return "https://api.huaban.com"
    }
    var api: String {
        switch self {
        case .myThemeList:
            return "/leezw/following/explores/"
        case .themeImages(let th):
            return "/explore/\(th)"
        }
    }
    var orignParam:Dictionary<String,Any>{
        let param = Dictionary<String,Any>()
        return param
    }
}

// MARK:  ---------------------   天气接口   ---------------------
enum WTApiManager : ApiManager{
    /* 接口来源：
     https://www.nowapi.com/api/weather.future
     */
    case currentWeather(_:String)
    /* 接口来源：
     https://www.sojson.com/api/weather.html
     */
    case futureWeather(_:String)
}

extension WTApiManager{
    var host: String {
        return ""
    }
    var api: String {
        switch self {
        case .currentWeather(_):
            return "http://api.k780.com/"
        case .futureWeather(let city):
            return "https://www.sojson.com/open/api/weather/json.shtml?city=\(city)"
        }
    }
    var orignParam:Dictionary<String,Any>{
        var param = Dictionary<String,Any>()
        switch self {
        case .currentWeather(let ip):
            param["app"] = "weather.today"
            param["weaid"] = ip
            param["appkey"] = "36358"
            param["sign"] = "68cedd8b7f50af04cb5d59eaeb2a25f3"
            param["format"] = "json"
        case .futureWeather(_):
            print("")
//            param["city"] = loc
        }
        return param
    }
}







