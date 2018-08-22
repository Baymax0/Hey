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
}
extension ApiManager{
    var url: URL {
        return URL.init(string: "\(self.host)\(self.api)")!
    }
}

//堆糖接口
enum DTApiManager : ApiManager{
    case login
}
extension DTApiManager{
    var host: String {
        return "221.228.82.177"
    }
    var api: String {
        switch self {
        case .login:
            return "/YmUpload_image"
        }
    }


}

