//
//  ZBJsonModel.swift
//  wenzhuan
//
//  Created by 李志伟 on 2020/5/21.
//  Copyright © 2020 baymax. All rights reserved.
//

import Foundation

class BaseModel:  HandyJSON{
    required init() { }
}


// MARK: -  ---------------------- 专帮Json外层格式 ------------------------

/// data = 模型
class ZBJsonModel<T:HandyJSON>: BaseModel {
    var code: Int!
    var msg: String!
    var data: T?
}

/// data = 模型数组
class ZBJsonArrayModel<T:HandyJSON>: BaseModel {
    var code: Int!
    var msg: String!
    var data: Array<T>?
}

/// data = 数字
class ZBJsonInt: BaseModel {
    var code: Int!
    var msg: String!
    var data: Int!
}

/// data = 字符串
class ZBJsonString: BaseModel {
    var code: Int!
    var msg: String!
    var data: String!
}

/// data = 字符串
class ZBJsonDic: BaseModel {
    var code: Int!
    var msg: String!
    var data:Dictionary<String,Any>?
}

/// 其他float等古怪的接口返回类型就懒得写了  直接让后台改类型吧   哈哈

