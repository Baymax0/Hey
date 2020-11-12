//
//  FileManageVC.swift
//  Lee
//
//  Created by 李志伟 on 2020/9/29.
//  Copyright © 2020 baymax. All rights reserved.
//

import UIKit
import Kingfisher
import Hero
import MediaPlayer

enum FileShowType:Int{
    case list //列表展示
    case review //预览图
    
    case fill //填充
    case fit //缩小适配
    
    case sortByName //
    case sortByTag
}

var cellH:CGFloat = 120
var rowNum:CGFloat = 3
var cellW:CGFloat = 180
var blank:CGFloat = 8


class FileManageVC: BaseVC {
    
    var allTag = " All "
    var kongTag = " 空 "
    let perple = #colorLiteral(red: 0.3909234405, green: 0.3515967131, blue: 0.7621985078, alpha: 1)

    @IBOutlet weak var locLab: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tagChooseBG: UIView!
    @IBOutlet weak var tagChooseSC: UIScrollView!
    @IBOutlet weak var tagChooseBGH: NSLayoutConstraint!
    
    var showListOrReview:FileShowType = .list
    var showImgType:FileShowType = .fill
    var sortType:FileShowType = .sortByName

    var subFiles:Array<String>!
    var subSortFiles:Array<String>!

    
    weak var lastTagBtn:UIButton? // 上一次选择的tagBtn
    var tagDic:Dictionary<String,String>!
    var tagSortArr:Array<String>!
    var fileManager = FileManager.default
    var directArr:Array<String>! = []//当前路径 层级 数组
    var directPath:String!{ //当前路径 层级 数组
        if directArr.count == 1{
            return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        }else{
            return directArr.joined(separator: "/")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tagChooseBG.isHidden = true
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .KBGGray
        collectionView.register(UINib(nibName: "CustomCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        collectionView.delaysContentTouches = false
        collectionView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 110, right: 0)
        
        KingfisherManager.shared.cache.diskStorage.config.sizeLimit        =  500 * 1024 * 1024
        KingfisherManager.shared.cache.memoryStorage.config.totalCostLimit = 1024 * 1024 * 1024
        
        let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        self.directArr = [docDir!]
        self.loadSubFile()
        
        self.loadTagChooseView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tagDic = (cache[.imageTagsDic] as? Dictionary<String, String>) ?? Dictionary<String, String>()
    }

    /// 返回上一级
    @IBAction func backAction(_ sender: Any) {
        if self.directArr.count > 1{
            self.directArr.removeLast()
            self.loadSubFile()
        }else{
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    /// 显示tag选择框
    @IBAction func tagOpenAction(_ sender: UIButton) {
        if tagChooseBG.isHidden == true{//显示
            tagChooseBG.isHidden = false
            sender.tintColor = UIColor.red
            UIView.animate(withDuration: 0.15) {
                self.tagChooseBGH.constant = 50
                self.view.layoutIfNeeded()
            } completion: { (_) in }
            
        }else{//隐藏
            sender.tintColor = .KTextBlack
            UIView.animate(withDuration: 0.2) {
                self.tagChooseBGH.constant = 0
                self.view.layoutIfNeeded()
            } completion: { (_) in
                self.tagChooseBG.isHidden = true
            }
        }
        self.loadSubFile()
    }
    
    /// 选中tag
    @objc func chooseTagBtn(_ btn:UIButton!) {
        if lastTagBtn != nil{
            let col = UIColor.lightGray
            lastTagBtn!.layer.borderColor = col.cgColor
            lastTagBtn!.setTitleColor(col, for: .normal)
        }
        
        if btn != nil{
            btn.setTitleColor(perple, for: .normal)
            btn.layer.borderColor = perple.cgColor
            lastTagBtn = btn
            self.loadSubFile()
        }
        
    }
    
    /// 列表展示还是图文展示
    @IBAction func showListAction(_ sender: UIButton) {
        showListOrReview = showListOrReview == .list ?  .review: .list
        if showListOrReview == .list{
            let image = UIImage.init(systemName: "photo.on.rectangle.angled", withConfiguration: UIImage.SymbolConfiguration(weight: .bold))
            sender.setImage(image, for: .normal)
        }else{
            let image = UIImage.init(systemName: "list.bullet", withConfiguration: UIImage.SymbolConfiguration(weight: .bold))
            sender.setImage(image, for: .normal)
        }
        self.loadSubFile()
    }

    
    @IBAction func reloadAction(_ sender: Any) {
        self.loadSubFile()
    }
    
}


extension FileManageVC{
    // 刷新数据
    func loadSubFile() {
        // 过滤
        self.subFiles = try? fileManager.contentsOfDirectory(atPath: self.directPath)
        var temp = Array<String>()
        for s in subFiles{
            // 过滤.开头的隐藏文件
            if s.hasPrefix("."){ continue }
            else if s.hasPrefix("Cache"){ continue }
            
            // 文件默认显示
            if Utils.isDirectory(s){
                temp.append(s)
                continue
            }
            
            // 过滤tag
            if lastTagBtn != nil {
                let sortTagStr = tagSortArr[lastTagBtn!.tag]
                // 显示所有
                if sortTagStr == allTag{
                    temp.append(s)
                }
                // 只显示没标签的
                else if sortTagStr == kongTag{
                    if let _  = tagDic[s] {
                        continue
                    }else{
                        temp.append(s)
                    }
                }
                // 只显示固定标签
                else{
                    let tag  = tagDic[s]
                    if tag == sortTagStr{
                        temp.append(s)
                    }
                }
            }else{
                temp.append(s)
            }
        }
        
        
        // 排序
        self.subFiles = temp
        if tagDic == nil{
            tagDic = (cache[.imageTagsDic] as? Dictionary<String, String>) ?? Dictionary<String, String>()
        }
        let sort = subFiles.sorted(by: { (a, b) -> Bool in
            // 文件夹类型 靠前
            if Utils.isDirectory2(a) && !Utils.isDirectory2(b){
                return true
            }else if !Utils.isDirectory2(a) && Utils.isDirectory2(b){
                return false
            }

            // tag 排序
            if sortType == .sortByTag{// 更具tag排序
                let a1 = tagDic[a]
                let b1 = tagDic[b]
                if a1 == nil ,b1 != nil{
                    return false
                } else if b1 == nil ,a1 != nil{
                    return true
                }else if b1 != nil ,a1 != nil{
                    return a1!.localizedStandardCompare(b1!) == ComparisonResult.orderedAscending
                }else{
                    return a.localizedStandardCompare(b) == ComparisonResult.orderedAscending
                }
            }
            return a.localizedStandardCompare(b) == ComparisonResult.orderedAscending
        })
        subFiles = sort
        self.collectionView.collectionViewLayout.invalidateLayout()
        
        // 头部路径显示
        var str = ""
        for s in directArr{
            if !s.contains("/var/mobile"){ str = str + "/" + s }
        }
        str = str.count == 0 ? "文件夹" : str
        locLab.text = str + "   (\(subFiles.count))"
        
        // 刷新
        CATransaction.setDisableActions(YES)
        self.collectionView.reloadData()
        CATransaction.commit()
    }
    
    func loadTagChooseView() {
        let blank:CGFloat = 15
        let h   :CGFloat  = 35
        let y   :CGFloat  = (50 - h) / 2
        let fontSize:CGFloat = 14
        var x   :CGFloat    = blank

        var set = Set<String>()
        for (_,str) in tagDic{
            set.insert(str)
        }
        tagSortArr = set.sorted()
        tagSortArr.insert(allTag, at: 0)
        tagSortArr.append(kongTag)

        for i in 0..<tagSortArr.count {
            let str = tagSortArr[i]
            var w = str.stringWidth(fontSize)+30
            w = w < (KScreenWidth-blank*2) ? w : KScreenWidth-blank*2-1
            
            let btn = UIButton.init(frame: CGRect(x: x, y: y, width: w, height: h))
            x = x + blank
            x = x + w
            btn.tag = i
            btn.backgroundColor = .white
            btn.layer.cornerRadius = 6
            btn.layer.masksToBounds = YES
            btn.layer.borderWidth = 1
            
            btn.layer.borderColor = UIColor.lightGray.cgColor
            btn.setTitleColor(UIColor.lightGray, for: .normal)

            btn.setTitle(str, for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
            btn.titleLabel?.lineBreakMode = .byTruncatingTail
            btn.addTarget(self, action: #selector(chooseTagBtn(_:)), for: .touchUpInside)
            tagChooseSC.addSubview(btn)
            
        }
        tagChooseSC.contentSize = CGSize(width: x, height: 50)
        
    }
    
}


extension FileManageVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    // 方向改变回调
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        self.coculate(size: size);
        self.collectionView.reloadData()
    }
    
    // 分屏大小改变回调
    override func viewDidLayoutSubviews() {
        self.coculate(size: self.view.mj_size);
    }
    
    func coculate(size: CGSize) {
        let n = Int(size.width / 100)
        rowNum = CGFloat(n)
        rowNum = max(rowNum, 2)
        rowNum = min(rowNum, 7)
        cellW = (size.width - blank * (rowNum + 1)) / rowNum - 1
        cellH = cellW * 0.99
    }
    
    // ------------ layout
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        if showListOrReview == .list{
            return CGSize(width: self.view.w - blank * 2, height: 44)
        }else{
            let size = CGSize(width: cellW, height: cellH)
            return size
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if showListOrReview == .list{
            return UIEdgeInsets(top: 0, left: blank, bottom: 0, right: blank)
        }
        return UIEdgeInsets(top: blank, left: blank, bottom: 0, right: blank)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return showListOrReview == .list ? 1 : blank
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return blank
    }
    
    // ------------ data
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.subFiles.count
    }
    
    // cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CustomCell
        let name = self.subFiles[indexPath.item]
        let path = String(format: "%@/%@", directPath, name)
        cell.fileNameLab.text = name
        // 显示名称列表
        if showListOrReview == .list{
            cell.setType(1)
            if Utils.isDirectory(path) {
                cell.fileNameLab.text = " 📁 " + name
            }
        }else if Utils.isDirectory(path) {// 文件夹
            cell.setType(2) 
        } else if Utils.isVideoFile(path){// 视频
            cell.setType(3)
            cell.fileImg.image = getFrameImg(path)
        }else{// 图片
            cell.setType(4)
            let url = URL(fileURLWithPath: path)
            cell.fileImg.kf.setImage(with: LocalFileImageDataProvider(fileURL: url), placeholder: nil, options: [KingfisherOptionsInfoItem.forceRefresh, .transition(.fade(0.1)), .onlyLoadFirstFrame], progressBlock: nil, completionHandler: nil)
            
            if showImgType == .fill{
                cell.fileImg.contentMode = .scaleAspectFill
            }else{
                cell.fileImg.contentMode = .scaleAspectFit
            }
            cell.gifLab.isHidden = !name.contains("gif")
            if sortType == .sortByTag{
                cell.fileNameLab.text = tagDic[name]
                if cell.fileNameLab.text.bm_count == 0{
                    cell.titleLabH.constant = 0
                }else{
                    cell.titleLabH.constant = 34
                }
            }
        }
        cell.backgroundColor = .KBGGray
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let name = self.subFiles[indexPath.item]
        let path = String(format: "%@/%@", directPath, name)

        if Utils.isVideoFile(path) {
            var videoList = Array<String>()
            var index = 0
            for name in self.subFiles{
                if Utils.isVideoFile(name){
                    let tempPath = String(format: "%@/%@", directPath, name)
                    if tempPath == path{
                        index = videoList.count
                    }
                    videoList.append(tempPath)
                }
            }
            let vc = VideoPlayVC()
            vc.modalPresentationStyle = .fullScreen
            vc.videoURL = path
            vc.index = index
            vc.videoList = videoList
            self.present(vc, animated: true, completion: nil)
        }else if Utils.isDirectory(path) {
            self.directArr.append(name)
            self.loadSubFile()
        }else{
            // 预览
            let vc = ReviewVC.fromStoryboard() as! ReviewVC
            vc.directPath = self.directPath
            vc.subFiles = self.subFiles
            vc.imageIndex = indexPath.item
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func getFrameImg(_ path:String) -> UIImage {
        let url = URL(fileURLWithPath: path)
        let avAsset = AVAsset(url: url)
        //生成视频截图
        let generator = AVAssetImageGenerator(asset: avAsset)
        generator.appliesPreferredTrackTransform = true
        let time = CMTimeMakeWithSeconds(0.0, preferredTimescale:600)
        var actualTime:CMTime = CMTime(seconds: 0, preferredTimescale: 0)
        let imageRef = try! generator.copyCGImage(at: time, actualTime: &actualTime)
        let img = UIImage(cgImage: imageRef)
        return img
    }
    
}


extension FileManageVC:UIDropInteractionDelegate{
    // 是否接收
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return YES
    }
    
    //拖动
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        // // 外部Drag 目标
        if (session.localDragSession == nil) {
            return UIDropProposal(operation: .copy)
        }
        return UIDropProposal(operation: .move)
    }
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        if (session.localDragSession == nil) {
            for item in session.items{
                
                if item.itemProvider.canLoadObject(ofClass: UIImage.self){
                    item.itemProvider.loadObject(ofClass: UIImage.self) { (object, err) in
                        if err == nil && object != nil{
                            DispatchQueue.main.async {
                                self.receiveImg(object as? UIImage)
                            }
                        }
                    }
                }
                    
                else{//读取 data 视频
                    item.itemProvider.loadDataRepresentation(forTypeIdentifier: item.itemProvider.registeredTypeIdentifiers.first!) { (data, err) in
                        if err == nil && data != nil{
                            let videoData = data! as NSData
                            DispatchQueue.main.async {
                                self.receiveVideo(videoData)}
                        }
                    }
                }
            }
        }
    }
    
    func receiveImg(_ img:UIImage?){
        Hud.showWait()
        let name = Date().toString("yyyyMMddHHmmss")
        let path = String(format: "%@/%@.png", self.directPath, name)
        try? img!.pngData()?.write(to: URL(fileURLWithPath: path), options: .atomic)
        Hud.showText("已保存")
        Hud.runAfterHud {
            self.loadSubFile()
        }
    }
    
    func receiveVideo(_ data:NSData!){
        Hud.showWait()
        let name = Date().toString("MMdd-HHmmss")
        let videoPath = String(format: "%@/%@.mov", self.directPath, name)
        let tempUrl = URL.init(fileURLWithPath: videoPath)
        data.write(to: tempUrl, atomically: true)
        Hud.showText("已保存")
        Hud.runAfterHud {
            self.loadSubFile()
        }
    }

}
