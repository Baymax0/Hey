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
    
    //请求
    private static func requestBase<T:RespFormate>(_ apiURL:String, params:[String:Any], _ model:T.Type, finish: @escaping (_ resp:T)->()) -> DataRequest{
        let url = apiURL.url()!
        return Alamofire.request(apiURL, method: .post, parameters: params).responseString { (response) in
            switch response.result{
            case .success(let jsonStr):
                if requestLog{
                    print(apiURL)
                    print(jsonStr)
                }
                if let resp = JSONDeserializer<T>.deserializeFrom(json: jsonStr){
                    resp.code = 1
                    finish(resp)
                }else{
                    let resp = T()
                    resp.code = -1
                    finish(resp)
                }
            //常见 访问失败 原因
            case .failure(let error):
                let resp = T()
                let (a,b) = Network.bundleError(error as NSError)
                resp.code = a
                resp.msg = b
                print("接口访问失败: \(apiURL)  code:\(resp.code!)")
                finish(resp)
            }
        }
    }
    
    
    private static func requestDTBase<T:HandyJSON>(targetUrl:String? = nil ,api:ApiManager, params:[String:Any], model:T.Type, finish: @escaping (_ resp:T?)->()) -> Void{
        var param:[String:Any]? = nil
        var url:URL!
        if targetUrl == nil {
            url = api.url
            param = params
        }else{
            var s = targetUrl!.replacingOccurrences(of: "duitang://www.duitang.com", with: "\(api.host)/napi")
            if params.keys.count != 0{
                var i = 0
                for d in params {
                    if i == 0{
                        if s.contains("?"){
                            s.append("&")
                        }else{
                            s.append("?")
                        }
                    }else{
                        s.append("&")
                    }
                    let par = "\(d.key)=\(d.value)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                    s.append(par!)
                    i += 1
                }
            }
            url = (s.url())!
        }

        Alamofire.request(url, method: .get, parameters: param).responseString { (response) in
            switch response.result{
            case .success(let jsonStr):
                if let resp = JSONDeserializer<T>.deserializeFrom(json: jsonStr){
                    finish(resp)
                }else{
                    HUD.showText("解析失败")
                    finish(nil)
                }
            //常见 访问失败 原因
            case .failure(let error):
                let (_,msg) = Network.bundleError(error as NSError)
                print("接口访问失败: \(api.url)  code:\(msg)")
                HUD.showText("访问失败")
                finish(nil)
            }
        }
    }

}


extension Network {
    //堆糖 请求
    static func requestDT<T: HandyJSON>(targetUrl:String? = nil ,api:DTApiManager, params:Dictionary<String,Any>, model:T.Type, finish: @escaping (_ rep:T?)->()) -> Void{
        var orignParam = api.orignParam
        orignParam.merge(params) { (a, b) -> Any in return a}
        Network.requestDTBase(targetUrl:targetUrl, api:api, params: orignParam, model:(DTRespObject<T>).self) { (mod) in finish(mod?.data) }
    }
    //堆糖 请求
    static func requestDTList<T: HandyJSON>(targetUrl:String? = nil ,api:DTApiManager, params:Dictionary<String,Any>, model:T.Type, finish: @escaping (_ rep:[T]?)->()) -> Void{
        var orignParam = api.orignParam
        orignParam.merge(params) { (a, b) -> Any in return a}
        Network.requestDTBase(targetUrl:targetUrl, api:api, params: orignParam, model:(DTRespArrayObject<T>).self) { (mod) in finish(mod?.data) }
    }


    //当前天气
    static func requesrCurrentWeather(address:String, finish: @escaping (_ rep:RealTimeWeatherModel?)->()) -> Void{
        let api = WTApiManager.currentWeather(address)
        let orignParam = api.orignParam
        Network.requestDTBase(targetUrl:nil, api:api, params: orignParam, model:WeatherBase1.self) { (mod) in finish(mod?.result)
        }
    }
    static func requestFutureWeather(address:String, finish: @escaping (_ rep:WeatherBase2?)->()) -> Void{
        let api = WTApiManager.futureWeather(address)
        let orignParam = api.orignParam
        Network.requestDTBase(targetUrl:api.api, api:api, params: orignParam, model:WeatherBase2.self) { (mod) in finish(mod)
        }
    }
    //查询ip
    static func requiredIP(finish: @escaping (_ ip:String?)->()) -> Void{
        Alamofire.request("http://pv.sohu.com/cityjson?ie=utf-8", method: .get, parameters: nil).responseString { (response) in
            switch response.result{
            case .success(let jsonStr):
                //var returnCitySN = {"cip": "115.234.159.198", "cid": "330300", "cname": "浙江省温州市"};
                if jsonStr.hasPrefix("var returnCitySN = "){
                    let newJson = jsonStr.replacingOccurrences(of: "var returnCitySN = ", with: "").replacingOccurrences(of: ";", with: "")
                    let jsonData:Data = newJson.data(using: .utf8)!
                    let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
                    if let dic =  dict as? Dictionary<String,String>{
                        if let ip = dic["cip"]{
                            finish(ip)
                            return
                }}}
                print("ip 获取失败")
                finish(nil)
            //常见 访问失败 原因
            case .failure(let _):
                print("ip 获取失败")
                finish(nil)
            }
        }
    }
}

extension Network {
    
    @discardableResult
    static func requestTK(_ api:String, params:[String:Any]? = nil, finish: @escaping (_ rep:RespTK)->()) -> DataRequest{
        let p = params ?? Dictionary<String,Any>()
        return Network.requestBase(api, params: p, RespTK.self, finish: finish)
    }
    
}

