//
//  FindVC.swift
//  MySugarHeap
//
//  Created by lzw on 2018/8/22.
//  Copyright © 2018 lizhiwei. All rights reserved.
//

import UIKit

class FindVC: BaseVC {



    override func viewDidLoad() {
        super.viewDidLoad()
        hideNav = true
    }

    @IBAction func searchAction(_ sender: Any) {
        self.navigationController?.pushViewController(SearchVC.fromStoryboard(), animated: false)
    }


}





