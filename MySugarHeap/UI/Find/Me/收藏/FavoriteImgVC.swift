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

    let cellID = "cellID"

    var selectedTag : BMTag! = nil

    var chooseTagView : BMTagChooseTopView! = nil

    @IBOutlet weak var titleBtn: UIButton!
    @IBOutlet weak var titleBtnW: NSLayoutConstraint!
    @IBOutlet weak var titleImageView: UIImageView!

    var allImgArray = BMCache.getFavoriteImgList()

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
                self.dataArr = self.allImgArray
            }else{
                var tempArr = Array<BMFavorite<DTImgListModel>>()
                for model in self.allImgArray{
                    if model.tags[String(self.selectedTag.tagId!)] != nil {
                        tempArr.append(model)
                    }
                }
                self.dataArr = tempArr
            }
            //主线程
            DispatchQueue.main.async {
                self.reloadData();
            }
        }
    }

    //给layout高度，根据比例计算
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! ImageFlowCollectionCell
        cell.delegate = self
        cell.indexPath = indexPath
        let favModel = self.dataArr[indexPath.item] as! BMFavorite<DTImgListModel>
        let mod = favModel.model!
        let imgStr = mod.photo.path.replacingOccurrences(of: "_webp", with: "")
        cell.imgView.kf.setImage(with: imgStr.resource, placeholder: KDefaultImg.image, options: [.transition(ImageTransition.fade(1))])
        cell.titleLab.text = mod.msg
        let userImgStr = mod.sender.avatar.replacingOccurrences(of: "_webp", with: "")
        cell.userImg.kf.setImage(with: userImgStr.resource, placeholder: KDefaultAvatar.image, options: [.transition(ImageTransition.fade(1))])
        cell.userNameLab.text = mod.sender.username
        return cell
    }

    override func waterFallLayout(layout:UICollectionViewFlowLayout, index:NSInteger, width: CGFloat) -> CGFloat {
        let favModel = self.dataArr[index] as! BMFavorite<DTImgListModel>
        return ImageFlowCollectionCell.getHeight(favModel.model)
    }
}

extension FavoriteImgVC:UIScrollViewDelegate,UICollectionViewDelegate , CustomeCellProtocol{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        for cell in collectionView.visibleCells{
            (cell as! ImageFlowCollectionCell).select = false
        }
    }
    //跳转
    func didSelectedItems(_ index: IndexPath) {
        let imgHeroId   = "imgHeroId \(index.item)"
        let bottomId    = "bottom \(index.item)"
        let titleId     = "title \(index.item)"
        let userNameId  = "userName \(index.item)"
        let avatarId    = "avatar \(index.item)"

        weak var cell = collectionView.cellForItem(at: index) as? ImageFlowCollectionCell

        cell?.imgView.hero.id = imgHeroId
        cell?.bottomView.hero.id = bottomId
        cell?.titleLab.hero.id = titleId
        cell?.userNameLab.hero.id = userNameId
        cell?.userImg.hero.id = avatarId

        let vc = ImageDetailVC.fromStoryboard() as! ImageDetailVC
        let favModel = self.dataArr[index.item] as! BMFavorite<DTImgListModel>
        vc.model = favModel.model

        vc.hero.isEnabled = true
        vc.heroId = index.item
        present(vc, animated: true, completion: nil)
    }

}
