//
//  MeVC.swift
//  MySugarHeap
//
//  Created by lzw on 2018/8/22.
//  Copyright © 2018 lizhiwei. All rights reserved.
//

import UIKit

class MeVC: BaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        hideNav = true

    }

    @IBAction func faviriteImgAction(_ sender: UIButton) {
        navigationController?.pushViewController(FavoriteImgVC.fromStoryboard(), animated: YES)
    }

}
