//
//  ImageTableVC.swift
//  MySugarHeap
//
//  Created by lzw on 2018/8/22.
//  Copyright © 2018 lizhiwei. All rights reserved.
//

import UIKit
import Kingfisher

class ImageTableVC: BaseCollectionView {

    var start:Int = 0
    var keyWords:String = ""
    let cellID = "cellID"

    override func viewDidLoad() {
        super.viewDidLoad()
        hideNav = true
        initCollectionView(rect: CGRect(x: 0, y: 0, width: KScreenWidth, height: view.frame.height))
        collectionView.register(ImageFlowCollectionCell.self, forCellWithReuseIdentifier: cellID)
        collectionView.backgroundColor = KBGGray;
        collectionView.register(UINib(nibName: "ImageFlowCollectionCell", bundle: nil), forCellWithReuseIdentifier: cellID)
        //请求数据
        loadNewDataWithIndicator()
    }

    @objc override func loadNewData() -> Void {
        loadData(0)
    }
    @objc override func loadMoreData() -> Void {
        loadData(start)
    }

    override func loadData(_ index: Int) {
        var param = Dictionary<String,Any>()
        param["start"] = index
        param["limit"] = 0
        param["kw"] = keyWords
        param["buyable"] = 0
        param["include_fields"] = "sender,favroite_count,album,reply_count,like_count"
        Network.requestDT(DTApiManager.imageSearch, params: param, model: DTList<DTImgListModel>.self) { (resp) in
            if resp != nil{
                self.start = (resp?.next_start)!
                if index != 0 {
                    self.dataArr.append(contentsOf: resp?.object_list ?? [])
                }else{
                    self.dataArr = resp?.object_list ?? []
                }
            }
            self.reloadData();
        }
    }

    //给layout高度，根据比例计算
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! ImageFlowCollectionCell
        let mod = self.dataArr[indexPath.item] as! DTImgListModel
        let imgStr = mod.photo.path.replacingOccurrences(of: "_webp", with: "")
        cell.imgView.kf.setImage(with: ImageResource(downloadURL: URL(string: imgStr)!), placeholder: nil, options: [.transition(ImageTransition.fade(1))], progressBlock: nil, completionHandler: nil)
        return cell
    }
    override func waterFallLayout(layout:UICollectionViewFlowLayout, index:NSInteger, width: CGFloat) -> CGFloat {
        return ImageFlowCollectionCell.getHeight(self.dataArr[index] as! DTImgListModel)
    }
}
