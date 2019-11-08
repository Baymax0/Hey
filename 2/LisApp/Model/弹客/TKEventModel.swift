//
//  TKEventModel.swift
//  LisApp
//
//  Created by yimi on 2019/4/10.
//  Copyright © 2019 baymax. All rights reserved.
//

import UIKit
import HandyJSON

class TKEventModel: HandyJSON {
    //"article","section"
    var type:String!
    
    var article:TKArticle!
    var section:TKSection!
    required init() {}
}

class TKArticle: HandyJSON{

    var magazineName:String!// "胖子哇",
    var title:String!   //"尤克里里指弹〈500 Miles〉，百听不厌！弹唱x指弹独奏曲谱",
    var cover:String!   //"http://qiniuimg.qingmang.mobi/image/orion/4d87d7e1f11ebee21faf50427b3fa796_1280_544.jpeg",
    var publishDateDebug:String!
    var appIcon:String!
    
    var webUrl:String!
    
    var isShowed:Bool! = false
    required init() {}
}

class TKSection: HandyJSON{
    var type:String!
//    events[0][magazine] = TKMagazine()
    var events:Array<TKSEvent>!
    required init() {}
}

class TKSEvent: HandyJSON{
    var type:String!
    var magazine:TKMagazine!
    required init() {}
}

class TKMagazine: HandyJSON{
    var id :Int! //": 304045,
    var name :String! //": "白熊音乐",
    var uid :Int!//": 14508325,
    var alias :String! //"白熊音乐",
    var cover :String! //"http://statics01.qingmang.mobi/2f4c64b610c3.jpg",
    var color :String! //"ACACAC",
    var opsUser :String! //"14508325",
    required init() {}
}

