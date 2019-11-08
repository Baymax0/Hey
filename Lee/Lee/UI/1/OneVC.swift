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
    let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 15)
        subtitleLabel.font = UIFont.systemFont(ofSize: 12)
        imageView.contentMode = .scaleAspectFill
        
        addSubview(imageView)
        addSubview(visualEffectView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = bounds
        visualEffectView.frame = CGRect(x: 0, y: bounds.height-50, width: bounds.width, height: 50)
        titleLabel.frame = CGRect(x: 8, y: visualEffectView.y + 5, width: bounds.width - 16, height: 25)
        subtitleLabel.frame = CGRect(x: 8, y: visualEffectView.y + 30, width: bounds.width - 16, height: 16)
    }
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
        cardView.layer.cornerRadius = 16
        addSubview(cardView)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        if cardView.superview == self {
            // this is necessary because we used `.useNoSnapshot` modifier on cardView.
            // we don't want cardView to be resized when Hero is using it for transition
            cardView.frame = bounds
        }
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).cgPath
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        isTouched = true
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        isTouched = false
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        isTouched = false
    }
}

class OneVC: BaseVC{

    @IBOutlet weak var newsBGView: UIView!
    var newsCollection:CollectionView!
    var newsArr:Array<IdailyNewsModel>!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        newsCollection = CollectionView(frame: CGRect(x: 0, y: 0, width: KScreenWidth-24, height: (KScreenWidth-24-12)/2+20))
        newsCollection.showsHorizontalScrollIndicator = false
        newsCollection.isPagingEnabled = true
        newsCollection.delaysContentTouches = false
        newsCollection.backgroundColor = .KBGGray
        newsBGView.addSubview(newsCollection);
        
        self.requestNews()
    }
    
    func loadData(){
        let dataSource = ArrayDataSource<Int>(data: Array(0..<10))
        
        let viewSource = ClosureViewSource(viewUpdater: { (view: RoundedCardWrapperView, data: Int, index: Int) in
            let model = self.newsArr.bm_object(index)

            view.cardView.titleLabel.text = model?.ui_sets["caption_subtitle"] ?? ""
            view.cardView.subtitleLabel.text = model?.location ?? ""
            view.cardView.imageView.kf.setImage(with: model?.bigImg.resource, placeholder: UIImage(named: "temp"), options: [.transition(.fade(0.5))])
        })
        
        let sizeSource = { (index: Int, data: Int, collectionSize: CGSize) -> CGSize in
            let w = (KScreenWidth-24)/2-10
            return CGSize(width: w, height: w+20)
        }
        let provider = BasicProvider<Int, RoundedCardWrapperView>(
            dataSource: dataSource,
            viewSource: viewSource,
            sizeSource: sizeSource
        )
        
        provider.tapHandler = { (context) in
            self.cellTapped(cell: context.view, data: context.data)
        }
        
        provider.layout = RowLayout("RowLayout", spacing: 10)

        newsCollection.provider = provider
    }

    func requestNews(){
        var param = [String : Any]()
        param["page"] = 1
        param["ver"] = "iphone"
        param["app_ver"] = "113"
        param["app_timestamp"] = Int(NSDate().timeIntervalSince1970)
        Network.baseRequestArray(NewsApi.news, params: param, IdailyNewsModel.self) { (resp) in
            self.newsArr = resp;
            for i in (0..<self.newsArr.count).reversed(){
                let m = self.newsArr[i]
                if m.cat == "14"{
                    self.newsArr.remove(at: i)
                }
            }
            self.loadData()
//            self.newsCollection.reloadData()
        }
    }
    
    func cellTapped(cell: RoundedCardWrapperView, data: Int) {
        // MARK: Hero configuration
        let model = self.newsArr.bm_object(data)
        let cardHeroId = "card\(model!.guid ?? 1)"
        let vc = NewsDetailVC.init(nibName: "NewsDetailVC", bundle: nil)
        vc.model = model
        
        cell.cardView.hero.modifiers = [.useNoSnapshot, .spring(stiffness: 150, damping: 25)]
        cell.cardView.hero.id = cardHeroId
        
        vc.hero.isEnabled = true
        vc.hero.modalAnimationType = .none
        present(vc, animated: true, completion: nil)
    }
}
