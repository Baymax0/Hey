//
//  RealmSaveModels.swift
//  Lee
//
//  Created by 李志伟 on 2020/10/15.
//  Copyright © 2020 baymax. All rights reserved.
//

import UIKit
import RealmSwift

class Realm_feedModel: Object {
    
    // 用date做主键
    @objc dynamic var id:String!
    
    @objc dynamic var data:String!
    
    override static func primaryKey() -> String? {
        return "id"
    }
}


class Realm_DetailModel: Object {
    
    @objc dynamic var id:String!
    
    @objc dynamic var data:Data!
    
    override static func primaryKey() -> String? {
        return "id"
    }
}


class GitHub_CachePost: Object {
    //从接口中获取的
    @objc dynamic var name:String!//文件名
    @objc dynamic var sha:String!//哈希值
    
    @objc dynamic var title:String! //“a,b,c”
    @objc dynamic var desc:String!  //“a,b,c”
    @objc dynamic var time:Date!    //“a,b,c”
    @objc dynamic var tags:String!  //“a,b,c”
    
    @objc dynamic var body:String!//内容

    override static func primaryKey() -> String? {
        return "name"
    }
}






