//
//  BaseCollectionVC.swift
//  MySugarHeap
//
//  Created by lzw on 2018/8/23.
//  Copyright © 2018 lizhiwei. All rights reserved.
//

import UIKit
import MJRefresh
import NVActivityIndicatorView

class BaseCollectionVC: BaseVC,MyCollectionViewLayoutDelegate,UICollectionViewDataSource {
    var dataArr:Array<BMImage>! = []

    var collectionView :UICollectionView!
    let header = MJRefreshNormalHeader()//顶部刷新
    let footer = MJRefreshAutoNormalFooter()//底部刷新

    private var activityIndicatorView:NVActivityIndicatorView?
    private var activityIndicatorLab:UILabel?

    private var noDataPlaceView:UIView?
    private var noDataPlaceImgView:UIImageView?
    private var noDataPlaceLab:UILabel?

    let cellID = "cellID"
    //设置 即 启用
    var noDataPlaceImage:String?{
        get{
            if self.noDataPlaceImgView == nil {
                return nil
            }else{
                return "1"
            }
        }
        set{
            let w = CGFloat(180)
            self.noDataPlaceView = UIView(frame: CGRect(x: 0, y: 0, width: w, height: w))
            self.noDataPlaceView?.center = self.collectionView!.center

            self.noDataPlaceImgView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: w, height: w-90))
            self.noDataPlaceImgView?.image = UIImage(named: newValue!)
            self.noDataPlaceImgView?.contentMode = .scaleAspectFit
            self.noDataPlaceView?.addSubview(self.noDataPlaceImgView!)

            self.noDataPlaceLab = UILabel(frame: CGRect(x: 0, y: w-90, width: w, height: 50))
            self.noDataPlaceLab?.text = "没有搜索结果 o(╥﹏╥)o"
            self.noDataPlaceLab?.numberOfLines = 0
            self.noDataPlaceLab?.textAlignment = .center
            self.noDataPlaceLab?.font = UIFont.systemFont(ofSize: 16)
            self.noDataPlaceLab?.textColor = KBlack_178
            self.noDataPlaceView?.addSubview(self.noDataPlaceLab!)

            self.noDataPlaceView!.isHidden = YES
            self.view .insertSubview(self.noDataPlaceView!, at: 0)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func initCollectionView(rect:CGRect) -> Void {
        let layout = MyCollectionViewLayout()
        layout.delegate = self
        collectionView = UICollectionView(frame:rect, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = KBGGray
        collectionView.register(UINib(nibName: "ImageFlowCollectionCell", bundle: nil), forCellWithReuseIdentifier: cellID)
        collectionView.delaysContentTouches = false

        header.setRefreshingTarget(self, refreshingAction:#selector(loadNewData))
        header.lastUpdatedTimeLabel.isHidden = true
        header.stateLabel.isHidden = true
        header.stateLabel.textColor = KRGB(153, 153, 153)
        collectionView.mj_header = header

        footer.setRefreshingTarget(self, refreshingAction:#selector(loadMoreData))
        view.addSubview(collectionView)

        var w = CGFloat(35)
        var rect = CGRect(x: (KScreenWidth-w)/2, y: (collectionView!.frame.size.height-w)/2, width: w, height: w)
        activityIndicatorView = NVActivityIndicatorView(frame: rect,
                                                        type: NVActivityIndicatorType(rawValue: 17)!)
        activityIndicatorView?.color = KBlack_178
        view.addSubview(activityIndicatorView!)

        w = CGFloat(70)
        rect = CGRect(x: (KScreenWidth-w)/2, y: (collectionView!.frame.size.height+w)/2+4, width: w, height: 20)
        activityIndicatorLab = UILabel(frame: rect)
        activityIndicatorLab?.text = "加载中.."
        activityIndicatorLab?.textAlignment = .center
        activityIndicatorLab?.font = UIFont.systemFont(ofSize: 15)
        activityIndicatorLab?.textColor = KBlack_178
        activityIndicatorLab?.isHidden = YES
        view.addSubview(activityIndicatorLab!)
    }

    func haveMoreData(_ have:Bool){
        if have {
            collectionView.mj_footer = footer
        }else{
            collectionView.mj_footer = nil
        }
    }

    //第一次请求数据调用
    func loadNewDataWithIndicator() -> Void {
        showLoadingView()
        loadNewData()
    }
    @objc func loadNewData() -> Void {
        loadData(0)
    }
    @objc func loadMoreData() -> Void {
        loadData(2)
    }
    //请求数据
    func loadData(_ index:Int) -> Void {
        return
    }

    //collectionView数据源设置
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    //给layout高度，根据比例计算
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! ImageFlowCollectionCell
        cell.indexPath = indexPath
        let mod = self.dataArr[indexPath.item]
        cell.setData(mod)
        return cell
    }
    //layout代理
    func waterFallLayout(layout:UICollectionViewFlowLayout, index:NSInteger, width: CGFloat) -> CGFloat {
        return ImageFlowCollectionCell.getHeight(self.dataArr[index])
    }

    func columnCountOfWaterFallLayout(layout:UICollectionViewFlowLayout) ->NSInteger {
        return 2
    }


    //////////////////

    func showLoadingView() -> Void {
        self.collectionView?.isHidden = YES
        self.noDataPlaceView?.isHidden = YES
        //显示加载数据 等待框
        self.activityIndicatorView?.startAnimating()
        self.activityIndicatorLab?.isHidden = NO
    }

    func reloadData() -> Void {
        self.collectionView?.isHidden = NO;
        self.activityIndicatorView?.stopAnimating()
        self.activityIndicatorLab?.isHidden = YES

        if collectionView.mj_header != nil {
            collectionView.mj_header.endRefreshing()
        }
        if collectionView.mj_footer != nil {
            collectionView.mj_footer.endRefreshing()
        }
        if self.dataArr.count == 0, noDataPlaceImage != nil{
            self.noDataPlaceView?.isHidden = NO
        }else{
            self.noDataPlaceView?.isHidden = YES
        }
        self.collectionView.reloadData()
    }

}
extension BaseCollectionVC:UIScrollViewDelegate,UICollectionViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        for cell in collectionView.visibleCells{
            (cell as! ImageFlowCollectionCell).select = false
        }
    }
}
