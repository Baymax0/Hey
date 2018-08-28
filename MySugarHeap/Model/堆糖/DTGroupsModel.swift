//
//  DTGroupsModel.swift
//  MySugarHeap
//
//  Created by lzw on 2018/8/28.
//  Copyright © 2018 lizhiwei. All rights reserved.
//

import Foundation
import HandyJSON

struct DTGroupsListModel : HandyJSON{
    var group_id:String! //总结果
    var content_type:String! //下拉刷新用
    var group_items:Array<DTGroupsModel>!
}

struct DTGroupsModel : HandyJSON{
    var target:String!      //url
    var icon_url:String!    //图标
    var name:String!        //名称
}

