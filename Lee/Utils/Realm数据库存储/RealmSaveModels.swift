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







