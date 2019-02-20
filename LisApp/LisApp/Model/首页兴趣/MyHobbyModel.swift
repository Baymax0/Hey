//
//  MyHobbyModel.swift
//  MySugarHeap
//
//  Created by yimi on 2019/2/18.
//  Copyright © 2019 lizhiwei. All rights reserved.
//

import UIKit
import HandyJSON

class MyHobbyModel: HandyJSON {
    
    var name    :String!
    var imgName :String!
    var key     :String!
    
    required init() {}
    convenience init(_ name:String,_ imgName:String,_ key:String) {
        self.init()
        self.name = name
        self.imgName = imgName
        self.key = key
    }
}
