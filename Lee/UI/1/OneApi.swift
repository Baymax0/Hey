//
//  OneApi.swift
//  Lee
//
//  Created by 李志伟 on 2020/10/12.
//  Copyright © 2020 baymax. All rights reserved.
//

import UIKit
import Alamofire
import HandyJSON


/// data = 模型
class OneApiModel<T:HandyJSON>: BaseModel {
    var res: Int!
    var data: T?
}

//服务器地址
public class OneAppApi<ValueType> : BMApiTemplete<ValueType> {
    override var host: String{ return "http://v3.wufazhuce.com:8000" }
    
}

extension BMNetwork{
    
    // 返回日期列表（仅带图）
    func oneApp_Main_List(month:String) -> BMRequester_ModelList<One_Feed_Model>{
        let apiStr = "/api/feeds/list/" + month
        let key = OneAppApi<Array<One_Feed_Model>?>(apiStr)
        return BMRequester_ModelList(key)
    }
    // 返回每日详情
    func oneApp_Main_Info(day:String) -> BMRequester_Model<One_Today_Info_Model>{
        let apiStr = "/api/channel/one/" + day + "/%E6%B8%A9%E5%B7%9E%E5%B8%82"
        let key = OneAppApi<One_Today_Info_Model?>(apiStr)
        return BMRequester_Model(key)
    }
    // 返回文章详情
    func oneApp_Content_Detail(key:String) -> BMRequester_Model<One_Html_Model>{
        let apiStr = "/api/" + key
        let key = OneAppApi<One_Html_Model?>(apiStr)
        return BMRequester_Model(key)
    }
    
}


/// 模型
class One_Today_Info_Model: HandyJSON {
    var id:String!
    
//    var weather: ***!
    
    var date:String!
    
    var content_list:Array<One_Today_Content_Model>!
    
    required init() {}

}


class One_Today_Content_Model: HandyJSON {
    
    var id:String!
    //0-摄影，1-阅读，2-连载, 3-问答，4-音乐，6-影视，8-电台
    var category:String!
    
    var categoryName:String?{
        let names = ["1":"阅读","2":"连载","3":"问答","4":"音乐","5":"影视"]//,"8":"电台"
        return names[self.category]
    }
    
    var item_id:String!     // 用于查看详情，详情的主键 * * *
    var title:String!       // 除摄影外，其他为标题
    var forward:String!     // 摄影为文案，其他为子标题
    var img_url:String!     // 内容对应的图片
    var orientation:String! // 1=竖 ，0=横
    
    var pic_author:String!      // 摄影的作者
    var words_author:String!    // 文案的作者
    var video_author:String!    // 影视来源
    
    var music_name:String!      // 音乐名称
    var audio_author:String!    // 音乐作者
    var audio_album:String!     // 专辑名称作者

    var content_url:String!
    
    required init() {}
    func mapping(mapper: HelpingMapper) {
        // specify 'friend.name' path field in json map to 'friendName' property
        mapper <<<
            self.pic_author <-- "pic_info"
        mapper <<<
            self.words_author <-- "words_info"
        mapper <<<
            self.content_url <-- "share_url"
        mapper <<<
            self.video_author <-- "subtitle"
    }
}

class One_Html_Model: HandyJSON {
    
    var id:String!
    
    var category:String!
    
    //0-摄影，1-阅读，2-连载, 3-问答，4-音乐，6-影视，8-电台
    //    “essay/htmlcontent/3300”,
    //    "music/htmlcontent/3212",
    //    "movie/htmlcontent/3212",
    //    "radio/htmlcontent/3333",
    var primaryKey:String!{
        let arr = ["1":"essay","2":"serialcontent","3":"question","4":"music","5":"movie"]//,"8":"radio"
        var name = arr[self.category]
        name = name! + "/htmlcontent/" + self.id
        return name
    }

    var web_url:String!
    
    var html_content:String!
    
    required init() {}

}



class One_Feed_Model: HandyJSON{
    var id:String!
    var date:String!
    var cover:String!
    required init() {}
}



