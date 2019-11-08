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

enum RequestError : Int{
    case cancel            = -999
    case timeOut            = -1001
    case requestFalid       = -1002
    case serverConnectFalid = -1003
    case noNetwork          = -1009
    case jsonDeserializeFalid   = -2003
    case responsDeserializeFalid   = -2004
    case noMsg  = -9998
    case unknow = -9999

    var msg :String{
        switch  self {
        case .cancel:
            return "请求被取消"
        case .timeOut:
            return "请求超时"
        case .requestFalid:
            return "请求地址无效"
        case .serverConnectFalid:
            return "服务器无法访问"
        case .noNetwork:
            return "无法访问网络"
        case .jsonDeserializeFalid:
            return "数据解析失败"
        case .responsDeserializeFalid:
            return "数据解析失败"
        case .noMsg:
            return ""
        case .unknow:
            return "请求失败"
        }
    }
}


class Network{
    /// 打印请求参数
    static var printParam:Bool = true
    /// 打印返回参数（url + resp）
    static var printResp:Bool = false
    
    //请求
    @discardableResult
    static func baseRequestArray<T:HandyJSON>(_ api:ApiManager, params:[String:Any], _ model:T.Type, finish: @escaping (_ resp:Array<T>?)->()) -> DataRequest{
        var param = params
        
        //如果登录 就都传 登录信息 也不影响那些不需要登陆信息的接口
        if let session = Cache[.sessionId]{
            param["userId"] = Cache[.userId]
            param["sessionId"] = session
        }
        
        if printParam {
            print("\(api.url)?\(params.getUrlParam())")
        }
        
        return Alamofire.request(api.url, method: api.method, parameters: param).responseString { (response) in
            switch response.result{
            case .success(let jsonStr):
                if printResp{
                    print(api.url)
                    print(jsonStr)
                }
                if let resp = Array<T>.deserialize(from: jsonStr) as? Array<T>{
                    finish(resp)
                }else{
                    print("接口访问失败: \(api.url)")
                    finish(nil)
                }
            //常见 访问失败 原因
            case .failure(let error):
                let err = Network.bundleError(error as NSError)
                print("接口访问失败: \(api.url)  code:\(err.rawValue)")
            }
        }
    }
    
    //请求
    static func requestBase<T:RespFormate>(_ api:ApiManager, params:[String:Any], _ model:T.Type, finish: @escaping (_ resp:T)->()) -> DataRequest{
        var param = params

        //如果登录 就都传 登录信息 也不影响那些不需要登陆信息的接口
        if let session = Cache[.sessionId]{
            param["userId"] = Cache[.userId]
            param["sessionId"] = session
        }
        
        if printParam {
            print("\(api.url)?\(params.getUrlParam())")
        }

        return Alamofire.request(api.url, method: api.method, parameters: param).responseString { (response) in
            switch response.result{
                case .success(let jsonStr):
                    if printResp{
                        print(api.url)
                        print(jsonStr)
                    }
                    if let resp = JSONDeserializer<T>.deserializeFrom(json: jsonStr){
                        if resp.code == 2{
                            Utils.pushLoginView()
                        }
                        finish(resp)
                    }else{
                        let err = RequestError.jsonDeserializeFalid
                        let resp = T()
                        resp.code = err.rawValue
                        resp.msg = err.msg
                        print("接口访问失败: \(api.url)  code:\(resp.code!)")
                        finish(resp)
                    }
            //常见 访问失败 原因
            case .failure(let error):
                let resp = T()
                let err = Network.bundleError(error as NSError)
                resp.code = err.rawValue
                resp.msg = err.msg
                print("接口访问失败: \(api.url)  code:\(resp.code!)")
                finish(resp)
            }
        }
    }
    //上传
    private static func uploadBase(_ img:UIImage, uploading:((_ progress:Double) -> ())?, finish: @escaping (_ imgUrl:String?)->()) -> Void{
        let api = ImageApi.upload
        let imageData = img.jpegData(compressionQuality: 0.3)

        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(imageData!, withName: "file", fileName: "123.jpeg", mimeType: "image/jpeg")
        }, to: api.url){ (encodingResult) in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseString(completionHandler: { (response) in
                    switch response.result{
                    //请求成功
                    case .success(let jsonString):
                        if let resp = JSONDeserializer<RespDic>.deserializeFrom(json: jsonString) {
                            if resp.code == 1{
                                let data = resp.data
                                if let url = data?["url"] as? String{
                                    if printResp{
                                        print(url)
                                    }
                                    finish(url)
                                }else{
                                    finish(nil)
                                }
                            }else{
                                finish(nil)
                            }
                        }else{
                            finish(nil)
                        }
                    //常见 访问失败 原因
                    case .failure(let error ):
                        print(error)
                        finish(nil)
                    }
                })
                //获取上传进度
                upload.uploadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
                    DispatchQueue.main.sync {
                        uploading?(progress.fractionCompleted)
                    }
                }
            case .failure(_):
                finish(nil)
            }
        }
    }
    

    private static func bundleError(_ err:NSError) -> RequestError{
        switch err.code{
        case -999:
            return RequestError.cancel
        case -1001:
            return RequestError.timeOut
        case -1002:
            return RequestError.requestFalid
        case -1003:
            return RequestError.serverConnectFalid
        case -1009:
//            let vc = UIApplication.shared.keyWindow?.rootViewController
//            vc?.showComfirm("提醒", "当前网络无法访问，请确保当前不在飞行模式，且在系统应用\n \"设置\"-\"网付\"-\"无线数据\" \n 中允许网付使用\"WLAN与蜂窝移动网\"")
            return RequestError.noNetwork
        case 4:
            return RequestError.responsDeserializeFalid
        default:
            print("未处理的 error code:\(err.code)\n \(err)")
            return RequestError.unknow

        }
    }
}

extension Network {
    /// 返回字典类型
    @discardableResult
    static func requestDic(_ api:ApiManager, params:[String:Any]? = nil, finish: @escaping (_ rep:RespDic)->()) -> DataRequest{
        let p = params ?? Dictionary<String,Any>()
        return Network.requestBase(api, params: p, RespDic.self, finish: finish)
    }
    
    /// 请求模型T 继承 HandyJSON
    @discardableResult
    static func requestModel<T: HandyJSON>(_ api:ApiManager, params:Dictionary<String,Any>? = nil, model:T.Type, finish: @escaping (_ rep:RespObject<T>)->()) -> DataRequest{
        let p = params ?? Dictionary<String,Any>()
        return Network.requestBase(api, params: p, (RespObject<T>).self, finish: finish)
    }
    
    /// 返回模型数组
    @discardableResult
    static func requestArray<T: HandyJSON>(_ api:ApiManager, params:Dictionary<String,Any>? = nil, model:T.Type, finish: @escaping (_ rep:RespObjectArray<T>)->()) -> DataRequest{
        let p = params ?? Dictionary<String,Any>()
        return Network.requestBase(api, params: p, (RespObjectArray<T>).self, finish: finish)
    }
    
    /// 上传图片
    static func upload(_ img:UIImage, uploading:((_ progress:Double) -> ())?, finish: @escaping (_ imgUrl:String?)->()) -> Void{
        Network.uploadBase(img, uploading: uploading, finish:finish)
    }
//    static func requestAllList<T: HandyJSON>(_ api:ApiManager, params:Dictionary<String,Any>? = nil, model:T.Type, finish: @escaping (_ rep:RespObjectArray<T>)->()) -> Void{
//        let p = params ?? Dictionary<String,Any>()
//        Network.requestBase(api, params: p, (RespObjectArray<T>).self, finish: finish)
//    }
}



