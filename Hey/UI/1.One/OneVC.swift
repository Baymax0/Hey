//
//  OneVC.swift
//  Lee
//
//  Created by yimi on 2019/11/5.
//  Copyright © 2019 baymax. All rights reserved.
//

import UIKit
import LTMorphingLabel

class OneVC: BaseVC{
    
    var page = 0
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        get{ return .default }
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    var oneAppInfoArr:Array<One_Feed_Model>!
    
    var isRequest:Bool = false
    var currentIndex = -1
    
    @IBOutlet weak var timeLab1: LTMorphingLabel!
    let timeLab1_1 = LTMorphingLabel()

    @IBOutlet weak var timeLab2: LTMorphingLabel!
    let timeLab2_1 = LTMorphingLabel()

    var indicatorView :BMIndicatorView!
    
    var isRequestingDic:Dictionary<String,Bool> = [:]
    
    override func viewDidLoad() {
        self.view.backgroundColor = .KBGGray
        collectionView.backgroundColor = .KBGGray
        self.hideNav = true
        oneAppInfoArr = []
        
        self.initUI()
        self.setTime(0)
        
        self.requestOneAppInfo()
        
        timeLab1_1.morphingEnabled = true
        timeLab1_1.morphingEffect = .evaporate
        timeLab1_1.font = timeLab1.font
        timeLab1_1.frame = timeLab1.frame
        timeLab1.superview!.addSubview(timeLab1_1)
        
        timeLab2_1.morphingEnabled = true
        timeLab2_1.morphingEffect = .evaporate
        timeLab2_1.font = timeLab2.font
        timeLab2_1.frame = timeLab2.frame
        timeLab1.superview!.addSubview(timeLab2_1)
        
        indicatorView = BMIndicatorView.showInView(view, frame: collectionView.frame)
        indicatorView.showWait()
        indicatorView.requestImageName = "nonetwork"
        indicatorView.requestBtn.addTarget(self, action: #selector(requestOneAppInfo), for: .touchUpInside)

//        let tap = UITapGestureRecognizer(target: self, action: #selector(requestOneAppInfo))
//        self.indicatorView.contentImgView.addGestureRecognizer(tap)
    }
    
    func setTime(_ timeIndex:Int) {
        if timeIndex == currentIndex{
            return
        }
        var time = Date().timeIntervalSince1970
        time = time - Double(timeIndex * 3600 * 24)
        let date = Date(timeIntervalSince1970: time)
        timeLab1_1.text = date.dayString
        
        let month = date.monthString.toInt() - 1
        let year = date.yearString
        let arr = ["Jan.","Feb.","Mar.","Apr.","May.","Jun.","Jul.","Aug.","Sept.","Oct.","Nov.","Dec."]
        timeLab2_1.text = arr[month] + year
    }
    
    func initUI() {
        collectionView.register(UINib(nibName: "OneInfoCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        collectionView.dataSource = self as UICollectionViewDataSource
        collectionView.delegate = self as UICollectionViewDelegate
    }
    
    @objc func requestOneAppInfo() {
        guard isRequest == false else { return }
        
        let time = Date() - page.months
        let timeR = time.toString("yyyy-MM")
        
        let dic = cache[.oneRequestDic]
        isRequest = true
        network.oneApp_Main_List(month: timeR).request(params: dic, finish: { (resp) in
            if(resp?.data != nil){
                self.oneAppInfoArr.append(contentsOf: resp!.data!)
                self.page += 1
            }
            self.isRequest = false
            self.collectionView.reloadData()
            if self.oneAppInfoArr.count == 0{
                self.indicatorView.showRequest()
            }else{
                self.indicatorView.hide()
            }
        })
    }
    
    @objc func requestOne_Day_Info(_ time:String!, _ item:IndexPath) {
        if isRequestingDic[time] == true{ return }

        isRequestingDic[time] = true
        let dic = cache[.oneRequestDic]
        network.oneApp_Main_Info(day: time).request(params: dic) { (resp) in
            if resp?.data != nil{
                RealmManager.ONE.save(resp?.data)
                self.collectionView.reloadItems(at: [item])
            }else{
                self.isRequestingDic[time] = false
            }
        }
    }
    
    
    
}

extension OneVC : UICollectionViewDataSource , UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return oneAppInfoArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : OneInfoCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! OneInfoCell
        print("--------")
        var date1 = Date()
        var date2 = Date()
        var date3 = Date()
        print(date2.toTimeInterval() - date1.toTimeInterval())
        if let feed = self.oneAppInfoArr.bm_object(indexPath.item){
            cell.imgView.kf.setImage(with: feed.cover.resource, placeholder: UIImage(named: "placeholder"), options:  [.transition(.fade(0.45))])
            cell.vc = self
                    
            if let m = RealmManager.ONE.getfeedDetail(feed.date){
                date2 = Date()
                print("realm  :\(date2.toTimeInterval() - date1.toTimeInterval())")
                cell.setData(m)
                date3 = Date()
                print("setData:\(date3.toTimeInterval() - date2.toTimeInterval())")
            }else{
                cell.setData(nil)
                self.requestOne_Day_Info(feed.date, indexPath)
            }
            
            cell.imgViewButton.tag = indexPath.item
            cell.imgViewButton.addTarget(self, action: #selector(imgViewClickAction(_:)), for: .touchUpInside)
        }
        let date4 = Date()
        print("all    :\(date4.toTimeInterval() - date1.toTimeInterval())")
        //获得详细资料
        return cell
    }
    
    @objc func imgViewClickAction(_ btn:UIButton) {
        let index = IndexPath(item: btn.tag, section: 0)
        
        let cell = collectionView.cellForItem(at: index) as! OneInfoCell
        if (cell.imgView.image != nil){
            self.previewImage(cell.imgView.image)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let cur = Int(scrollView.contentOffset.x + 180) / Int(KScreenWidth)
        self.setTime(cur)
        //再往前请求一个月
        if cur >= self.oneAppInfoArr.count - 4{
            self.requestOneAppInfo()
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size = self.collectionView.bounds.size
        //简单适配ipad
        if KScreenWidth > 500{
            size.width = 500
        }
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
}




