//
//  RealmManager.swift
//  Lee
//
//  Created by 李志伟 on 2020/10/15.
//  Copyright © 2020 baymax. All rights reserved.
//

import UIKit
import Realm
import RealmSwift
import HandyJSON

class RealmManager {

    static let dbPath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .allDomainsMask, true)[0] as NSString).appendingPathComponent("/cache/db.realm")
    /// 配置数据库
    static func configRealm() {
        /// 如果要存储的数据模型属性发生变化,需要配置当前版本号比之前大
        let dbVersion : UInt64 = 6
        let config = Realm.Configuration(fileURL: URL.init(string: dbPath), inMemoryIdentifier: nil, syncConfiguration: nil, encryptionKey: nil, readOnly: false, schemaVersion: dbVersion, migrationBlock: { (migration, oldSchemaVersion) in
        }, deleteRealmIfMigrationNeeded: false, shouldCompactOnLaunch: nil, objectTypes: nil)
        
        print("----")
        print(dbPath)
        print("----")
        
        Realm.Configuration.defaultConfiguration = config
        Realm.asyncOpen { (realm, error) in
            if let _ = realm {
                print("Realm 服务器配置成功!")
                
            }else if let error = error {
                print("Realm 数据库配置失败：\(error.localizedDescription)")
            }
        }
    }
    
    static var db:Realm={
        /// 传入路径会自动创建数据库
        let defaultRealm = try! Realm(fileURL: URL.init(string: dbPath)!)
        return defaultRealm
    }()
}

extension RealmManager{
    static var ONE : Realm_One_Api = Realm_One_Api()
}


class Realm_One_Api: RealmManager {
    public func save(_ model:One_Today_Info_Model!) {
        if model == nil { return }
        let saveModel = Realm_feedModel()
        saveModel.id = model.date[0..<10]
        saveModel.data = model.toJSONString()
        try! RealmManager.db.write{
            RealmManager.db.add(saveModel, update: .all)
        }
    }
    
    public func getfeedDetail(_ id:String) -> One_Today_Info_Model?{
        let model = RealmManager.db.object(ofType: Realm_feedModel.self, forPrimaryKey: id)
        if model != nil && model?.id != nil{
            let info = JSONDeserializer<One_Today_Info_Model>.deserializeFrom(json: model!.data)
            return info
        }
        return nil
    }
    
//    public func save
    
    public func save(_ model:One_Html_Model!){
        if model == nil || model.html_content == nil{ return }
        let saveModel = Realm_DetailModel()
        saveModel.id = model.primaryKey
        saveModel.data = model.html_content.data(using: .utf8)
        try! RealmManager.db.write{
            RealmManager.db.add(saveModel, update: .all)
        }
    }
    public func getDetailHtml(_ catogary:String, _ id:String)->One_Html_Model!{
        let result = One_Html_Model()
        result.category = catogary
        result.id = id
        
        let cacheModel = RealmManager.db.object(ofType: Realm_DetailModel.self, forPrimaryKey: result.primaryKey)
        if cacheModel != nil && cacheModel?.data != nil{
            if let data = cacheModel!.data{
                result.html_content = String(data: data, encoding: .utf8)
            }
        }
        return result
    }
    
}

