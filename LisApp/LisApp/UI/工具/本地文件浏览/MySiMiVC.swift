//
//  MySiMiVC.swift
//  LisApp
//
//  Created by yimi on 2019/2/19.
//  Copyright © 2019 baymax. All rights reserved.
//

import UIKit
import Kingfisher
import Hero

let cellH:CGFloat = 120
let rowNum:CGFloat = 3

class MySiMiVC: BaseVC{

    weak var selectedCell : ImageFlowCollectionCell?
    
    @IBOutlet weak var upBtn: UIButton!
    
    var fileManager:FileManager!
    //当前路径 层级 数组
    var directArr:Array<String>!
    //当前路径 层级 数组
    var directPath:String!{
        get{
            if directArr.count == 1{
                return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
            }else{
                return directArr.joined(separator: "/")
            }
        }
        set{
            
        }
    }
    var subFiles:Array<String>!
    var subSortFiles:Array<String>!

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet var settingView: UIView!
    @IBOutlet weak var contentModeSwitch: UISwitch!
    
    @IBOutlet weak var sortByTagSwitch: UISwitch!
    
    var tagDic:Dictionary<String,String>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = KBGGray
        
        tagDic = BMCache.getDic(.imageTagsDic) ?? Dictionary<String,String>()
        
        initUI()
        loadData()
        //侧滑返回
        addSlideBack(view)

        KingfisherManager.shared.cache.diskStorage.config.sizeLimit        =  100 * 1024 * 1024
        KingfisherManager.shared.cache.memoryStorage.config.totalCostLimit = 30 * 1024
    }
    
    func initUI(){
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = KBGGray
        collectionView.register(UINib(nibName: "CustomCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        collectionView.delaysContentTouches = false
        self.view.addSubview(collectionView)
    }
    
    @IBAction func upAction(_ sender: Any) {
        if self.directArr.count > 1{
            self.directArr.removeLast()
            self.loadSubFile()
        }else{
            
        }
    }
    
    func loadData(){
        fileManager = FileManager.default
        let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        self.directArr = [docDir!]
        self.loadSubFile()
    }
    
    // 刷新数据
    func loadSubFile() {
        self.subFiles = try? fileManager.contentsOfDirectory(atPath: self.directPath)
        var temp = Array<String>()
        for s in subFiles{
            if s.hasPrefix("."){
                continue
            }else{
                temp.append(s)
            }
        }
        self.subFiles = temp
        if directArr.count == 1{
            upBtn.isHidden = true
        }else{
            upBtn.isHidden = false
        }
        
        
        let sort = subFiles.sorted(by: { (a, b) -> Bool in
            if Utils.isDirectory2(a){
                return true
            }
            // 更具tag排序
            if sortByTagSwitch.isOn{
                let a1 = tagDic[getSaveKey(withName: a)] ?? a
                let b1 = tagDic[getSaveKey(withName: b)] ?? b
                return a1.localizedStandardCompare(b1) == ComparisonResult.orderedAscending
            }
            return a.localizedStandardCompare(b) == ComparisonResult.orderedAscending
        })
        subFiles = sort
        
        self.collectionView.collectionViewLayout.invalidateLayout()
        self.collectionView.alpha = 0
        self.collectionView.reloadData()
        UIView.animate(withDuration: 0.15) {
            self.collectionView.alpha = 1
        }
    }
    
    override func hideMaskView() {
        UIView.animate(withDuration: 0.3, animations: {
            self.maskView.alpha = 0
            self.settingView.alpha = 0
        }) { (_) in
            self.settingView.frame = CGRect(x: KScreenWidth, y: 0, width: 180, height: KScreenHeight)
            self.settingView.removeFromSuperview()
            self.maskView.removeFromSuperview()
        }
    }
    
    // 改变现实mode
    @IBAction func changeContentModeAction(_ sender: UISwitch) {
        self.collectionView.reloadData()
    }
    
    // tag 排序
    @IBAction func scotByTagAction(_ sender: Any) {
        self.loadSubFile()
    }
    
    //给名字加上相对地址
    func getSaveKey(withName name:String) -> String {
        var path = directPath.components(separatedBy: "Documents").last!
        path = path + name
        return path
    }
    
}


extension MySiMiVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    // ------------ layout
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        let itemW = (KScreenWidth - 5 * (rowNum - 1) - 10) / rowNum
        let size = CGSize(width: itemW - 1, height: cellH)
        return size
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
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
//        cell.indexPath = indexPath
        
        // 文件夹
        if Utils.isDirectory(path) {
            cell.imgBGView.isHidden = true
            cell.fileBGView.isHidden = false
            cell.fileNameLab.text = name
            cell.fileImg.image = UIImage(named: "文件夹")
        }
        // 视频
        else if Utils.isVideoFile(path){
            cell.imgBGView.isHidden = true
            cell.fileBGView.isHidden = false
            cell.fileNameLab.text = name
            cell.fileImg.image = UIImage(named: "视频")
        }
        // 图片
        else{
            cell.imgBGView.isHidden = false
            cell.fileBGView.isHidden = true
            if contentModeSwitch.isOn == true{
                cell.img.contentMode = .scaleAspectFill
            }else{
                cell.img.contentMode = .scaleAspectFit
            }
            self.loadImg(cell.img, path)
            if  name.contains("gif") {
                cell.gifLab.isHidden = false
            }else{
                cell.gifLab.isHidden = true
            }
        }
        //        cell.setData(mod)
        cell.backgroundColor = KBGGray
        return cell
    }
    
    func loadImg(_ view:UIImageView,_ path:String ){
        view.alpha = 0
        let url = URL(fileURLWithPath: path)
        view.kf.setImage(with: url)
        DispatchQueue.global().async {
            let img = UIImage(contentsOfFile: path)
            DispatchQueue.main.async {
                view.image = img
                UIView.animate(withDuration: 0.25, animations: {
                    view.alpha = 1
                })
            }
        }
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
            vc.videoURL = path
            vc.index = index
            vc.videoList = videoList
            self.present(vc, animated: true, completion: nil)
            
        }else if Utils.isDirectory(path) {
            self.directArr.append(name)
            self.loadSubFile()
            
        }else{
            // 预览
            let cell = collectionView.cellForItem(at: indexPath) as! CustomCell
            cell.img.hero.id = "imgHeroId \(indexPath.item)"
            
            let vc = ReviewVC.fromStoryboard() as! ReviewVC
            vc.tempImgView.hero.id = "imgHeroId \(indexPath.item)"
            vc.directPath = self.directPath
            vc.subFiles = self.subFiles
            vc.imageIndex = indexPath.item

            let name = self.subFiles[indexPath.item]
            let path = String(format: "%@/%@", directPath, name)
            vc.tempImgView.image = UIImage(contentsOfFile: path)
            
            self.present(vc, animated: true, completion: nil)
        }
    }
}


// MARK: -  ---------------------- setting ------------------------
extension MySiMiVC{
    @IBAction func openSettingAction(_ sender: Any) {
        window?.addSubview(self.maskView)
        settingView.frame = CGRect(x: KScreenWidth, y: 0, width: 180, height: KScreenHeight)
        window?.addSubview(settingView)
        self.maskView.alpha = 0
        self.settingView.alpha = 1
        UIView.animate(withDuration: 0.25) {
            self.maskView.alpha = 1
            self.settingView.frame = CGRect(x: KScreenWidth-180, y: 0, width: 180, height: KScreenHeight)
        }
    }
    
    
}
