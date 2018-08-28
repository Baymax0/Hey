//
//  BMImage.swift
//  MySugarHeap
//
//  Created by lzw on 2018/8/28.
//  Copyright © 2018 lizhiwei. All rights reserved.
//

import Foundation
import HandyJSON

struct BMImage: HandyJSON {
    var imgId:String!
    var title:String!
    var imgUrl:String!

    var width:Int!
    var height:Int!


    static func convert(_ from:DTImgListModel) -> BMImage {
        var mod = BMImage()
        mod.imgId = String(from.id)
        mod.imgUrl = from.photo.path
        mod.width = from.photo.width
        mod.height = from.photo.height
        mod.title = from.msg
        return mod
    }

    static func convert(_ from:Array<DTImgListModel>) -> Array<BMImage> {
        var tempArr = Array<BMImage>()
        for mod in from{
            tempArr.append(BMImage.convert(mod))
        }
        return tempArr
    }
}


