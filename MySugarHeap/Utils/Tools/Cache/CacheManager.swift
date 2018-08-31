//
//  CacheManager.swift
//  wangfuAgent
//
//  Created by lzw on 2018/7/17.
//  Copyright © 2018 zhuanbangTec. All rights reserved.
//

import UIKit
import HandyJSON
import Kingfisher

let BMCache = CacheManager.share

/// 缓存Key
enum CacheKey_String:String {
    case ImgTags //图片的所有tags
    case ImageFavoriteList //所有收藏的图片
    case FindSearchHistory //搜索历史记录

}

protocol CustomCacheProtocol {
    // ------------  基础方法  -----------------
    //存储字符串对象
    func set(_ Key:CacheKey_String, value: String?)
    func getString(_ Key:CacheKey_String) -> String?
    //存储字符串数组对象
    func set(_ Key:CacheKey_String, value:Array<String>?)
    func getStringList(_ Key:CacheKey_String) -> Array<String>
    //存储自定义对象
    func set(_ Key:CacheKey_String, value: HandyJSON?)
    func getModel<T:HandyJSON>(_ Key:CacheKey_String, type:T.Type?) -> T?
    //自定义对象 数组
    func set<T:HandyJSON>(_ Key:CacheKey_String, value: Array<T>?)
    func getModelList<T:HandyJSON>(_ Key:CacheKey_String, type:T.Type?) -> Array<T>

    // ------------  具体方法  -----------------
    //获得图片所有Tag
    func getImageTags() -> Array<BMTag>
    //获得所有收藏的图片
    func getFavoriteImgList() -> Array<BMFavorite<BMImage>>
    //添加收藏
    func addFavorite(_ model:BMFavorite<DTImgListModel>) ->Void
}

class CacheManager: NSObject {
    static let share = CacheManager()
    private static let ICloudCacheKey = "CacheManager"

    private var allData : Dictionary<String,String>!
    let kfManager = KingfisherManager.shared
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

    func clear() -> Void{
        allData = Dictionary<String,String>()
        self.saveWhenQuit()
    }
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

    // ------------  具体方法  -----------------
    func getImageTags() -> Array<BMTag>{
        return getModelList(.ImgTags, type: BMTag.self)
    }
    func getFavoriteImgList() -> Array<BMFavorite<BMImage>>{
        return getModelList(.ImageFavoriteList, type: BMFavorite<BMImage>.self)
    }
    func addFavorite<T:HandyJSON>(_ model:BMFavorite<T>) ->Void{
        var arr = getModelList(.ImageFavoriteList, type: BMFavorite<T>.self)
        arr.append(model)
        set(.ImageFavoriteList, value: arr)
    }

}


extension CacheManager {
    func setImgCacheOptions() -> Void {
        kfManager.downloader.downloadTimeout = 10
        //最大图片缓存 1G
        //浏览的图片 放在内存中
        kfManager.cache.maxMemoryCost = 1024*1024*1024
        // 设置硬盘最大缓存500G ，默认无限
        // 按钮图片 及 收藏图片 放在硬盘上
        kfManager.cache.maxDiskCacheSize =  1024*1024*1024
        // 设置硬盘最大保存5天 ， 默认1周
        kfManager.cache.maxCachePeriodInSecond = 60 * 60 * 24 * 5
    }

    /// 清理内存
    func clearMemoryCache(){
        kfManager.cache.clearMemoryCache()
    }

    /// 获得缓存大小 主要计算图片  allData字典不计算在内
    /// - Parameter complete: 返回单位 0.0M
    func getCacheSize(complete: @escaping ((_ size: Double) -> Void) ) -> Void{
        kfManager.cache.calculateDiskCacheSize { (size) in
            print(size)
            let sizeM:Double = Double(size)/1024/1024
            complete(sizeM)
        }
    }
}




