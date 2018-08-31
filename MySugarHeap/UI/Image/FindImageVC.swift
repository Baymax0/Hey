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

class FindImageVC: BaseVC {

    var start:Int = 0
    weak var selectedCell : ImageFlowCollectionCell?

    @IBOutlet weak var contentSC: UIScrollView!

    @IBOutlet weak var topView: UIView!

    @IBOutlet weak var myHoppyView: UIView!
    @IBOutlet weak var myHoppyViewH: NSLayoutConstraint!
    var hoppyArr:Array<HBHoppyModel> = Array<HBHoppyModel>()


    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var bottomViewH: NSLayoutConstraint!
    var groupArr:Array<DTGroupsModel> = Array<DTGroupsModel>()

    override func viewDidLoad() {
        super.viewDidLoad()
        contentSC.backgroundColor = KBGGray
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.groupArr.count == 0 {

            requestHoppys()
            //堆糖数据
            requestGroups()
        }
    }

    @IBAction func searchAction(_ sender: Any) {
        present(SearchVC.fromStoryboard(), animated: false, completion: nil)
    }



}
// MARK: - 兴趣 分类
extension FindImageVC {

    func requestHoppys() -> Void {
        var param = Dictionary<String,Any>()
        param["page"] = 1
        param["per_page"] = 30
        //获取我关注的分类
        Network.requesrHB(api: .myThemeList, params: param, model: HBMyHoppList.self) { [weak self](myList) in
            if let list = myList?.explores{
                self?.hoppyArr = list
                self?.loadHoppy()
            }
        }
    }

    func loadHoppy() -> Void {
        let numInrow:CGFloat = 3
        let blankW   :CGFloat = 28
        let blankH   :CGFloat = 15
        let btnW    :CGFloat = (KScreenWidth-blankW*(numInrow+1))/numInrow
        let labH    :CGFloat = 22
        let btnH    :CGFloat = blankH + btnW
        var x       :CGFloat = -btnW
        var y       :CGFloat = 35

        for i in 0 ..< hoppyArr.count{
            let model = hoppyArr[i]
            let btn = UIButton()
            btn.tag = i
            btn.addTarget(self, action: #selector(chooseHoppy(_:)), for: .touchUpInside)

            let img = UIImageView(frame: CGRect(x: 0, y: blankH, width: btnW, height: btnW))
            img.layer.cornerRadius = 4
            img.layer.masksToBounds = true
            img.backgroundColor = KBGGrayLine
            img.contentMode = .scaleAspectFill
            img.kf.setImage(with: model.imgUrl().resource, placeholder: nil, options: [.transition(ImageTransition.fade(0.1))])
            img.clipsToBounds = true
            img.hero.id = "img\(i)"
            btn.addSubview(img)

            let lab = UILabel(frame: CGRect(x: 0, y: 0, width: btnW, height: labH))
            lab.font = UIFont.init(name: "PingFangTC-Regular", size: 12)
            lab.backgroundColor = KBlack_0.withAlphaComponent(0.3)
            lab.textColor = KWhite
            let name = model.name!
            lab.text = "  \(name)"
            lab.numberOfLines = 1
            lab.hero.id = "title\(i)"
            img.addSubview(lab)

            x += (btnW + blankW)
            if (x+btnW) > KScreenWidth{
                x = blankW
                y += btnH
            }
            btn.frame = CGRect(x: x, y: y, width: btnW, height: btnH)
            btn.alpha = 0
            UIView.animate(withDuration: 0.2) {
                btn.alpha = 1
            }
            myHoppyView.addSubview(btn)
        }
        UIView.animate(withDuration: 0.5) {
            self.myHoppyView.superview?.layoutIfNeeded()
            self.myHoppyViewH.constant = y + btnH + 15
        }
    }

    @objc func chooseHoppy(_ btn:UIButton) -> Void {
        let vc = HoppyImgVC.fromStoryboard() as! HoppyImgVC
        vc.hoppyModel = hoppyArr[btn.tag]
        vc.heroId = btn.tag
        present(vc, animated: true, completion: nil)
    }
}




// MARK: - 堆糖 分类
extension FindImageVC {
    //请求分组
    func requestGroups() -> Void {
        Network.requestDTList(api:.groups, params: Dictionary<String,Any>(), model: DTGroupsListModel.self) { [weak self] (resp) in
            if resp != nil{
                let noNeedDic = ["视频":"1","堆糖Class":"1","美食菜谱":"1","瘦身塑形":"1","婚纱婚礼":"1","时尚街拍":"1","美容美妆":"1"]
                for m in resp!{
                    if m.group_id == "category_i_1"{ //拿到分组模型
                        let arr = m.group_items
                        for i in arr!{
                            //过滤
                            if noNeedDic[i.name] == nil{
                                self?.groupArr.append(i)
                            }
                        }
                        self?.showGroups()
                    }}}}
    }

    @objc func chooseGroup(_ btn:UIButton) -> Void {
        let vc = GroupImgVC.fromStoryboard() as! GroupImgVC
        vc.groupModel = groupArr[btn.tag]
        present(vc, animated: true, completion: nil)
    }
    //显示分组
    func showGroups() -> Void {
        let mutiRows  = true
        let numInrow:CGFloat = 3
        let blankW   :CGFloat = 28
        let blankH   :CGFloat = 10
        let btnW    :CGFloat = (KScreenWidth-blankW*(numInrow+1))/numInrow
        let labH    :CGFloat = 30
        let btnH    :CGFloat = blankH + btnW + labH
        var x       :CGFloat = -btnW
        var y       :CGFloat = 40

        for i in 0 ..< groupArr.count{
            let model = groupArr[i]
            let btn = UIButton()
            btn.tag = i
            btn.addTarget(self, action: #selector(chooseGroup), for: .touchUpInside)

            let img = UIImageView(frame: CGRect(x: 0, y: blankH, width: btnW, height: btnW))
            img.layer.cornerRadius = 4
            img.layer.masksToBounds = true
            img.backgroundColor = KBGGrayLine
            img.kf.setImage(with: model.icon_url.resource, placeholder: nil, options: [.transition(ImageTransition.fade(0.1))])
            btn.addSubview(img)

            let lab = UILabel(frame: CGRect(x: 0, y: img.maxY, width: btnW, height: labH))
            lab.font = UIFont.init(name: "PingFangTC-Regular", size: 12)

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
            }
            bottomView.addSubview(btn)
        }
        UIView.animate(withDuration: 0.5) {
            self.bottomViewH.constant = y + btnH + 15
            self.bottomView.superview?.layoutIfNeeded()
        }
    }
}



