//
//  NetworkTool.swift
//  wangfuAgent
//
//  Created by YiMi on 2018/7/11.
//  Copyright © 2018 lizhiwei. All rights reserved.
//

import UIKit
import Alamofire
import HandyJSON


class Network{
    private static func requestBase<T:HandyJSON>(_ api:ApiManager, params:[String:Any], _ model:T.Type, finish: @escaping (_ resp:T?)->()) -> Void{
        let param = params
        Alamofire.request(api.url, method: .post, parameters: param).responseString { (response) in
            switch response.result{
            case .success(let jsonStr):
                if let resp = JSONDeserializer<T>.deserializeFrom(json: jsonStr){
                    finish(resp)
                }else{
                    HUD.text("解析失败")
                    finish(nil)
                }
            //常见 访问失败 原因
            case .failure(let error):
                let (_,msg) = Network.bundleError(error as NSError)
                print("接口访问失败: \(api.url)  code:\(msg)")
                HUD.text("访问失败")
                finish(nil)
            }
        }
    }

    private static func bundleError(_ err:NSError) -> (Int,String){
        var code = -1
        var msg = ""
        switch err.code{
        case -1002:
            code = -1002
            msg  = "请求地址无效"
        case -1003:
            code = -1003
            msg  = "服务器无法访问"
        case -1009:
            code = -1009
            msg  = "当前应用无法访问网络，请检查设置中是否允许访问网络，并且手机不在飞行模式"
        case 4:
            code = -2004
            msg  = "数据解析失败"
        default:
            print("未处理的 error code:\(err.code)\n \(err)")
            code = -9999
            msg  = "请求失败"
        }
        return (code,msg)
    }
}

extension Network {
    //堆糖 请求
    static func requestDT<T: HandyJSON>(_ api:DTApiManager, params:Dictionary<String,Any>, model:T.Type, finish: @escaping (_ rep:T?)->()) -> Void{
        Network.requestBase(api, params: params, (DTRespObject<T>).self) { (mod) in finish(mod?.data) }
    }

}



