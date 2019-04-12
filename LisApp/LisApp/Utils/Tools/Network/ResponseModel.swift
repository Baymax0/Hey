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


class RespFormate:HandyJSON{
    var code:Int!
    var msg:String!
    required init() {}
    
    static func set(code:Int,msg:String) -> RespFormate {
        let resp = RespFormate()
        resp.code = code
        resp.msg = msg
        return resp
    }
}

///
class RespTK: RespFormate {
    var nextUrl:String!
    var events:Array<TKEventModel>!
    required init() {}
}



class RespDic: RespFormate {
    var data:Dictionary<String,Any>?
    required init() {}
}

/// 数据封装为对象
class RespObject<T:HandyJSON>: RespFormate {
    var data:T?
    required init() {}
}
/// 数据封装为对象列表
class RespObjectArray<T:HandyJSON>: RespFormate {
    var data:Array<T>?
    required init() {}
}

