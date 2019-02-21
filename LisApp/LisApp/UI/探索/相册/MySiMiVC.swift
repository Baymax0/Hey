//
//  MySiMiVC.swift
//  LisApp
//
//  Created by yimi on 2019/2/19.
//  Copyright © 2019 baymax. All rights reserved.
//

import UIKit
import Kingfisher

let cellH:CGFloat = 120

class MySiMiVC: BaseVC{

    weak var selectedCell : ImageFlowCollectionCell?
    
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

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = KBGGray
        initUI()
        loadData()
        //侧滑返回
        addSlideBack(view)
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
    
    func loadSubFile() {
        self.subFiles = try? fileManager.contentsOfDirectory(atPath: self.directPath)
        self.collectionView.collectionViewLayout.invalidateLayout()
        self.collectionView.reloadData()
    }
}


extension MySiMiVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        let num:CGFloat = 4
        let itemW = (KScreenWidth - 5 * (num - 1) - 10) / num
        let size = CGSize(width: itemW - 1, height: cellH)
        return size
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    
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
            cell.imgBGView.isHidden = false
            cell.fileBGView.isHidden = true
            cell.fileNameLab.text = name
            cell.fileImg.image = UIImage(named: "视频")
        }
        // 图片
        else{
            cell.img.kf.setImage(with: ImageResource(downloadURL: URL(fileURLWithPath: path)))
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let name = self.subFiles[indexPath.item]
        let path = String(format: "%@/%@", directPath, name)
        
        if Utils.isVideoFile(path) {
            let vc = VideoPlayVC()
            vc.videoURL = path
            self.present(vc, animated: true, completion: nil)
        }else if Utils.isDirectory(path) {
            self.directArr.append(name)
            self.loadSubFile()
        }else{
            // 预览
            
        }
    }

    
}
