//
//  ReviewVC.swift
//  LisApp
//
//  Created by yimi on 2019/2/22.
//  Copyright © 2019 baymax. All rights reserved.
//

import UIKit
import Hero
import Kingfisher

class ReviewVC: BaseVC {
    
    var directPath:String = ""
    
    var subFiles = Array<String>()
    
    var subFilesUrl = Array<String>()

    var imageIndex:Int = 0

    @IBOutlet weak var titleLab: UILabel!
    
    @IBOutlet weak var tagLab: UILabel!
    @IBOutlet weak var tagLabW: NSLayoutConstraint!
    
    var tagDic:Dictionary<String,String>!

    @IBOutlet weak var addTagView: UIView!
    @IBOutlet weak var addTagViewH: NSLayoutConstraint!
    @IBOutlet weak var tagBtnBGView: UIView!
    @IBOutlet weak var tagInputTF: UITextField!
    
    
    var name:String{
        if imageIndex >= subFiles.count{
            return ""
        }
        return subFiles[imageIndex]
    }
    
    var sc:BMScrollView!
    
    //编辑用
    var tempImgView: UIImageView = {
        let v = UIImageView(frame: CGRect(x: 0, y: 64, width: KScreenWidth, height: KScreenHeight-64-80))
        v.contentMode = .scaleAspectFit
        v.backgroundColor = .black
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideNav = true
        self.view.backgroundColor = KBlack_0

        subFilesUrl = subFiles.map({ (name) -> String in
            return String(format: "%@/%@", directPath, name)
        })
        tagDic = BMCache.getDic(.imageTagsDic) ?? Dictionary<String,String>()
        loadTag()
        
        sc = BMScrollView(frame: tempImgView.frame, currentIndex: imageIndex, dataArr: subFilesUrl ,delegate:self)
        self.view.sendSubviewToBack(sc)
        view.addSubview(sc)
        
        self.view.addSubview(tempImgView)
        self.view.bringSubviewToFront(tempImgView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.5) {
            self.sc.alpha = 1
            self.tempImgView.alpha = 0
        }
        if appearTimes != 1{
            self.sc.loadImage(self.sc.centerImageView, index: imageIndex)
        }
    }
    
    func loadTag(){
        let key = self.getSaveKey(withName: name)
        let tag = tagDic[key] ?? "无"
        tagLab.text = tag
        tagLabW.constant = CGFloat(tag.count) * 16 + 20
        addTagView.isHidden = true
    }
    
    @IBAction func backAction(_ sender: Any) {
         dismiss(animated: true, completion: nil)
    }
    
    @IBAction func changeTagAction(_ sender: Any) {
        self.view.addSubview(maskView)
        self.view.bringSubviewToFront(addTagView)
        addTagView.isHidden = false
        reloadTagBtn()
    }
    
    func reloadTagBtn(){
        for v in tagBtnBGView.subviews{
            v.removeFromSuperview()
        }
        let blank:CGFloat   = 8
        let h   :CGFloat    = 35
        var row :CGFloat    = 0
        var x   :CGFloat    = 0
        let fontSize:CGFloat = 14
        
        var set = Set<String>()
        var location = directPath.components(separatedBy: "Documents").last!
        location = location + "/"
        for (key,str) in tagDic{
            if key.contains(location){
                set.insert(str)
            }
        }
        let temp = set.sorted()
        
        for str in temp {
            var w = str.stringWidth(fontSize)+30
            w = w < (KScreenWidth-blank*2) ? w : KScreenWidth-blank*2-1
            if x + blank + w + blank + 32 > KScreenWidth{
                x = 0
                row = row + 1
            }
            x = x + blank
            let btn = UIButton.init(frame: CGRect(x: x, y: row*(h+blank), width: w, height: h))
            x = x + w
            btn.backgroundColor = KRGB(249, 249, 249)
            btn.layer.cornerRadius = 6
            btn.layer.masksToBounds = YES
            btn.layer.borderWidth = 1
            let col = KRGB(149, 149, 149)
            btn.layer.borderColor = col.cgColor

            btn.setTitle(str, for: .normal)
            btn.setTitleColor(col, for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
            btn.titleLabel?.lineBreakMode = .byTruncatingTail
            btn.addTarget(self, action: #selector(chooseTagBtn(_:)), for: .touchUpInside)
            tagBtnBGView.addSubview(btn)
            
            addTagViewH.constant = (row+1)*(h+blank)+70
        }
    }
    
    //给名字加上相对地址
    func getSaveKey(withName name:String) -> String {
        var path = directPath.components(separatedBy: "Documents").last!
        path = path + "/" + name
        return path
    }
    
    @objc func chooseTagBtn(_ btn:UIButton){
        tagInputTF.text = btn.titleLabel?.text
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
            tagDic[self.getSaveKey(withName: name)] = nil
        }else{
            tagDic[self.getSaveKey(withName: name)] = tagInputTF.text

        }
        tagInputTF.text = ""
        BMCache.set(.imageTagsDic, value: tagDic)
        
        self.closekeyboard()
        
        hideMaskView()
        loadTag()
    }
    
    @IBAction func frontAction(_ sender: Any) {
        if sc.direct != -1{
            sc.direct = -1
            sc.interval = 2
        }else{
            sc.interval = max(sc.interval * 0.75, 0.6)
        }
    }
    
    @IBAction func nextAction(_ sender: Any) {
        if sc.direct != 1{
            sc.direct = 1
            sc.interval = 2
        }else{
            sc.interval = max(sc.interval * 0.75, 0.6)
        }
    }
    
    @IBAction func stop(_ sender: Any) {
        sc.direct = 0
    }
    
}

extension ReviewVC: BMScrollViewDelegate{
    func bm_scrollView(view: UIImageView, willLoadIndex index: Int) {
        let path = subFilesUrl[index]
        view.image = UIImage(contentsOfFile: path)
        if path.contains("gif"){
            let url = URL(fileURLWithPath: path)
            view.kf.setImage(with: LocalFileImageDataProvider(fileURL: url), placeholder: view.image, options: [KingfisherOptionsInfoItem.fromMemoryCacheOrRefresh], progressBlock: nil, completionHandler: nil)
        }
    }
    
    // 编辑
    func bm_scrollView(didSelected index: Int) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let editAction = UIAlertAction(title: "编辑", style: UIAlertAction.Style.default){ (action:UIAlertAction)in
//            let vc = EditImageVC.fromStoryboard() as! EditImageVC
//            vc.path = self.subFilesUrl[index]
            
            let vc = EditVC()
            vc.imgPath = self.subFilesUrl[index]
            self.present(vc, animated: false, completion: nil)
        }
        
        let deleteAction = UIAlertAction(title: "删除", style: UIAlertAction.Style.destructive){ (action:UIAlertAction)in
            let path = self.subFilesUrl[index]
            try? FileManager.default.removeItem(atPath: path)
            self.subFiles.remove(at: index)
            self.subFilesUrl.remove(at: index)
            self.tagDic[self.getSaveKey(withName: self.name)] = nil
            self.sc.dataArr = self.subFilesUrl
            self.sc.loadImage()
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel,handler:nil)

        alert.addAction(editAction)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    func bm_scrollView(didScrollTo index: Int) {
        imageIndex = index
        titleLab.text = "\(index+1)/\(subFiles.count)"
        self.loadTag()
    }
    
    func bm_scrollView(DidScroll scrollView: UIScrollView) {
        var y = scrollView.contentOffset.y
        y = max(y, -y)
        if y > 5{
            self.stop(1)
        }
        if y > 90{
            dismiss(animated: true, completion: nil)
        }
    }
}



