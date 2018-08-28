//
//  FavoriteImgVC.swift
//  MySugarHeap
//
//  Created by lzw on 2018/8/27.
//  Copyright © 2018 lizhiwei. All rights reserved.
//

import UIKit
import Kingfisher
import Hero

class FavoriteImgVC: BaseCollectionVC {

    var selectedTag : BMTag! = nil
    var chooseTagView : BMTagChooseTopView! = nil

    @IBOutlet weak var titleBtn: UIButton!
    @IBOutlet weak var titleBtnW: NSLayoutConstraint!
    @IBOutlet weak var titleImageView: UIImageView!

    var allImgArray = BMCache.getFavoriteImgList()

    var filterArray = Array<BMFavorite<BMImage>>()

    @IBAction func titleBtnAction(_ sender: Any) {
        titleAnimation(!chooseTagView.isShow)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        hideNav = true

        initCollectionView(rect: CGRect(x: 0, y: KNaviBarH, width: KScreenWidth, height: KScreenHeight-KNaviBarH))
        collectionView.register(ImageFlowCollectionCell.self, forCellWithReuseIdentifier: cellID)
        collectionView.backgroundColor = KBGGray
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "ImageFlowCollectionCell", bundle: nil), forCellWithReuseIdentifier: cellID)

        collectionView.delaysContentTouches = false
        collectionView.mj_header = nil

        selectedTag = AllItemTag

        loadData(0)

        chooseTagView = BMTagChooseTopView(rect: CGRect(x: 0, y: KNaviBarH, width: KScreenWidth, height: KScreenHeight-KNaviBarH), BMTagType.ImgTag) { (tag) in
            self.selectedTag = tag
            let title = tag.tagName!
            self.titleBtn.setTitle(title, for: .normal)
            self.titleBtnW.constant = title.stringWidth(16)+40
            self.titleAnimation(false)
            self.loadNewDataWithIndicator()
        }
    }

    func titleAnimation(_ show:Bool) -> Void{
        if show {
            chooseTagView.show(selectedTag)
        }else{
            chooseTagView.close()
        }
        UIView.animate(withDuration: 0.2) {
            if show{
                self.titleImageView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
            }else{
                self.titleImageView.transform = CGAffineTransform.identity
            }
        }
    }

    override func loadData(_ index: Int) {
        DispatchQueue.global().async {
            if self.selectedTag == AllItemTag {
                self.filterArray = self.allImgArray
            }else{
                self.filterArray = Array<BMFavorite<BMImage>>()
                for model in self.allImgArray{
                    if model.tags[String(self.selectedTag.tagId!)] != nil {
                        self.filterArray.append(model)
                    }
                }
            }
            self.dataArr = self.filterArray.map{$0.model}
            //主线程
            DispatchQueue.main.async {
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

extension FavoriteImgVC:CustomeCellProtocol{
    //跳转
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
