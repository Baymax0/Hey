//
//  Sting+Utils.swift
//  wangfuAgent
//
//  Created by lzw on 2018/7/18.
//  Copyright © 2018 zhuanbangTec. All rights reserved.
//

import Foundation


extension Array{
    
    func bm_object(_ at:Int) -> Element? {
        if at >= self.count{
            return nil
        }else{
            return self[at]
        }
    }
    
}

