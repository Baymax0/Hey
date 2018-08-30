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
    var id:String!      //url
    var target:String!      //url
    var name:String!        //名称
    var icon_url:String!    //图标
    var path:String!    //图标

    func idFromTarget() -> String?{
        let r = self.target.components(separatedBy: "=").last
        return r
    }
}


struct DTGroupsDetailModel : HandyJSON{
    var id:String!      //url
    var name:String!        //名称
    var sub_cates:Array<DTGroupsModel>!
}



