//
//  Sting+Utils.swift
//  wangfuAgent
//
//  Created by lzw on 2018/7/18.
//  Copyright © 2018 zhuanbangTec. All rights reserved.
//

import Foundation

extension Optional where Wrapped == Array<Any>{
    /// if nil return 0
    func bm_count() -> Int {
        if self == nil{
            return 0
        }else{
            return self!.count
        }
    }
}

extension Array{
    
    func bm_object(_ at:Int) -> Element? {
        if at >= self.count{
            return nil
        }else{
            return self[at]
        }
    }
    
    
    
    func getJsonStr() -> String?{
        let data = try? JSONSerialization.data(withJSONObject: self, options: [])
        if data != nil{
            let strJson = String(data: data!, encoding: String.Encoding.utf8)
            return strJson
        }
        return nil
    }

}

