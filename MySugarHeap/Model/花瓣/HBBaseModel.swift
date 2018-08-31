//
//  HBBaseModel.swift
//  MySugarHeap
//
//  Created by lzw on 2018/8/30.
//  Copyright © 2018 lizhiwei. All rights reserved.
//

import Foundation
import HandyJSON

//我的兴趣
struct HBMyHoppList : HandyJSON{
    var explores : Array<HBHoppyModel>!
}


//兴趣模型
struct HBHoppyModel : HandyJSON{
    var keyword_id:Int!         //id
    var name:String!        //标题
    var urlname:String!     //urlkey
    var imgKey:String!      //图片key
    var pins:Array<HBImgModel>!     //图片列表
    var top_three:Array<HBImgModel>! //三张预览图

    func imgUrl() -> String!{
        var str = self.imgKey!
        str = "http://img.hb.aicdn.com/\(str)"
        return str
    }

    mutating func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.imgKey <-- "cover.key"
    }
}

//图片模型
struct HBImgModel : HandyJSON{
    var pin_id:Int!         //id
    var imgKey:String!     //标题
    var name:String!     //标题
    var width:Int!      //宽
    var height:Int!     //高

    func imgUrl() -> String!{
        return "http://img.hb.aicdn.com/\(self.imgKey!)"
    }


    mutating func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.name <-- "raw_text"
        mapper <<<
            self.imgKey <-- "file.key"
        mapper <<<
            self.width <-- "file.width"
        mapper <<<
            self.height <-- "file.height"
    }
}

