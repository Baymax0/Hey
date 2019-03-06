//
//  MeVC.swift
//  LisApp
//
//  Created by yimi on 2019/2/18.
//  Copyright © 2019 baymax. All rights reserved.
//

import UIKit

class MeVC: BaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideNav = true
    }
    
    @IBAction func searchAction(_ sender: Any) {
        
    }
    
    
    @IBAction func exploreAction(_ sender: UIButton) {
        let keys = ["水彩","插画"]
        let vc = DTResultVC.fromStoryboard() as! DTResultVC
        vc.title = keys[sender.tag]
        vc.api = DTApiManager.imageSearch
        vc.param["limit"] = 0
        vc.param["kw"] = keys[sender.tag]
        vc.param["buyable"] = 0
        vc.param["include_fields"] = "sender,favroite_count,album,reply_count,like_count"
        present(vc, animated: true, completion: nil)
    }
    // MARK: -  ---------------------- 工具 ------------------------
    // 扫码
    @IBAction func codeScanAction(_ sender: Any) {
        let vc = ScanCodeVC.fromStoryboard() as! ScanCodeVC
        present(vc, animated: true, completion: nil)
    }
    

}
