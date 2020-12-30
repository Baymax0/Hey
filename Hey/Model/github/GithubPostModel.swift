//
//  LeezePostModel.swift
//   Hey
//
//  Created by 李志伟 on 2020/12/29.
//  Copyright © 2020 baymax. All rights reserved.
//

import UIKit

class GithubPostModel: HandyJSON {
    var name : String!       // "2018-01-29-helloworld.markdown",
    var size : Int!          //  3116,
    //哈希值 用于区分是否更新
    var sha : String!       // "bc803518118f3bbfd34eac39033835c694d13229",
    var download_url : String!    // "https://api.github.com/repos/Baymax0/Baymax0.github.io/git/blobs/bc803518118f3bbfd34eac39033835c694d13229",
    
    required init() {}
}


