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

    }

    @IBAction func faviriteImgAction(_ sender: UIButton) {
        present(FavoriteImgVC.fromStoryboard(), animated: true, completion: nil)

    }

    @IBAction func clearAction(_ sender: Any) {
        BMCache.clear()
    }


}
