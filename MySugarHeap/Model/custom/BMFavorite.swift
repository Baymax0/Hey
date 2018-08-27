//
//  BMFavorite.swift
//  MySugarHeap
//
//  Created by lzw on 2018/8/27.
//  Copyright © 2018 lizhiwei. All rights reserved.
//

import UIKit
import HandyJSON

class BMFavorite<E:HandyJSON>: HandyJSON {
    //模型
    var model:E!
    //如果添加标签 tags[BMTag.Id] = "" 随便赋值 不为空即可。 删除tag只需要将tags[BMTag.Id] = nil
    var tags:Dictionary<String,String> = [:]

    required init() {}
}
