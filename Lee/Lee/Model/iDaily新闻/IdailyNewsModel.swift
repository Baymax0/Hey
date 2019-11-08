//
//  IdailyNewsModel.swift
//  Lee
//
//  Created by yimi on 2019/11/5.
//  Copyright © 2019 baymax. All rights reserved.
//

import UIKit
import HandyJSON

class IdailyNewsModel: HandyJSON {
    
    var guid : Int!     // 118294,
    var type : Int!     // 1,
    var cat : String!    // "6",
    var title : String!  // November 4, 2019",
    var cover_thumb : String!        // http://pic.yupoo.com/fotomag/344cea41/fed27edf.jpg",
    var cover_sq : String!          // http://pic.yupoo.com/fotomag/a046ebcb/1f510a7f.jpg",
    var cover_sq_hd : String!       // http://pic.yupoo.com/fotomag/a046ebcb/1f510a7f.jpg",
    var cover_landscape : String!   // http://pic.yupoo.com/fotomag/4f8cde2b/76f6f911.jpg",
    var cover_landscape_hd : String! // http://pic.yupoo.com/fotomag/668d4b02/4d14ba1e.jpg",
    
    var smallImg:String!{
        get{
            if cover_thumb != nil{ return cover_thumb }
            if cover_sq != nil{ return cover_thumb }
            if cover_landscape != nil{ return cover_thumb }
            if cover_sq_hd != nil{ return cover_sq_hd }
            return cover_landscape_hd
        }
    }
    
    var bigImg:String!{
        get{
            if cover_sq_hd != nil{ return cover_sq_hd }
            if cover_landscape_hd != nil{ return cover_landscape_hd }
            if cover_sq != nil{ return cover_sq }
            if cover_landscape != nil{ return cover_landscape }
            return cover_thumb
        }
    }
    
    
    var pubdate : String!   // November 04, 2019",
    var archive_timestamp : Int!    // 1572796800,
    var pubdate_timestamp : Int!    // 1572868740,
    var lastupdate_timestamp : Int! // 1572874622,
//    {
//        "caption_subtitle": "首里城重建募款开始"
//    }
    var ui_sets : Dictionary<String,String>!
    var link_share : String! // https://m.idai.ly/se/c84PfT",
    var link_wechat : String! // https://m.idai.ly/se/c84PfT",
    var title_wechat_tml : String! // 首里城重建募款开始 - November 4, 2019 | iDaily 每日全球最佳新闻图片",
    var location : String! // 日本 · 那霸市",
    var summary : String! // ",
    var content : String! // 俯瞰冲绳首里那霸市。冲绳公园管理基金会统计，首里城收藏的1496...

//    [{
//    "id": "spotnews",
//    "name": "SPOT NEWS · 全球焦点",
//    "focus": 1}]
    var tags :Array<Dictionary<String,Any>>!

    required init() {}
    
}
