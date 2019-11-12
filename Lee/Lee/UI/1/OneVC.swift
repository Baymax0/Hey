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

class CardView: UIView {
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    let imageView = UIImageView(image: #imageLiteral(resourceName: "montreal"))
    let locImg = UIImageView()

    required init?(coder aDecoder: NSCoder) { fatalError() }
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        self.cornerRadius = 6
        self.backgroundColor = .clear

        imageView.contentMode = .scaleAspectFill
        imageView.cornerRadius = 6
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 15)
        titleLabel.textColor = .KBlueDark
        
        subtitleLabel.font = UIFont.boldSystemFont(ofSize: 13)
        subtitleLabel.textAlignment = .right
        subtitleLabel.textColor = #colorLiteral(red: 0.685315609, green: 0.7131230235, blue: 0.754701674, alpha: 1)

        locImg.contentMode = .scaleAspectFit
        locImg.image = #imageLiteral(resourceName: "location").withRenderingMode(.alwaysTemplate)
        locImg.tintColor = #colorLiteral(red: 0.685315609, green: 0.7131230235, blue: 0.754701674, alpha: 1)
        
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(locImg)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.updateFrame()
    }
    
    func updateFrame(){
        let h:CGFloat = w / 2
        imageView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: h)
        titleLabel.frame = CGRect(x: 0, y: h+6, width: bounds.width, height: 24)
        
        let subtitleLabelW = subtitleLabel.text!.stringWidth(UIFont.boldSystemFont(ofSize: 13))+5
        subtitleLabel.frame = CGRect(x: bounds.width-subtitleLabelW, y: titleLabel.y , width: subtitleLabelW, height: 24)
        locImg.frame = CGRect(x: subtitleLabel.x-20, y: subtitleLabel.y, width: 16, height: 24)
    }
    
    static var viewH:CGFloat = {
        var h:CGFloat = (KScreenWidth-40)/2
        h = h + 6 + 24
        h = h + 15
        return h
    }()
    
}

class RoundedCardWrapperView: UIView {
    let cardView = CardView()
    
    var isTouched: Bool = false {
        didSet {
            var transform = CGAffineTransform.identity
            if isTouched { transform = transform.scaledBy(x: 0.96, y: 0.96) }
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
                self.transform = transform
            }, completion: nil)
        }
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(cardView)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        if cardView.superview == self {
            cardView.frame = bounds}
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        isTouched = true}
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        isTouched = false}
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        isTouched = false}
    
}

class OneVC: BaseVC{

    @IBOutlet weak var newsBGView: UIView!
    var newsCollection:CollectionView!
    var newsArr:Array<IdailyNewsModel>!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        newsCollection = CollectionView(frame: CGRect(x: 20, y: 0, width: KScreenWidth-40, height: (KScreenHeight-130)-KTabBarH))
        newsCollection.showsHorizontalScrollIndicator = false
        newsCollection.delaysContentTouches = false
        newsCollection.backgroundColor = .clear
        newsBGView.addSubview(newsCollection);
        
        self.requestNews()
    }
    
    func loadData(){
        if newsCollection.provider == nil{
            let dataSource = ArrayDataSource<Int>(data: Array(0..<30))
            let viewSource = ClosureViewSource(viewUpdater: { (view: RoundedCardWrapperView, data: Int, index: Int) in
                let model = self.newsArr.bm_object(index)
                view.cardView.titleLabel.text = model?.ui_sets["caption_subtitle"] ?? ""
                view.cardView.subtitleLabel.text = model?.location ?? ""
                view.cardView.imageView.kf.setImage(with: model?.bigImg.resource, placeholder: UIImage(named: "temp"), options: [.transition(.fade(0.5))])
                view.cardView.updateFrame()
            })
            
            let sizeSource = { (index: Int, data: Int, collectionSize: CGSize) -> CGSize in
                let w = KScreenWidth-40
                let h = CardView.viewH
                return CGSize(width: w, height: h)}
            
            let provider = BasicProvider<Int, RoundedCardWrapperView>(
                dataSource: dataSource,
                viewSource: viewSource,
                sizeSource: sizeSource)
            
            provider.tapHandler = { (context) in
                self.cellTapped(cell: context.view, data: context.data)}
            
            newsCollection.provider = provider
        }else{
            newsCollection.reloadData()
        }
    }

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
                }
            }
        }
        var param = [String : Any]()
        param["page"] = 1
        param["ver"] = "iphone"
        param["app_ver"] = "113"
        param["app_timestamp"] = Int(NSDate().timeIntervalSince1970)
        Network.baseRequestArray(NewsApi.news, params: param, IdailyNewsModel.self) { (resp) in
            self.newsArr = resp;
            for i in (0..<self.newsArr.count).reversed(){
                let m = self.newsArr[i]
                if m.ui_sets == nil{
                    self.newsArr.remove(at: i)
                    continue
                }
            }
            Cache[.newsList] = self.newsArr
            self.loadData()
        }
    }
    
    func cellTapped(cell: RoundedCardWrapperView, data: Int) {
        // MARK: Hero configuration
        let model = self.newsArr.bm_object(data)
//        cell.cardView.hero.id = model!.heroId
        
        cell.cardView.hero.modifiers = [.useNoSnapshot, .spring(stiffness: stiffness, damping: damping)]
        cell.cardView.imageView.hero.id = model!.heroId + "image"
        cell.cardView.titleLabel.hero.id = model!.heroId + "title"
        cell.cardView.locImg.hero.id = model!.heroId + "locImg"
        cell.cardView.subtitleLabel.hero.id = model!.heroId + "subtitleLabel"



//        vc.cardView.hero.id = cardHeroId
//        vc.cardView.hero.modifiers = [.useNoSnapshot, .spring(stiffness: stiffness, damping: damping)]
//        vc.cardView.imageView.image = cell.cardView.imageView.image
//        vc.bgView.hero.modifiers = [.source(heroID: cardHeroId), .fade, .spring(stiffness: stiffness, damping: damping)]
//
//        vc.visualEffectView.hero.modifiers = [.fade, .useNoSnapshot]
//        present(vc, animated: true, completion: nil)
        
        let vc = NewsDetailCollectionVC()
        vc.selectedIndex = data
        vc.loadData(self.newsArr)
        vc.hero.isEnabled = true
        vc.hero.modalAnimationType = .none
        vc.visualEffectView.hero.modifiers = [.fade, .useNoSnapshot, .spring(stiffness: stiffness, damping: damping)]
        present(vc, animated: true, completion: nil)
    }
    
    
}
