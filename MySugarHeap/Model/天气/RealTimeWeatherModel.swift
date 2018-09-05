//
//  RealTimeWeatherModel.swift
//  MySugarHeap
//
//  Created by lzw on 2018/9/3.
//  Copyright © 2018 lizhiwei. All rights reserved.
//

import Foundation
import HandyJSON


struct WeatherBase1: HandyJSON{
    var success:String!
    var result:RealTimeWeatherModel!
}

struct RealTimeWeatherModel: HandyJSON {
    var weaid:String!   //id
    var days:String!    //2018-09-03
    var week:String!    //星期一
    var citynm:String!  //温州
    var temp_high:String!   //最高气温 “33”
    var temp_low:String!    //最高气温 “23”
    var temp_curr:String!   //当前气温 “23”
    var weather_curr:String!//天气描述 “多云”
    var aqi:String!     //pm2.5  "53"
}

class WeatherBase2: HandyJSON{
    var city:String!
    var count:Int!
    var date:String!

    var yesterday:FutureWeatherModel!

    var forecast:Array<FutureWeatherModel>!

    var result:Array<FutureWeatherModel>{
        var temp = forecast ?? Array<FutureWeatherModel>()
        if yesterday != nil{
            temp.insert(yesterday, at: 0)
        }
        return temp
    }

    func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.yesterday <-- "data.yesterday"
        mapper <<<
            self.forecast <-- "data.forecast"
    }

    required init() {    }
}

struct FutureWeatherModel: HandyJSON {
    var date:String!    //日期 03日星期一
    var sunrise:String!     //05:42
    var sunset:String!      //18:45
    var high:String!    //"高温 32.0℃",
    var low:String!     //"低温 19.0℃",
    var aqi:Int!        //pm2.5  "53"
    var type:String!    //"晴",
    var notice:String!  //"愿你拥有比阳光明媚的心情"
}

//本地保存的时候 解析为WeatherBase3 防止通过mapping读不到数据
class WeatherBase3: WeatherBase2{
    override func mapping(mapper: HelpingMapper) {
    }
    required init() {    }
}




