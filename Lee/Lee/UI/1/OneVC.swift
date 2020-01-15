//
//  OneVC.swift
//  Lee
//
//  Created by yimi on 2019/11/5.
//  Copyright © 2019 baymax. All rights reserved.
//

import UIKit
import Hero
import CollectionKit
import Kingfisher
import LTMorphingLabel

class OneVC: BaseVC{

    @IBOutlet weak var newsBGView: UIView!
    var newsCollection:CollectionView!
    var newsArr:Array<IdailyNewsModel>!
    var willScrollX:CGFloat = 0
    
    
    var weatherModel:WeatherToday!
    @IBOutlet weak var weatherBgView: UIView!
    @IBOutlet weak var weatherImgView: UIImageView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        get{ return .lightContent}
    }
    
    @IBOutlet weak var titleLab: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 新闻
        initNews()
        // 天气
        initWeather()
    }

}

// 新闻
extension OneVC{
    // 初始化视图
    func initNews(){
        newsCollection = CollectionView(frame: CGRect(x: 15, y: 0, width: KScreenWidth+CardView.viewW+50, height: CardView.viewH))
        newsCollection.showsHorizontalScrollIndicator = false
        newsCollection.delaysContentTouches = false
        newsCollection.backgroundColor = .clear
        newsCollection.clipsToBounds = false
        newsCollection.contentInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: CardView.viewW+30+20)
        newsCollection.delegate = self
        newsBGView.addSubview(newsCollection);
        newsBGView.addAlphaGradientHori(KScreenWidth-20, KScreenWidth-10,CGRect(x: 0, y: 0, width: KScreenWidth, height: 400))
        self.requestNews()
    }
    // 请求
    func requestNews(){
        let list = Cache[.newsList]
        if list.notEmpty(){
            self.newsArr = list
            self.loadData()
            if let first = self.newsArr.first{
                let date = (first.pubdate_timestamp + 24*60*60).toDate()
                let now = Date()
                if date.toString("yyyy-MM-dd") == now.toString("yyyy-MM-dd"){
                    return
                }}}
        var param = [String : Any]()
        param["page"] = 1
        param["ver"] = "iphone"
        param["app_ver"] = "113"
        param["app_timestamp"] = Int(NSDate().timeIntervalSince1970)
        Network.baseRequestArray(NewsApi.news, params: param, IdailyNewsModel.self) { (resp) in
            self.newsArr = resp;
            for i in (0..<self.newsArr.count).reversed(){
                let m = self.newsArr[i]
                if m.cat.toInt() != 6{
                    self.newsArr.remove(at: i)
                    continue}
            }
            Cache[.newsList] = self.newsArr
            self.loadData()
        }
    }
    
    // 刷新显示
    func loadData(){
        if newsCollection.provider == nil{
            let dataSource = ArrayDataSource<Int>(data: Array(0..<30))
            let viewSource = ClosureViewSource(viewUpdater: { (view: RoundedCardWrapperView, data: Int, index: Int) in
                let model = self.newsArr.bm_object(index)
                view.cardView.titleLabel.text = model?.ui_sets["caption_subtitle"] ?? ""
                view.cardView.subtitleLabel.text = model?.location ?? ""
                view.cardView.imageView.kf.setImage(with: model?.bigImg.resource, placeholder: UIImage(named: "temp"), options: [.transition(.fade(0.5))])
                view.cardView.tagLab.text = model?.tags.bm_object(0)?["name"] as? String
                
                view.cardView.timeLab.text = model?.title ?? ""
                
                view.cardView.updateFrame()
                view.alpha = 0;
            })
            
            let sizeSource = { (index: Int, data: Int, collectionSize: CGSize) -> CGSize in
                return CGSize(width: CardView.viewW, height: CardView.viewH)}
            
            let layout = RowLayout(fillIdentifiers: ["horizontal"],
                                   spacing: 0,
                                   justifyContent: .center,
                                   alignItems: .center)
            let provider = BasicProvider<Int, RoundedCardWrapperView>(
                dataSource: dataSource,
                viewSource: viewSource,
                sizeSource: sizeSource,
                layout:     layout,
                animator:   EdgeShrinkAnimator(),
                tapHandler: { (context) in
                    self.cellTapped(cell: context.view, data: context.data)
            }
            )
            newsCollection.provider = provider
        }else{
            newsCollection.reloadData()
        }
    }
    
    // 点击事件
    func cellTapped(cell: RoundedCardWrapperView, data: Int) {
        let model = self.newsArr.bm_object(data)
        cell.cardView.hero.modifiers = [.useNoSnapshot, .spring(stiffness: stiffness, damping: damping)]
        cell.cardView.imageView.hero.id = model!.heroId + "image"
        cell.cardView.titleLabel.hero.id = model!.heroId + "title"
        cell.cardView.locImg.hero.id = model!.heroId + "locImg"
        cell.cardView.subtitleLabel.hero.id = model!.heroId + "subtitleLabel"
        
        cell.cardView.timeLab.hero.id = model!.heroId + "time"
        cell.cardView.tagLab.hero.id = model!.heroId + "tag"
        
        let vc = NewsDetailCollectionVC()
        vc.selectedIndex = data
        vc.loadData(self.newsArr)
        vc.hero.isEnabled = true
        vc.hero.modalAnimationType = .none
        vc.visualEffectView.hero.modifiers = [.fade, .useNoSnapshot, .spring(stiffness: stiffness, damping: damping)]
        present(vc, animated: true, completion: nil)
    }
}


/// 天气
extension OneVC{
    
    func initWeather() {
        self.requestWeather()
        
    }
    
    func requestWeather(){
        Network.requestModel(WeatherApi.city("101030100"), model: WeatherToday.self) { (resp) in
            self.weatherModel = resp.data!
            print(self.weatherModel.forecast)
        }
    }
    
    func loadWeather(){
        
    }
}

extension OneVC:UIScrollViewDelegate{
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let nowX = scrollView.contentOffset.x
        var willX = targetContentOffset.pointee.x
        if willX > nowX{
            willX = nowX + CardView.viewW / 2 - 1
        }else if willX < nowX{
            willX = nowX - CardView.viewW / 2 + 1
        }
        var x = ((willX + 15)/CardView.viewW).rounded()
        x = x * CardView.viewW - 15
        self.willScrollX = x
        
        if velocity.x == 0{
            self.pageAnim()
        }else{
            targetContentOffset.pointee.x = scrollView.contentOffset.x
            self.newsCollection.layoutSubviews()//很重要
            self.pageAnim()
        }
    }
 
    func pageAnim(){
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseInOut], animations: {
            self.newsCollection.setContentOffset(CGPoint(x: self.willScrollX, y: 0), animated: YES)
            self.newsCollection.layoutIfNeeded()
        }, completion: nil)
    }
    
}



