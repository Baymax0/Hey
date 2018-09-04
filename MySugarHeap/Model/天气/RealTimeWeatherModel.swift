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

struct WeatherBase2: HandyJSON{
    var data:String!
    var result:Array<RealTimeWeatherModel>!
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





