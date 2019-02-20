//
//  ImageVC.swift
//  LisApp
//
//  Created by yimi on 2019/2/19.
//  Copyright © 2019 baymax. All rights reserved.
//

import UIKit

class ImageVC: BaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        //侧滑返回
        addSlideBack(view)
    }
    
    @IBAction func shuicaiAction(_ sender: Any) {
        let vc = HoppyImageVC.fromStoryboard() as! HoppyImageVC
        vc.keyWords = "水彩"
        present(vc, animated: true, completion: nil)
    }

    @IBAction func libraryAction(_ sender: Any) {
        let vc = MySiMiVC.fromStoryboard() as! MySiMiVC
        present(vc, animated: true, completion: nil)
    }
    
}
