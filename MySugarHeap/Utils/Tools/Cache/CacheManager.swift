//
//  CacheManager.swift
//  wangfuAgent
//
//  Created by lzw on 2018/7/17.
//  Copyright © 2018 zhuanbangTec. All rights reserved.
//

import UIKit
import HandyJSON

let BMCache = CacheManager.share

/// 缓存Key 通过 Cache[.account] 设置 获取
enum CacheKey_String:String {
    case ImgTags
    case FindSearchHistory
}

class CacheManager: NSObject {
    static let share = CacheManager()
    private static let ICloudCacheKey = "CacheManager"

    private var allData : Dictionary<String,String>!

    //初始化
    override init() {
        super.init()
        //加载 本地数据
        if let dic = UserDefaults.standard.object(forKey: CacheManager.ICloudCacheKey){
            allData = dic as! Dictionary<String,String>
            return
        }
        //本地加载失败 加载icloud
        if let dic = NSUbiquitousKeyValueStore.default.object(forKey: CacheManager.ICloudCacheKey){
            allData = dic as! Dictionary<String,String>
            return
        }
        allData = Dictionary<String,String>()
        self.saveWhenQuit()
    }

    //存档
    func saveWhenQuit() -> Void {
        //保存本地
        UserDefaults.standard.set(allData, forKey: CacheManager.ICloudCacheKey)
        UserDefaults.standard.synchronize()
        print("保存数据至 本地 UserDefaults")

        //保存至icloud
        NSUbiquitousKeyValueStore.default.set(allData, forKey: CacheManager.ICloudCacheKey)
        NSUbiquitousKeyValueStore.default.synchronize()
        print("保存数据至 icloud")
    }
}

protocol CustomCacheProtocol {
    func set(_ Key:CacheKey_String, value: String?)
    func getString(_ Key:CacheKey_String) -> String?

    func set(_ Key:CacheKey_String, value:Array<String>?)
    func getStringList(_ Key:CacheKey_String) -> Array<String>

    func set(_ Key:CacheKey_String, value: HandyJSON?)
    func getModel<T:HandyJSON>(_ Key:CacheKey_String, type:T.Type?) -> T?

    func set<T:HandyJSON>(_ Key:CacheKey_String, value: Array<T>?)
    func getModelList<T:HandyJSON>(_ Key:CacheKey_String, type:T.Type?) -> Array<T>

    func getImageTags() -> Array<BMTag>
}

private let separator = ";"

extension CacheManager : CustomCacheProtocol{
    //存储字符串对象
    func set(_ Key:CacheKey_String, value: String?){
        allData[Key.rawValue] = value
    }
    func getString(_ Key:CacheKey_String) -> String?{
        return allData[Key.rawValue]
    }
    
    //存储字符串数组对象
    func set(_ Key:CacheKey_String, value:Array<String>?){
        var res:String?
        if value != nil && value!.count>0{
            res = value?.joined(separator: separator)
        }
        set(Key, value: res)
    }
    func getStringList(_ Key:CacheKey_String) -> Array<String>{
        let str = getString(Key) ?? ""
        if str.count == 0 {
            return Array<String>()
        }else{
            return str.components(separatedBy: separator)
        }
    }

    //存储自定义对象
    func set(_ Key:CacheKey_String, value: HandyJSON?){
        let jsonStr = value?.toJSONString(prettyPrint: false)
        set(Key, value: jsonStr)
    }
    func getModel<T:HandyJSON>(_ Key:CacheKey_String, type:T.Type?) -> T?{
        return T.deserialize(from: getString(Key))
    }

    //自定义对象 数组
    func set<T:HandyJSON>(_ Key:CacheKey_String, value: Array<T>?){
        let jsonStr = value?.toJSONString(prettyPrint: false)
        set(Key, value: jsonStr)
    }
    func getModelList<T:HandyJSON>(_ Key:CacheKey_String, type:T.Type?) -> Array<T>{
        if let data = [T].deserialize(from: getString(Key)){
            return data as! Array<T>
        }else{
            return Array<T>()
        }
    }



    //封装方法
    func getImageTags() -> Array<BMTag>{
        return getModelList(.ImgTags, type: BMTag.self)
    }



}








