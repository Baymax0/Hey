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
import MJRefresh


class ListModel: HandyJSON {
    required init() {}
}

class BaseTableVC: BaseVC{

    var tableview: UITableView?
    var pageNo = 1
    var PageSize = 10
    var dataArr:Array<Any>! = []
    var param = Dictionary<String,Any>()

    private var activityIndicatorView:NVActivityIndicatorView?
    private var activityIndicatorLab:UILabel?

    private var noDataPlaceView:UIView?
    private var noDataPlaceImgView:UIImageView?
    private var noDataPlaceLab:UILabel?

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
            self.noDataPlaceView?.center = self.tableview!.center

            self.noDataPlaceImgView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: w, height: w-90))
            self.noDataPlaceImgView?.image = UIImage(named: newValue!)
            self.noDataPlaceImgView?.contentMode = .scaleAspectFit
            self.noDataPlaceView?.addSubview(self.noDataPlaceImgView!)

            self.noDataPlaceLab = UILabel(frame: CGRect(x: 0, y: w-90, width: w, height: 50))
            self.noDataPlaceLab?.text = ""
            self.noDataPlaceLab?.numberOfLines = 0
            self.noDataPlaceLab?.textAlignment = .center
            self.noDataPlaceLab?.font = UIFont.systemFont(ofSize: 17)
            self.noDataPlaceLab?.textColor = KBlack_178
            self.noDataPlaceView?.addSubview(self.noDataPlaceLab!)

            self.noDataPlaceView!.isHidden = YES
            self.view .insertSubview(self.noDataPlaceView!, at: 0)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    func initTableView(rect:CGRect ,_ style:UITableViewStyle = .plain) -> Void {
        tableview = UITableView.init(frame: rect, style: style)
        tableview?.separatorStyle = .none
        tableview?.backgroundColor = .white

        if #available(iOS 11.0, *) {
            tableview?.contentInsetAdjustmentBehavior = .never
        }else{
            self.automaticallyAdjustsScrollViewInsets = NO
        }
        self.view.addSubview(tableview!)

        var w = CGFloat(35)
        var rect = CGRect(x: (KScreenWidth-w)/2, y: (self.tableview!.frame.size.height-w)/2, width: w, height: w)
        activityIndicatorView = NVActivityIndicatorView(frame: rect,
                                                        type: NVActivityIndicatorType(rawValue: 17)!)
        activityIndicatorView?.color = KBlack_178
        view.addSubview(activityIndicatorView!)

        w = CGFloat(70)
        rect = CGRect(x: (KScreenWidth-w)/2, y: (self.tableview!.frame.size.height+w)/2+4, width: w, height: 20)
        activityIndicatorLab = UILabel(frame: rect)
        activityIndicatorLab?.text = ""
        activityIndicatorLab?.textAlignment = .center
        activityIndicatorLab?.font = UIFont.systemFont(ofSize: 15)
        activityIndicatorLab?.textColor = KBlack_178
        activityIndicatorLab?.isHidden = YES
        view.addSubview(activityIndicatorLab!)

    }

    func initMJHeadView() -> Void {
        let header = MJRefreshNormalHeader()
        header.setRefreshingTarget(self, refreshingAction: #selector(BaseTableVC.loadNewData))
        header.lastUpdatedTimeLabel.isHidden = YES
        header.stateLabel.isHidden = YES
        tableview?.mj_header = header
    }

    func initMJFootView() -> Void {
        let foot = MJRefreshAutoNormalFooter()
        foot.setRefreshingTarget(self, refreshingAction: #selector(BaseTableVC.loadMoreData))
        tableview?.mj_footer = foot
    }

    func loadNewDataWithIndicator() -> Void {
        showLoadingView()
        loadNewData()
    }

    @objc func loadNewData() -> Void {
        loadData(1)
    }
    @objc func loadMoreData() -> Void {
        loadData(pageNo+1)
    }

    //请求数据
    func loadData(_ index:Int) -> Void {
        return
    }

    func showLoadingView() -> Void {
        self.tableview?.isHidden = YES
        self.noDataPlaceView?.isHidden = YES
        //显示加载数据 等待框
        self.activityIndicatorView?.startAnimating()
        self.activityIndicatorLab?.isHidden = NO
    }

    //刷新数据
    func reloadData() -> Void {
        self.tableview?.isHidden = NO;
        self.activityIndicatorView?.stopAnimating()
        self.activityIndicatorLab?.isHidden = YES

        if self.dataArr.count == 0, noDataPlaceImage != nil{
            self.noDataPlaceView?.isHidden = NO
        }else{
            self.noDataPlaceView?.isHidden = YES
        }
        self.tableview?.reloadData()
    }
}



