//
//  BaseTableVC.swift
//  wangfuAgent
//
//  Created by lzw on 2018/7/11.
//  Copyright © 2018 zhuanbangTec. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import MJRefresh
import Alamofire
import Alamofire

class ListModel: HandyJSON {
    required init() {}
}

class MyTableView: UITableView ,UIGestureRecognizerDelegate{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return YES
    }
}

class BaseTableVC: BaseVC {
    
    var tableview: MyTableView?
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    lazy var foot: MJRefreshAutoNormalFooter = {
        let foot = MJRefreshAutoNormalFooter()
        foot.setRefreshingTarget(self, refreshingAction: #selector(BaseTableVC.loadMoreData))
        foot.triggerAutomaticallyRefreshPercent = -9
        foot.stateLabel?.textColor = .KTextLightGray
        foot.setTitle("", for: .idle)
        foot.setTitle(footNoDataText, for: .noMoreData)
        return foot
    }()
    
    func initTableView(rect:CGRect ,_ style:UITableView.Style = .plain) -> Void {
        tableview = MyTableView.init(frame: rect, style: style)
        tableview?.separatorStyle = .none
        tableview?.backgroundColor = .white
        
        tableview?.estimatedRowHeight = 0
        tableview?.estimatedSectionHeaderHeight = 0
        tableview?.estimatedSectionFooterHeight = 0
        self.view.addSubview(tableview!)
        self.ignoreAutoAdjustScrollViewInsets(tableview)
        
        indicatorView = BMIndicatorView.showInView(view, frame: rect)
    }
    
    
    func initMJHeadView() -> Void {
        let header = MJRefreshNormalHeader()
        header.setRefreshingTarget(self, refreshingAction: #selector(BaseTableVC.loadNewData))
        header.lastUpdatedTimeLabel?.isHidden = YES
        header.stateLabel?.isHidden = YES
        tableview?.mj_header = header
        
        tableview?.mj_footer = foot
    }
    
    func loadNewDataWithIndicator() -> Void {
        showLoadingView()
        loadNewData()
    }
    
    @objc func loadNewData() -> Void {
        //记录刷新时间
        lastLoadTime = Date()
        tableview?.mj_footer?.resetNoMoreData()
        loadData(1)
    }
    
    @objc func loadMoreData() -> Void {
        if self.tableview?.mj_footer != nil && self.tableview?.mj_footer?.state != .noMoreData{
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
        if self.tableview?.mj_header != nil {
            self.tableview?.mj_header?.endRefreshing()
            if code == -1 || self.dataArr.count % PageSize != 0{
                self.tableview?.mj_footer?.endRefreshingWithNoMoreData()
            }else{
                self.tableview?.mj_footer?.endRefreshing()
            }
            
            if self.dataArr.count == 0{
                self.tableview?.mj_footer?.endRefreshingWithNoMoreData()
            }else{
                if tableview?.mj_footer == nil{
                    if self.dataArr.count % PageSize != 0{
                        foot.endRefreshingWithNoMoreData()
                    }
                    tableview?.mj_footer = foot
                }
            }
        }
    }
    
    func showLoadingView() -> Void {
        self.tableview?.isHidden = true
        indicatorView.showWait()
    }
    
    //刷新数据
    func reloadData(_ code:Int = 1) -> Void {
        if self.dataArr.count == 0 && code == -1{
            self.tableview?.isHidden = true
            indicatorView.showNoData()
        }else{
            indicatorView.hide()
            self.tableview?.isHidden = false
        }
        self.tableview?.reloadData()
        
    }
}



