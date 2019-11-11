//
//  NewsDetailCollectionVC.swift
//  Lee
//
//  Created by yimi on 2019/11/11.
//  Copyright © 2019 baymax. All rights reserved.
//

import UIKit
import Hero
import Kingfisher
import CollectionKit

class NewsCollectView: UIView {
    
    let cardView = CardView()

    required init?(coder aDecoder: NSCoder) { fatalError() }
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        self.backgroundColor = #colorLiteral(red: 0.1450774968, green: 0.1451098621, blue: 0.1450754404, alpha: 1)
        cardView.layer.cornerRadius = 0;
        cardView.visualEffectView.alpha = 0;
        addSubview(cardView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let bound = bounds
        if let _ = cardView.imageView.image{
            let imgH = cardView.imageView.image?.size.height ?? 1
            let imgW = cardView.imageView.image?.size.width ?? 1
            let h = imgH / imgW * bound.width
            cardView.frame = CGRect(x: 0, y: 80, width: bound.width, height:  h)
        }

    }
}

class NewsDetailCollectionVC: BaseVC {

    // 背景 过度中虚化用
    let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    var finishHero = false;
    var newsCollection:CollectionView!
    var newsArr:Array<IdailyNewsModel>!
    
    var selectedIndex:Int = 0
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent}
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
        
    }
    
    func loadData(_ modelArr : Array<IdailyNewsModel>!){
        self.newsArr = modelArr
        initUI()
    }
    
    func initUI(){
        view.insertSubview(visualEffectView, at: 0)
        
        newsCollection = CollectionView(frame: CGRect(x: 0, y: 0, width: KScreenWidth, height: KScreenHeight))
        newsCollection.showsHorizontalScrollIndicator = false
        newsCollection.isPagingEnabled = true
        newsCollection.delaysContentTouches = false
        newsCollection.backgroundColor = .clear
        newsCollection.contentInsetAdjustmentBehavior = .never
        view.addSubview(newsCollection);
        
        // 添加边缘手势
        let ges = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleBackGes(gr:)))
        ges.edges = .left
        newsCollection.addGestureRecognizer(ges)
        
        
        let dataSource = ArrayDataSource<Int>(data: Array(0..<30))
        let viewSource = ClosureViewSource(viewUpdater: { (view: NewsCollectView, data: Int, index: Int) in
            let model = self.newsArr.bm_object(index)

            view.cardView.imageView.kf.setImage(with: model?.bigImg.resource, placeholder: UIImage(named: "temp"), options: [.transition(.fade(0.5))])
            
            let cardHeroId = "card\(model!.guid ?? 1)"
            view.cardView.hero.id = cardHeroId
            view.cardView.hero.modifiers = [.useNoSnapshot, .spring(stiffness: stiffness, damping: damping)]
            view.hero.modifiers = [.source(heroID: cardHeroId), .fade, .spring(stiffness: stiffness, damping: damping)]
            
        })
        
        let sizeSource = { (index: Int, data: Int, collectionSize: CGSize) -> CGSize in
            return CGSize(width: KScreenWidth, height: KScreenHeight)
        }
        
        let provider = BasicProvider<Int, NewsCollectView>(
            dataSource: dataSource,
            viewSource: viewSource,
            sizeSource: sizeSource
        )
        provider.layout = RowLayout("RowLayout", spacing: 0)
        newsCollection.provider = provider
        newsCollection.reloadData()
        newsCollection.setContentOffset(CGPoint(x: KScreenWidth * CGFloat(selectedIndex), y: 0), animated: false)
    }
    

    @objc func handleBackGes(gr: UIScreenEdgePanGestureRecognizer) {
        if finishHero{
            return
        }
        switch gr.state {
        case .began:
            dismiss(animated: true, completion: nil)
        case .changed:
            var progress = gr.translation(in: nil).x / view.bounds.width
            progress = progress < 0.001 ? 0.001: progress;
            if progress > 0.1{
                self.finishHero = true
                Hero.shared.finish()
            }else{
                Hero.shared.update(progress)
            }
        default:
            if (gr.translation(in: nil).x + gr.velocity(in: nil).x) / view.bounds.width > 0.5 {
                self.finishHero = true
                Hero.shared.finish()
            } else {
                Hero.shared.cancel()
            }
        }
    }

}
