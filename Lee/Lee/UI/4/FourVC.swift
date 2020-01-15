//
//  FourVC.swift
//  Lee
//
//  Created by yimi on 2019/11/5.
//  Copyright © 2019 baymax. All rights reserved.
//

import UIKit

class FourVC: BaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func fileManagAction(_ sender: Any) {
        let vc = MySiMiVC.fromStoryboard()
        self.present(vc, animated: true, completion: nil)
        
    }
    
    

}
