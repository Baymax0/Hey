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
    var groupArr:Array<DTGroupsModel> = Array<DTGroupsModel>()

    @IBOutlet weak var contentSC: UIScrollView!

    @IBOutlet weak var topView: UIView!

    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var bottomViewH: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        contentSC.backgroundColor = KBGGray
        requestGroups()
    }

    @IBAction func searchAction(_ sender: Any) {
        present(SearchVC.fromStoryboard(), animated: false, completion: nil)
    }

    //请求分组
    func requestGroups() -> Void {
        Network.requestDTList(.groups, params: Dictionary<String,Any>(), model: DTGroupsListModel.self) { [weak self] (resp) in
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
            img.backgroundColor = KBGGray
            img.kf.setImage(with: model.icon_url.resource, placeholder: KDefaultImg.image, options: [.transition(ImageTransition.fade(0.1))])
            btn.addSubview(img)

            let lab = UILabel(frame: CGRect(x: 0, y: img.maxY, width: btnW, height: labH))
//            lab.font = UIFont.systemFont(ofSize: 12)
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
            }else{//单行
                btn.frame = CGRect(x: x, y: y, width: btnW, height: btnH)
            }
            bottomView.addSubview(btn)
        }
        bottomViewH.constant = y + btnH + 15
    }

}




