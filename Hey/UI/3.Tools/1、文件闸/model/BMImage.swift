//
//  BMImage.swift
//  MySugarHeap
//
//  Created by lzw on 2018/8/28.
//  Copyright © 2018 lizhiwei. All rights reserved.
//

import Foundation

class BMImage: HandyJSON {
    var imgId:String!
    var title:String!
    var imgUrl:String!

    var width:Int!
    var height:Int!

    //是否是第一次展示 默认是nil 显示过一次 设为"", 设""的目的是即使缓存时转json会忽略字段 下次取出来还是nil
    var showed:String! = nil

//    //堆糖模型
//    static func convert(_ from:DTImgListModel) -> BMImage {
//        let mod = BMImage()
//        mod.imgId = String(from.id)
//        mod.imgUrl = from.photo.path
//        mod.width = from.photo.width
//        mod.height = from.photo.height
//        mod.title = from.msg
//        return mod
//    }
//
//    static func convert(_ from:Array<DTImgListModel>) -> Array<BMImage> {
//        var tempArr = Array<BMImage>()
//        for mod in from{
//            tempArr.append(BMImage.convert(mod))
//        }
//        return tempArr
//    }

    required init() {}
}




