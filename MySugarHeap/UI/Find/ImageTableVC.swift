//
//  ImageTableVC.swift
//  MySugarHeap
//
//  Created by lzw on 2018/8/22.
//  Copyright © 2018 lizhiwei. All rights reserved.
//

import UIKit

class ImageTableVC: BaseTableVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        hideNav = true

        initTableView(rect: CGRect(x: 0, y: 0, width: KScreenWidth, height: view.frame.height))
    }

    override func loadData(_ page: Int) {
//        Network.requestDT(<#T##api: DTApiManager##DTApiManager#>, params: <#T##Dictionary<String, Any>#>, model: <#T##HandyJSON.Protocol#>, finish: <#T##(HandyJSON?) -> ()#>)
    }



}
