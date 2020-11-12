//
//  Api.swift
//  Lee
//
//  Created by yimi on 2019/11/5.
//  Copyright © 2019 baymax. All rights reserved.
//

import Foundation
import Alamofire

public class NewsApi<ValueType> : BMApiTemplete<ValueType> {
    override var host: String{"https://idaily-cdn.idailycdn.com"}
}

public class WeatherApi<ValueType> : BMApiTemplete<ValueType> {
    override var host: String{"https://idaily-cdn.idailycdn.com/101030100"}
}

//接口
extension BMApiSet {
    static let news = NewsApi<Array<IdailyNewsModel>?>("/api/list/v3/iphone/zh-hans")
    static let city = WeatherApi<String?>("")
}
