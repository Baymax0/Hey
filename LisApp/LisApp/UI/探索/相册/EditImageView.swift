//
//  EditImageView.swift
//  LisApp
//
//  Created by yimi on 2019/2/22.
//  Copyright © 2019 baymax. All rights reserved.
//

import UIKit
import Hero

class EditImageView: BaseVC {
    
    var directPath:String = ""
    
    var subFiles = Array<String>()
    
    var subFilesUrl = Array<String>()

    var imageIndex:Int = 0

    @IBOutlet weak var titleLab: UILabel!
    
    @IBOutlet weak var tagLab: UILabel!
    @IBOutlet weak var tagLabW: NSLayoutConstraint!
    
    var tagArr:Set<String>!
    var tagDic:Dictionary<String,String>!

    @IBOutlet weak var addTagView: UIView!
    @IBOutlet weak var tagBtnBGView: UIView!
    @IBOutlet weak var tagInputTF: UITextField!
    
    var name:String{
        return subFiles[imageIndex]
    }
    
    var tempImgView: UIImageView = {
        let v = UIImageView(frame: CGRect(x: 0, y: 64, width: KScreenWidth, height: KScreenHeight-64-80))
        v.contentMode = .scaleAspectFit
        v.backgroundColor = .black
        return v
    }()
    
    var cycleScrollView:WRCycleScrollView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideNav = true
        //侧滑返回
        addSlideBack(view)
        self.view.addSubview(tempImgView)
        self.view.sendSubviewToBack(tempImgView)
        
        subFilesUrl = subFiles.map({ (name) -> String in
            return String(format: "%@/%@", directPath, name)
        })
        
        tagDic = BMCache.getDic(.imageTagsDic) ?? Dictionary<String,String>()
        loadTag()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let frame = tempImgView.frame
        cycleScrollView = WRCycleScrollView(frame:frame, type:.SERVER, imgs:subFilesUrl)
        cycleScrollView!.delegate = self
        cycleScrollView!.showPageControl = false
        view.addSubview(cycleScrollView!)
    }
    
    func loadTag(){
        let tag = tagDic[name] ?? "无"
        tagLab.text = tag
        tagLabW.constant = CGFloat(tag.count) * 16 + 16
        addTagView.isHidden = true
    }
    
    
    @IBAction func changeTagAction(_ sender: Any) {
        self.view.addSubview(maskView)
        self.view.bringSubviewToFront(addTagView)
        addTagView.isHidden = false
    }
    
    override func hideMaskView() {
        self.maskView.removeFromSuperview()
        addTagView.isHidden = true
    }
    
    @IBAction func commitTagAction(_ sender: Any) {
        if tagInputTF.text == nil{
            return
        }
        if tagInputTF.text!.count == 0{
            return
        }
        tagDic[name] = tagInputTF.text
        
        hideMaskView()
        loadTag()
    }
    
    @IBAction func frontAction(_ sender: Any) {
        
    }
    
    @IBAction func nextAction(_ sender: Any) {
        
    }

}


extension EditImageView: WRCycleScrollViewDelegate{
    /// 点击图片回调
    func cycleScrollViewDidSelect(at index:Int, cycleScrollView:WRCycleScrollView){
        print("点击了第\(index+1)个图片")
    }
    /// 图片滚动回调
    func cycleScrollViewDidScroll(to index:Int, cycleScrollView:WRCycleScrollView){
        print("滚动到了第\(index+1)个图片")
    }
}
