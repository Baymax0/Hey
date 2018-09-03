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


