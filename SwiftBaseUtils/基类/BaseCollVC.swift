//
//  BaseCollVC.swift
//  WangFuRefuel
//
//  Created by 蔡林海 on 2020/11/10.
//  Copyright © 2020 蔡林海. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import MJRefresh

class BaseCollVC: BaseVC {
    
    var collectionView: UICollectionView?
    var pageNo = 1
    var PageSize = KPageSize
    var dataArr:Array<Any>! = []
    var param = Dictionary<String,Any>()
    
    var indicatorView :BMIndicatorView!
    
    var footNoDataText:String = ""
    
    // cell显示的时候是否显示加载动画
    var needOpenCellShowAnimation:Bool = false
    
    // 请求失败是否提示错误
    var showRequestError:Bool = false
    // 是否缓存 有值就缓存 没有就不缓存
    var listCacheKey:String?
    
    lazy var foot: MJRefreshAutoNormalFooter = {
        let foot = MJRefreshAutoNormalFooter()
        foot.setRefreshingTarget(self, refreshingAction: #selector(BaseCollVC.loadMoreData))
        foot.triggerAutomaticallyRefreshPercent = -9
        foot.stateLabel?.textColor = .KTextLightGray
        foot.setTitle("", for: .idle)
        foot.setTitle(footNoDataText, for: .noMoreData)
        return foot
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    func initCollectionView(rect:CGRect,collLayou:UICollectionViewFlowLayout) -> Void {
        collectionView = UICollectionView(frame:rect, collectionViewLayout: collLayou)
        collectionView?.backgroundColor = .white
        self.view.addSubview(collectionView!)
        self.ignoreAutoAdjustScrollViewInsets(collectionView)
        indicatorView = BMIndicatorView.showInView(view, frame: rect)
    }
    
    
    func initMJHeadView() -> Void {
        let header = MJRefreshNormalHeader()
        header.setRefreshingTarget(self, refreshingAction: #selector(BaseCollVC.loadNewData))
        header.lastUpdatedTimeLabel?.isHidden = YES
        header.stateLabel?.isHidden = YES
        collectionView?.mj_header = header
        
        collectionView?.mj_footer = foot
    }
    
    func loadNewDataWithIndicator() -> Void {
        showLoadingView()
        loadNewData()
    }
    @objc func loadNewData() -> Void {
        //记录刷新时间
        lastLoadTime = Date()
        collectionView?.mj_footer?.resetNoMoreData()
        loadData(1)
    }
    @objc func loadMoreData() -> Void {
        if self.collectionView?.mj_footer != nil && self.collectionView?.mj_footer?.state != .noMoreData{
            loadData(pageNo+1)
        }
    }
    //请求数据  重写 请求数据
    func loadData(_ page:Int) -> Void {
        return
    }
    @discardableResult
    func getList<T:HandyJSON>(key: BMApiTemplete<Array<T>?>, page:Int, finished:@escaping ()->()) -> DataRequest{
        param["pageNumber"] = page
        param["pageNo"] = page
        param["pageSize"] = PageSize
        
        let count = self.dataArr.count
        
        return network[key].request(params: param) { (resp) in
            if resp?.code == 1{
                self.pageNo = page
                
                let temp = resp!.data
                if page == 1{
                    self.dataArr = temp ?? []
                }else{
                    self.dataArr.append(contentsOf: temp ?? [])
                }
            }else if resp?.code == -1 && page == 1{
                self.dataArr = []
            }else{
                if self.showRequestError == false{
                    Hud.showText(resp?.msg ?? "")
                }
            }
            
            if resp?.code != -999{
                self.finishLoadDate(resp!.code)
                //已经有数据时的 下拉刷新 关闭渐变显示
                if count == 0 && self.dataArr.count != 0 && page == 1{
                    self.needOpenCellShowAnimation = true
                }else{
                    self.needOpenCellShowAnimation = false
                }
                
                finished()
                self.reloadData(resp!.code)
            }
        }
    }
    
    func finishLoadDate(_ code:Int) -> Void {
        if self.collectionView?.mj_header != nil {
            self.collectionView?.mj_header?.endRefreshing()
            if code == -1 || self.dataArr.count % PageSize != 0{
                self.collectionView?.mj_footer?.endRefreshingWithNoMoreData()
            }else{
                self.collectionView?.mj_footer?.endRefreshing()
            }
            
            if self.dataArr.count == 0{
                self.collectionView?.mj_footer?.endRefreshingWithNoMoreData()
            }else{
                if collectionView?.mj_footer == nil{
                    if self.dataArr.count % PageSize != 0{
                        foot.endRefreshingWithNoMoreData()
                    }
                    collectionView?.mj_footer = foot
                }
            }
        }
    }
    
    func showLoadingView() -> Void {
        self.collectionView?.isHidden = true
        indicatorView.showWait()
    }
    
    //刷新数据
    func reloadData(_ code:Int = 1) -> Void {
        if self.dataArr.count == 0 && code == -1{
            self.collectionView?.isHidden = true
            indicatorView.showNoData()
        }else{
            indicatorView.hide()
            self.collectionView?.isHidden = false
        }
        self.collectionView?.reloadData()
        
    }
}
