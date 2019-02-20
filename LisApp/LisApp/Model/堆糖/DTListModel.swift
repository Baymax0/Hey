//
//  DTListModel.swift
//  MySugarHeap
//
//  Created by lzw on 2018/8/23.
//  Copyright © 2018 lizhiwei. All rights reserved.
//

import Foundation
import HandyJSON

struct DTList<T> : HandyJSON{
    var total:Int! //总结果
    var next_start:Int! //下拉刷新用
    var object_list:Array<T>!
    var more:Int! //是否还有数据
    var limit:Int! //单页大小
}

struct DTImgListModel : HandyJSON{
    var id:Int!         //id
    var msg:String!     //标题
    var photo:DTPhoto!  //图片
    var sender:DTSender! //上传者
}


