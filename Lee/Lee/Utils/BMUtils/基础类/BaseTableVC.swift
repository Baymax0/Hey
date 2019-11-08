//
//  BaseTableVC.swift
//  wangfuAgent
//
//  Created by lzw on 2018/7/11.
//  Copyright © 2018 zhuanbangTec. All rights reserved.
//

import UIKit

import NVActivityIndicatorView
import HandyJSON
import Alamofire
import MJRefresh


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
    var PageSize = 10
    var dataArr:Array<Any>! = []
    var param = Dictionary<String,Any>()
    
    var indicatorView :BMIndicatorView!
    
    var footNoDataText:String = ""
    
    // 请求失败是否提示错误
    var showRequestError:Bool = false
    // 是否缓存 有值就缓存 没有就不缓存
    var listCacheKey:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func initTableView(rect:CGRect ,_ style:UITableView.Style = .plain) -> Void {
        tableview = MyTableView.init(frame: rect, style: style)
        tableview?.separatorStyle = .none
        tableview?.backgroundColor = .white
        
        tableview?.estimatedRowHeight = 0;
        tableview?.estimatedSectionHeaderHeight = 0;
        tableview?.estimatedSectionFooterHeight = 0;
        
        if #available(iOS 11.0, *) {
            tableview?.contentInsetAdjustmentBehavior = .never
        }else{
            self.automaticallyAdjustsScrollViewInsets = NO
        }
        self.view.addSubview(tableview!)
        
        indicatorView = BMIndicatorView.showInView(view, frame: rect)
    }
    
    func initMJHeadView() -> Void {
        let header = MJRefreshNormalHeader()
        header.setRefreshingTarget(self, refreshingAction: #selector(BaseTableVC.loadNewData))
        header.lastUpdatedTimeLabel.isHidden = YES
        header.stateLabel.isHidden = YES
        tableview?.mj_header = header
        
        let foot = MJRefreshAutoNormalFooter()
        foot.setRefreshingTarget(self, refreshingAction: #selector(BaseTableVC.loadMoreData))
        foot.triggerAutomaticallyRefreshPercent = -9
        foot.stateLabel.textColor = .KTextLightGray
        foot.setTitle("", for: .idle)
        foot.setTitle(footNoDataText, for: .noMoreData)
        tableview?.mj_footer = foot
    }
    
    func loadNewDataWithIndicator() -> Void {
        showLoadingView()
        loadNewData()
    }
    
    @objc func loadNewData() -> Void {
        //记录刷新时间
        lastLoadTime = Date()
        loadData(1)
    }
    
    @objc func loadMoreData() -> Void {
        if self.tableview?.mj_footer != nil && self.tableview?.mj_footer.state != .noMoreData{
            loadData(pageNo+1)
        }
    }
    
    //请求数据  重写 请求数据
    func loadData(_ page:Int) -> Void {
        return
    }
    
    @discardableResult
    func getList<T:HandyJSON> (_ api:ApiManager,_ page:Int, model:T.Type, finished:@escaping ()->()) -> DataRequest{
        param["pageNumber"] = page
        param["pageNo"] = page
        param["pageSize"] = KPageSize
        return Network.requestArray(api, params: param, model: T.self) { [weak self](resp) in
            if resp.code == 1{
                let temp = resp.data
                if page == 1{
                    self?.dataArr = temp ?? Array<T>()
                }else{
                    self?.dataArr.append(contentsOf: temp ?? [])
                }
                self?.pageNo = page
            }else if resp.code == -1 && page == 1{
                self?.dataArr = Array<T>()
            }else  if resp.code != -1{
                if self?.showRequestError ?? false{
                    Hud.showText(resp.msg)
                }
            }
            if resp.code != -999{
                self?.finishLoadDate(resp.code)
                finished()
            }
        }
    }
    
    func finishLoadDate(_ code:Int) -> Void {
        
        if self.tableview?.mj_header != nil {
            self.tableview?.mj_header?.endRefreshing()
            
            if code == -1 || self.dataArr.count % KPageSize != 0{
                self.tableview?.mj_footer?.endRefreshingWithNoMoreData()
            }else{
                self.tableview?.mj_footer?.endRefreshing()
            }
            
            if self.dataArr.count == 0{
                self.tableview?.mj_footer?.endRefreshingWithNoMoreData()
            }else{
                if tableview?.mj_footer == nil{
                    let foot = MJRefreshAutoNormalFooter()
                    foot.setRefreshingTarget(self, refreshingAction: #selector(BaseTableVC.loadMoreData))
                    foot.triggerAutomaticallyRefreshPercent = -9
                    foot.stateLabel.textColor = .KTextLightGray
                    foot.setTitle(footNoDataText, for: .noMoreData)
                    if self.dataArr.count % KPageSize != 0{
                        foot.endRefreshingWithNoMoreData()
                    }
                    tableview?.mj_footer = foot
                }
            }
        }
    }
    
    func showLoadingView() -> Void {
        indicatorView.showWait()
    }
    
    //刷新数据
    func reloadData(_ code:Int = 1) -> Void {
        if self.dataArr.count == 0{
            indicatorView.showNoData()
        }else{
            indicatorView.hide()
        }
        self.tableview?.reloadData()
    }
}



