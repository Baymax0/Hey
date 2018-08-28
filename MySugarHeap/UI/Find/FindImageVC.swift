//
//  FindImageVC.swift
//  MySugarHeap
//
//  Created by lzw on 2018/8/22.
//  Copyright © 2018 lizhiwei. All rights reserved.
//

import UIKit
import Kingfisher
import Hero

class FindImageVC: BaseCollectionVC {

    var start:Int = 0
    weak var selectedCell : ImageFlowCollectionCell?
    var groupArr:Array<DTGroupsModel> = Array<DTGroupsModel>()

    var headSC: UIScrollView = UIScrollView(frame: CGRect(x: 0, y: KNaviBarH, width: KScreenWidth, height: 0))

    override func viewDidLoad() {
        super.viewDidLoad()
        hideNav = true
        initCollectionView(rect: CGRect(x: 0, y: KNaviBarH, width: KScreenWidth, height: KScreenHeight-KNaviBarH-KTabBarH))
        view.sendSubview(toBack: collectionView)
        collectionView.mj_header = nil

        customHead()
        //请求数据
        loadNewDataWithIndicator()
    }



    @IBAction func searchAction(_ sender: Any) {
        self.navigationController?.pushViewController(SearchVC.fromStoryboard(), animated: false)
    }

    @objc override func loadMoreData() -> Void {
        loadData(start)
    }

    override func loadData(_ index: Int) {
        var param = Dictionary<String,Any>()
        param["start"] = index
        param["limit"] = 0
        param["include_fields"] = "favroite_count,reply_count"
        Network.requestDT(DTApiManager.hotImg, params: param, model: DTList<DTImgListModel>.self) { (resp) in
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
extension FindImageVC{
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
        Network.requestDTList(.groups, params: Dictionary<String,Any>(), model: DTGroupsListModel.self) { [weak self] (resp) in
            if resp != nil{
                let noNeedDic = ["视频":"1",
                                 "堆糖Class":"1",
                                 "美食菜谱":"1",
                                 "瘦身塑形":"1",
                                 "婚纱婚礼":"1",
                                 "时尚街拍":"1",
                                 "美容美妆":"1",]
                for m in resp!{
                    //拿到分组模型
                    if m.group_id == "category_i_1"{
                        let arr = m.group_items
                        for i in arr!{
                            //过滤
                            if noNeedDic[i.name] == nil{
                                self?.groupArr.append(i)
                            }
                        }
                        self?.showGroups()
                    }
                }
            }
        }
    }

    //显示分组
    func showGroups() -> Void {
        let mutiRows  = true
        let numInrow:CGFloat = 3
        let blankW   :CGFloat = 25
        let blankH   :CGFloat = 10
        let btnW    :CGFloat = (KScreenWidth-blankW*(numInrow+1))/numInrow
        let labH    :CGFloat = 30
        let btnH    :CGFloat = blankH + btnW + labH
        var x       :CGFloat = -btnW
        var y       :CGFloat = 10
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

        let headSCH = y + btnH
        let headImgView = UIImageView(frame: CGRect(x: 20, y: -headSCH-(70+15), width: KScreenWidth-40, height: 70))
        headImgView.image = #imageLiteral(resourceName: "分类")
        headImgView.contentMode = .scaleAspectFill
        headImgView.layer.cornerRadius = 10
        headImgView.layer.masksToBounds = true
        collectionView.addSubview(headImgView)

        headSC.frame = CGRect(x: 0, y: -headSCH, width: KScreenWidth, height: headSCH)
        headSC.contentSize = CGSize(width: x, height: headSCH)

        collectionView.contentInset = UIEdgeInsetsMake((headSCH+100), 0, 0, 0)
    }

    @objc func chooseGroup(_ btn:UIButton) -> Void {
        print(btn.tag)

        let vc = GroupImgVC.fromStoryboard() as! GroupImgVC

        navigationController?.pushViewController(vc, animated: true)
//        present(vc, animated: true, completion: nil)
    }
}

extension FindImageVC:CustomeCellProtocol {
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
//        present(vc, animated: true, completion: nil)
        navigationController?.pushViewController(vc, animated: true)
    }
}




