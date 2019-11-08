//
//  ExploreVC.swift
//  LisApp
//
//  Created by yimi on 2019/7/25.
//  Copyright © 2019 baymax. All rights reserved.
//

import UIKit
import SafariServices

class ExploreVC: BaseVC,SFSafariViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        let safari = SFSafariViewController(url: URL(string: "https://www.baidu.com")!)
        safari.delegate = self
        self.present(safari, animated: false, completion: nil)
    }

}
