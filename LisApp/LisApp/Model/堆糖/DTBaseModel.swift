//
//  DTBaseModel.swift
//  MySugarHeap
//
//  Created by lzw on 2018/8/23.
//  Copyright © 2018 lizhiwei. All rights reserved.
//

import Foundation
import HandyJSON

struct DTPhoto : HandyJSON{
    var width:Int!      //宽
    var height:Int!     //高
    var path:String!    //地址
}

struct DTSender : HandyJSON{
    var id:Int!         //id
    var username:String!//用户名
    var avatar:String!  //头像
}

struct DTAlbum : HandyJSON{
    var id:Int!             //id
    var name:String!        //名称
    var count:Int!          //内容数
    var covers:Array<String>!   //图标
    var like_count:Int!         //like数目
    var favorite_count:Int!     //收藏数目
}

