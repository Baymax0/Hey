//
//  GroupImgVC.swift
//  MySugarHeap
//
//  Created by lzw on 2018/8/28.
//  Copyright © 2018 lizhiwei. All rights reserved.
//

import UIKit
import Kingfisher
import Hero

class GroupImgVC: BaseCollectionVC {

    var start:Int = 0
    weak var selectedCell : ImageFlowCollectionCell?

    var groupModel:DTGroupsModel! = nil

    var groupArr:Array<DTGroupsModel> = Array<DTGroupsModel>()

    var headSC: UIScrollView = UIScrollView(frame: CGRect(x: 0, y: KNaviBarH, width: KScreenWidth, height: 0))

    override func viewDidLoad() {
        super.viewDidLoad()
        initCollectionView(rect: CGRect(x: 0, y: KNaviBarSmallH, width: KScreenWidth, height: KScreenHeight-KNaviBarSmallH))
        view.sendSubview(toBack: collectionView)
        collectionView.mj_header = nil

        customHead()

        addSlideBack(view)

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
        param["include_fields"] = "favroite_count,reply_count"
        param["cate_key"] = groupModel.idFromTarget()
        Network.requestDT(DTApiManager.groupImage, params: param, model: DTList<DTImgListModel>.self) { (resp) in
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

//head view
extension GroupImgVC{
    //初始化 头部
    func customHead() -> Void {
        headSC.backgroundColor = .white
        collectionView.addSubview(headSC)

        view.sendSubview(toBack: headSC)
        view.sendSubview(toBack: collectionView)
        requestGroups()

    }
    //请求分组
    func requestGroups() -> Void {
        var param = Dictionary<String,Any>()

        param["category_id"] = groupModel.idFromTarget()
        Network.requestDT(.subGroups, params: param, model: DTGroupsDetailModel.self) { [weak self] (resp) in
            if resp != nil{
                    //拿到分组模型
                    if let m = resp?.sub_cates{
                        self?.groupArr =  m
                        self?.showGroups()
                    }
            }
        }
    }



    //显示分组
    func showGroups() -> Void {
        let mutiRows  = false
        let numInrow :CGFloat = 4.5
        let blankW   :CGFloat = 12
        let blankH   :CGFloat = 6
        let btnW    :CGFloat = (KScreenWidth-blankW*(numInrow+1))/numInrow
        let labH    :CGFloat = 30
        let btnH    :CGFloat = blankH + btnW + labH
        var x       :CGFloat = -btnW
        var y       :CGFloat = 0
        for i in 0 ..< groupArr.count{
            let model = groupArr[i]
            let btn = UIButton()
            btn.tag = i
            btn.addTarget(self, action: #selector(chooseGroup), for: .touchUpInside)

            let img = UIImageView(frame: CGRect(x: 0, y: blankH, width: btnW, height: btnW))
            img.layer.cornerRadius = 4
            img.layer.masksToBounds = true
            img.backgroundColor = KBGGray
            img.kf.setImage(with: model.icon_url.resource, placeholder: KDefaultImg.image, options: [.transition(ImageTransition.fade(0.1))])
            btn.addSubview(img)

            let lab = UILabel(frame: CGRect(x: 0, y: img.maxY, width: btnW, height: labH))
            lab.font = UIFont.systemFont(ofSize: 12)
            lab.textColor = KBlack_87
            lab.text = model.name
            lab.numberOfLines = 0
            lab.textAlignment = .center
            btn.addSubview(lab)

            x += (btnW + blankW)
            if mutiRows{//多行
                if (x+btnW) > KScreenWidth{
                    x = blankW
                    y += btnH
                }
                btn.frame = CGRect(x: x, y: y, width: btnW, height: btnH)
            }else{//单行
                btn.frame = CGRect(x: x, y: y, width: btnW, height: btnH)
            }
            headSC.addSubview(btn)
        }
        let headSCH = y + btnH + 4

        headSC.frame = CGRect(x: 0, y: -headSCH, width: KScreenWidth, height: headSCH)
        headSC.contentSize = CGSize(width: x, height: headSCH)
        collectionView.contentInset = UIEdgeInsetsMake((headSCH), 0, 0, 0)
    }

    @objc func chooseGroup(_ btn:UIButton) -> Void {
        print(btn.tag)
    }
}


extension GroupImgVC:CustomeCellProtocol {
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

