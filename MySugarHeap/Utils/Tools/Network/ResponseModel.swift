//
//  ResponseModel.swift
//  ReactiveX
//
//  Created by lzw on 2018/8/10.
//  Copyright © 2018 lizhiwei. All rights reserved.
//

import Foundation
import HandyJSON

/// 数据封装为对象
class DTRespObject<T:HandyJSON>: HandyJSON {
    var status:Int!
    var message:String!
    var data:T?
    required init() {}
}

/// 数据封装为对象
class DTRespArrayObject<T:HandyJSON>: HandyJSON {
    var status:Int!
    var message:String!
    var data:Array<T>?
    required init() {}
}
