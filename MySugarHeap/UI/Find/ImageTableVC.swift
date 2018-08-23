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
    weak var selectedCell : ImageFlowCollectionCell?

    override func viewDidLoad() {
        super.viewDidLoad()
        hideNav = true
        initCollectionView(rect: CGRect(x: 0, y: 0, width: KScreenWidth, height: view.frame.height))
        collectionView.register(ImageFlowCollectionCell.self, forCellWithReuseIdentifier: cellID)
        collectionView.backgroundColor = KBGGray
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "ImageFlowCollectionCell", bundle: nil), forCellWithReuseIdentifier: cellID)

        collectionView.delaysContentTouches = false

        //请求数据
        loadNewDataWithIndicator()

        for v in collectionView.subviews{
            print(v)
        }
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
        cell.delegate = self
        cell.indexPath = indexPath
        let mod = self.dataArr[indexPath.item] as! DTImgListModel
        let imgStr = mod.photo.path.replacingOccurrences(of: "_webp", with: "")
        cell.imgView.kf.setImage(with: ImageResource(downloadURL: URL(string: imgStr)!), placeholder: nil, options: [.transition(ImageTransition.fade(1))], progressBlock: nil, completionHandler: nil)
        return cell
    }
    override func waterFallLayout(layout:UICollectionViewFlowLayout, index:NSInteger, width: CGFloat) -> CGFloat {
        return ImageFlowCollectionCell.getHeight(self.dataArr[index] as! DTImgListModel)
    }
}

extension ImageTableVC:UIScrollViewDelegate,UICollectionViewDelegate , CustomeCellProtocol{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        for cell in collectionView.visibleCells{
            (cell as! ImageFlowCollectionCell).select = false
        }
    }

    func didSelectedItems(_ index: IndexPath) {
        print(index.item)
        let vc = ImageDetailVC.fromStoryboard() as! ImageDetailVC
        let mod = self.dataArr[index.item] as! DTImgListModel
        vc.model = mod
        self.navigationController?.pushViewController(vc, animated: YES)
    }

}

