//
//  ThreeVC.swift
//  Lee
//
//  Created by yimi on 2019/11/5.
//  Copyright © 2019 baymax. All rights reserved.
//

import UIKit

class ThreeVC: BaseVC {

    override var preferredStatusBarStyle: UIStatusBarStyle{
        get{ return .default }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .KBGGray
        self.hideNav = true

        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
