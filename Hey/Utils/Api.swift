//
//  Api.swift
//  Lee
//
//  Created by yimi on 2019/11/5.
//  Copyright © 2019 baymax. All rights reserved.
//

import Foundation

public class NewsApi<ValueType> : BMApiTemplete<ValueType> {
    override var host: String{"https://idaily-cdn.idailycdn.com"}
    override var defaultParam: Dictionary<String, Any>{ [:] }
}

public class WeatherApi<ValueType> : BMApiTemplete<ValueType> {
    override var host: String{"https://idaily-cdn.idailycdn.com/101030100"}
    override var defaultParam: Dictionary<String, Any>{ [:] }
}

public class GithubApi<ValueType> : BMApiTemplete<ValueType> {
    override var host: String{
        if let name = cache[.myGithubName]{
            return "https://api.github.com/repos/\(name)/\(name).github.io"
        }else{
            return ""
        }
    }
    
    override var defaultParam: Dictionary<String, Any>{
        if let name = cache[.myGithubToken]{
            return ["access_token":name]
        }else{
            return [:]
        }
    }

}

//首页接口
extension BMApiSet {
    static let news = NewsApi<Array<IdailyNewsModel>?>("/api/list/v3/iphone/zh-hans")
    static let city = WeatherApi<String?>("")
}

//github接口
extension BMApiSet {
    static let defaultApi = GithubApi<String?>("/contents/_posts")
    static let github_Post = GithubApi<Array<GithubPostModel>?>("/contents/_posts")
}

