//
//  HoppyImgVC.swift
//  MySugarHeap
//
//  Created by lzw on 2018/8/30.
//  Copyright © 2018 lizhiwei. All rights reserved.
//

import UIKit

class HoppyImgVC: BaseCollectionVC {

    var start:Int = 0

    var hoppyModel:HBHoppyModel! = nil

    var heroId:Int = 0

    @IBOutlet weak var titleLab: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        initCollectionView(rect: CGRect(x: 0, y: KNaviBarSmallH, width: KScreenWidth, height: KScreenHeight-KNaviBarSmallH))
        view.sendSubview(toBack: collectionView)
        collectionView.mj_header = nil
        titleLab.text = hoppyModel.name
        loadNewData()

        self.titleLab.hero.id = "title\(heroId)"
        self.view.hero.id = "img\(heroId)"
        //侧滑返回
        addSlideBack(view)
    }

    @objc override func loadMoreData() -> Void {
        loadData(start)
    }
    override func loadData(_ index: Int) {
        var param = Dictionary<String,Any>()
        if index != 0{
            param["max"] = index
        }
        param["limit"] = 40

        Network.requesrHB(api: .themeImages(hoppyModel.urlname!), params: param, model: HBHoppyModel.self) { (mod) in
            if let arr = mod?.pins{
                if arr.count>0 && arr.count<40{
                    self.haveMoreData(false)
                }else{
                    self.start = (arr.last?.pin_id)!
                    self.haveMoreData(true)
                }

                if index != 0{
                    self.dataArr.append(contentsOf: BMImage.convert(arr))
                }else{
                    self.dataArr.append(contentsOf: BMImage.convert(arr))
                }
                self.reloadData();
            }
        }
    }

    // cell
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! ImageFlowCollectionCell
        cell.delegate = self
        return cell
    }
}

extension HoppyImgVC:CustomeCellProtocol {
    func didSelectedItems(_ index: IndexPath) {
        let imgHeroId   = "imgHeroId \(index.item)"
        let bottomId    = "bottom \(index.item)"
        let titleId     = "title \(index.item)"

        weak var cell = collectionView.cellForItem(at: index) as? ImageFlowCollectionCell

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
