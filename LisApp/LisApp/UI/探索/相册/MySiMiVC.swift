//
//  MySiMiVC.swift
//  LisApp
//
//  Created by yimi on 2019/2/19.
//  Copyright © 2019 baymax. All rights reserved.
//

import UIKit

class MySiMiVC: BaseCollectionVC {

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initCollectionView(rect: CGRect(x: 0, y: 64, width: KScreenWidth, height: view.frame.height))
        loadData()
        //侧滑返回
        addSlideBack(view)
    }
    
    func loadData(){
        fileManager = FileManager.default
        let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        self.directArr = [docDir!]
    }
    
    func loadSubFile() {
        self.dataArr = try? fileManager.contentsOfDirectory(atPath: self.directPath)
        //过滤
    }
    
    // cell
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! ImageFlowCollectionCell
        cell.indexPath = indexPath
        let name = self.dataArr[indexPath.item] as! String
        let path = String(format: "%@/%@", directPath, name)
        
        if Utils.isDirectory(path) {
            
        }else if
        
        
        
        //        cell.setData(mod)
        cell.backgroundColor = .black
        cell.delegate = self
        
        return cell
    }

}

extension MySiMiVC:CustomeCellProtocol{
    func didSelectedItems(_ index: IndexPath) {
//        let imgHeroId   = "imgHeroId \(index.item)"
//        let bottomId    = "bottom \(index.item)"
//        let titleId     = "title \(index.item)"
//
//        weak var cell = collectionView.cellForItem(at: index) as? ImageFlowCollectionCell
//
//        cell?.imgView.hero.id = imgHeroId
//        cell?.bottomView.hero.id = bottomId
//        cell?.titleLab.hero.id = titleId
//
//        let vc = ImageDetailVC.fromStoryboard() as! ImageDetailVC
//        vc.model = self.dataArr[index.item]
//
//        vc.hero.isEnabled = true
//        vc.heroId = index.item
//        present(vc, animated: true, completion: nil)
    }
}
