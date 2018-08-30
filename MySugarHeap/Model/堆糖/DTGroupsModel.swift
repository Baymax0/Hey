//
//  DTGroupsModel.swift
//  MySugarHeap
//
//  Created by lzw on 2018/8/28.
//  Copyright © 2018 lizhiwei. All rights reserved.
//

import Foundation
import HandyJSON

//分组列表
struct DTGroupsListModel : HandyJSON{
    var group_id:String! //总结果
    var content_type:String! //下拉刷新用
    var group_items:Array<DTGroupsModel>!
}

//分组模型
struct DTGroupsModel : HandyJSON{
    var id:String!      //url
    var target:String!      //url
    var name:String!        //名称
    var icon_url:String!    //图标
    var path:String!    //图标

    var filter_id:String!   //筛选字段
    var filter_url:String!  //筛选接口

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

//主题
struct DTThemeModel : HandyJSON{
    var name:String!        //名称
    var filter_id:String!   //筛选字段
    var filter_url:String!         //筛选接口

    mutating func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.filter_id <-- "data_src.filter_id"
        mapper <<<
            self.filter_url <-- "data_src.uri"
    }
}




