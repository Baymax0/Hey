//
//  Sting+Utils.swift
//  wangfuAgent
//
//  Created by lzw on 2018/7/18.
//  Copyright © 2018 zhuanbangTec. All rights reserved.
//

import Foundation


///// if nil or "" return false
//func notEmptyString() -> Bool {
//    if self == nil{
//        return false
//    }else{
//        if self!.count == 0{
//            return false
//        }
//    }
//    return true
//}
//
///// if nil return 0
//func bm_length() -> Int {
//    if self == nil{
//        return 0
//    }else{
//        return self!.count
//    }
//}

extension Optional where Wrapped : Collection{
    /// if nil or "" or [] return 0
    func  bm_count() -> Int{
        if self == nil{
            return 0
        }else{
            return self!.count
        }
    }
    
    /// if nil or "" or [] return false
    func  notEmpty() -> Bool{
        if self == nil{
            return false
        }else{
            return self!.count != 0
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

