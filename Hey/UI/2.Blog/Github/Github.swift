//
//  Github.swift
//  Hey
//
//  Created by 李志伟 on 2021/1/22.
//  Copyright © 2021 baymax. All rights reserved.
//

import Foundation


public class Github{
    
    // 请求post 详情
    static func request(_ url:String, finish: @escaping (_ imgUrl:String?)->()) {
        var paramUrl = url
        var head:[String:String] = [:]
        if url.contains("?"){
            paramUrl = paramUrl + "&access_token=" + cache[.myGithubToken]!
        }else{
            head = ["access_token" : cache[.myGithubToken]!]
        }
        print("请求post详情\n\(url)")
        BMNetwork.sessionManager.request(paramUrl, method: .get, parameters: nil, headers: head).responseString { (response) in
            switch response.result{
                case .success(let json):
                    finish(json)
                case  .failure(let error):
                    print(" ***** 请求失败： ***** ")
                    print("\(error)")
                    finish(nil)
            }
        }
    }
    
    // 保存文件（新建&修改）
    @discardableResult
    static func savePost(_ post:GitHub_CachePost, finish: @escaping (_ resp:ZBJsonModel<GithubPostModel>?)->()) -> DataRequest{
        let token:String = cache[.myGithubToken] ?? ""
        let url = BMApiSet.defaultApi.urlWithHost + "/" + post.name + "?access_token=" + token
        var request = URLRequest(url: URL(string: url)!)
        // method
        request.httpMethod = "PUT"
        // head
        request.setValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        //body
        var body =  [String : String]()
        body["content"] = post.getOrignrlBase64Data()
        body["message"] = Date().toString()
        if post.sha != nil && post.sha.count != 0{// 修改文件用
            body["sha"] = post.sha
        }
        request.httpBody = body.getJsonStr()?.data(using: .utf8)
        
        
        return BMNetwork.sessionManager.request(request).responseJSON { (resp) in
            print("----------------------")
            print(url)
            switch resp.result{
                case .success(let json):
                    let jsonDic = json as? Dictionary<String,Dictionary<String,Any>>
                    let content = jsonDic?["content"]
                    let model = JSONDeserializer<GithubPostModel>.deserializeFrom(dict: content)
                    let result = ZBJsonModel<GithubPostModel>()
                    result.code = 1
                    result.data = model
                    result.msg = ""
                    finish(result)
                case  .failure(let error):
                    print(" ***** 请求失败： ***** ")
                    print("\(error)")
                    let err = BMRequester.bundleError(error as NSError)

                    let result = ZBJsonModel<GithubPostModel>()
                    result.code = err.rawValue
                    result.msg = "网络异常，请求失败"
                    finish(result)
            }
        }
    }
    
    
    
}











