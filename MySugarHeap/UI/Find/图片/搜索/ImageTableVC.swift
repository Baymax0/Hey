//
//  ImageTableVC.swift
//  MySugarHeap
//
//  Created by lzw on 2018/8/22.
//  Copyright © 2018 lizhiwei. All rights reserved.
//

import UIKit
import Kingfisher
import Hero

class ImageTableVC: BaseCollectionVC {
    var start:Int = 0
    var keyWords:String = ""
    weak var selectedCell : ImageFlowCollectionCell?

    override func viewDidLoad() {
        super.viewDidLoad()
        initCollectionView(rect: CGRect(x: 0, y: 0, width: KScreenWidth, height: view.frame.height))
        //请求数据
        loadNewDataWithIndicator()
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
        Network.requestDT(api:DTApiManager.imageSearch, params: param, model: DTList<DTImgListModel>.self) { (resp) in
            if resp != nil{
                let arr = resp?.object_list ?? []
                if let next = (resp?.next_start) {
                    self.start = next
                    self.haveMoreData(true)
                }else{
                    self.haveMoreData(false)
                }
                if index != 0 {
                    self.dataArr.append(contentsOf: BMImage.convert(arr))
                }else{
                    self.dataArr = BMImage.convert(arr)
                }
            }
            self.reloadData();
        }
    }

    // cell
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! ImageFlowCollectionCell
        cell.delegate = self
        return cell
    }

}

extension ImageTableVC:CustomeCellProtocol{
    func didSelectedItems(_ index: IndexPath) {
        let imgHeroId   = "imgHeroId \(index.item)"
        let bottomId    = "bottom \(index.item)"
        let titleId     = "title \(index.item)"

        weak var cell = collectionView.cellForItem(at: index) as! ImageFlowCollectionCell

        cell?.imgView.hero.id = imgHeroId
        cell?.bottomView.hero.id = bottomId
        cell?.titleLab.hero.id = titleId

        let vc = ImageDetailVC.fromStoryboard() as! ImageDetailVC
        vc.model = self.dataArr[index.item]

        vc.hero.isEnabled = true
        vc.heroId = index.item
        present(vc, animated: true, completion: nil)
    }
}

