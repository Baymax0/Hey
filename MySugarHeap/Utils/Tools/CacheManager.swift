//
//  CacheManager.swift
//  wangfuAgent
//
//  Created by lzw on 2018/7/17.
//  Copyright © 2018 zhuanbangTec. All rights reserved.
//

import UIKit
import HandyJSON


let Cache = CacheManager.share

/// 缓存Key 通过 Cache[.account] 设置 获取
enum CacheKey_String:String {
    case account
    case userId
    case sessionId
}

/// 自定义类型 通过 set get方法 字符串用
enum CacheKey_List:String {
    case merchant_Search_History
}


class CacheManager: NSObject {

    fileprivate static let share = CacheManager()
    fileprivate let Defaults = UserDefaults.standard

    //字符串
    subscript(key:CacheKey_String) -> String?{
        get {
            return Defaults.string(forKey: key.rawValue)
        }
        set{
            Defaults.set(newValue, forKey: key.rawValue)
        }
    }

    //数组
    func getList(_ key:CacheKey_List)->Array<Any>{
        return Defaults.array(forKey: key.rawValue) ?? Array<Any>()
    }
    func setList(key:CacheKey_List,cache:Array<Any>){
        Defaults.set(cache, forKey: key.rawValue)
    }

    //自定义 数组
    func getList<T:HandyJSON>(_ key:CacheKey_List,model:T)->Array<T>?{
        let jsonCache = Defaults.string(forKey: key.rawValue)
        return JSONDeserializer<T>.deserializeModelArrayFrom(json: jsonCache) as? Array<T>
    }
    func setList<T:HandyJSON>(key:CacheKey_List,cache:Array<T>){
        let jsonCache = cache.toJSONString()
        Defaults.set(jsonCache, forKey: key.rawValue)
    }

}



// MARK: - 封装方法
extension CacheManager {

    var isLogin:Bool{
        let s = Cache[.sessionId]
        if s != nil , s?.count != 0{
            return YES
        }
        return NO
    }

    //退出登录
    func loginOut() -> Void {
        Cache[.sessionId] = nil
    }


    func cleanCache(_ complish:(() -> ())?){
        // remove 一些 图片 缓存

        //回调
        complish?()
    }
}






