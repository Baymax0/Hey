//
//  BMTag.swift
//  MySugarHeap
//
//  Created by lzw on 2018/8/24.
//  Copyright © 2018 lizhiwei. All rights reserved.
//

import UIKit
import HandyJSON

struct BMTag: HandyJSON {
    var tagId:Int!
    var tagName:String!

    static func == (lhs: BMTag, rhs: BMTag) -> Bool {
        return lhs.tagId == rhs.tagId
    }
}

//全部
let AllItemTag = BMTag(tagId: -1, tagName: "全部")
