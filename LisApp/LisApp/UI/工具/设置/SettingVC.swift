//
//  SettingVC.swift
//  LisApp
//
//  Created by yimi on 2019/3/6.
//  Copyright © 2019 baymax. All rights reserved.
//

import UIKit

class SettingVC: BaseVC {

    @IBOutlet var contentSC: UIScrollView!
    
    @IBOutlet weak var size1Lab: UILabel!
    @IBOutlet weak var size2Lab: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = KBGGray
        addSlideBack(view)
        
        contentSC.frame = CGRect(x: 0, y: 64, width: KScreenWidth, height: KScreenHeight-64)
        self.view.addSubview(contentSC)
        
        loadInfo()
    }
    
    func loadInfo(){
        //1
        
        
        //2
        let filePath:String = NSHomeDirectory() + "/Documents/Cache.txt"
        let attr = try? FileManager.default.attributesOfItem(atPath: filePath)
        if attr != nil{
            let fileSize = attr![FileAttributeKey.size] as! Int
            self.size2Lab.text = String(format: "%0.2f K",Double(fileSize) / 1024.0)
        }
    }
    
    @IBAction func loadCacheAction(_ sender: Any) {
        let alert = UIAlertController(title: "读取", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let editAction = UIAlertAction(title: "icloud", style: UIAlertAction.Style.default){ (action:UIAlertAction)in
            CacheManager.share.reloadCacheFromCloud()
        }
        let deleteAction = UIAlertAction(title: "本地Cache文件", style: UIAlertAction.Style.default){ (action:UIAlertAction)in
            CacheManager.share.reloadCacheFromDocument()
        }
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel,handler:nil)
        
        alert.addAction(editAction)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        if alert.popoverPresentationController != nil{
            alert.popoverPresentationController!.sourceView = self.bottomPopView;
            alert.popoverPresentationController!.sourceRect = self.view.bounds;
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    

}
