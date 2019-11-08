//
//  ApiManager.swift
//  wangfuAgent
//
//  Created by lzw on 2018/8/16.
//  Copyright © 2018 zhuanbangTec. All rights reserved.
//

import UIKit
import Alamofire

protocol ApiManager {
    var host    : String { get }
    var api     : String { get }
    var url     : URL { get }
    var method  : HTTPMethod {get}
}

extension ApiManager{
    var url: URL {
        return URL.init(string: "\(self.host)\(self.api)")!
    }
}

// 不同域名的 通过新扩展 ApiManager 实现
enum ImageApi:String, ApiManager{
    // 同域名的 添加枚举类型  值为路由名称
    case upload = "YmUpload_image"

    //域名
    var host: String { return "http://192.168.0.0" }
    var api: String { return "/api/" + self.rawValue }
    var url: URL { return URL.init(string: "\(self.host)\(self.api)")! }
    var method  : HTTPMethod {return .post}
}

enum BaseApi:String, ApiManager{
    case none = ""
    //域名
    var host: String { return "http://192.168.0.0" }
    var api: String { return "/api/" + self.rawValue}
    var url: URL { return URL.init(string: "\(self.host)\(self.api)")! }
    var method  : HTTPMethod {return .post}
}

