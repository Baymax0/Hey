//
//  DTResultVC.swift
//  LisApp
//
//  Created by yimi on 2019/2/27.
//  Copyright © 2019 baymax. All rights reserved.
//

import UIKit
import Masonry

class DTResultVC: BaseCollectionVC {
    
    // 需要传的参数
    var param = Dictionary<String,Any>()
    
    var api:DTApiManager!
    
    var start:Int = 0
    weak var selectedCell : ImageFlowCollectionCell?
    
    @IBOutlet weak var titleLab: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideNav = true
        titleLab.text = self.title
        initCollectionView(rect: CGRect(x: 0, y: 64, width: KScreenWidth, height: view.frame.height - 64))

        loadNewDataWithIndicator()
        addSlideBack(view)
    }
    
//    override func viewWillLayoutSubviews() {
//        super.viewWillLayoutSubviews()
//        self.collectionView.mas_makeConstraints { (make) in
//            make?.top.offset()(64)
//            make?.bottom.offset()(0)
//            make?.width.equalTo()(KScreenWidth)
//            make?.height.equalTo()(KScreenHeight)
//        }
//        self.collectionView.reloadData()
//    }
    
    @objc override func loadMoreData() -> Void {
        loadData(start)
    }

    override func loadData(_ index: Int) {
        param["start"] = index
        Network.requestDT(api:api, params: param, model: DTList<DTImgListModel>.self) { (resp) in
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

}
