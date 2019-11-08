//
//  Api.swift
//  Lee
//
//  Created by yimi on 2019/11/5.
//  Copyright © 2019 baymax. All rights reserved.
//

import Foundation
import Alamofire

enum NewsApi:String, ApiManager{
    // 同域名的 添加枚举类型  值为路由名称
    case news = "list/v3/iphone/zh-hans"
    
    //域名
    var host: String { return "https://idaily-cdn.idailycdn.com" }
    var api: String { return "/api/" + self.rawValue }
    var url: URL { return URL.init(string: "\(self.host)\(self.api)")! }
    var method: HTTPMethod { return .get}
}

