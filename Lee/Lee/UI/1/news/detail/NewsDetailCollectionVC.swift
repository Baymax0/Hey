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
import LTMorphingLabel

class NewsCollectView: UIView {
    
    let timeLabel = UILabel()
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    let imageView = UIImageView()
    let locImg = UIImageView()
    let contentTV = UITextView()

    required init?(coder aDecoder: NSCoder) { fatalError() }
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        self.backgroundColor = #colorLiteral(red: 0.1450774968, green: 0.1451098621, blue: 0.1450754404, alpha: 1)
        self.backgroundColor = .clear
        timeLabel.font = UIFont(name: "Futura-Medium", size: 14)
        timeLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        subtitleLabel.font = UIFont.boldSystemFont(ofSize: 13)
        subtitleLabel.textAlignment = .right
        subtitleLabel.textColor = #colorLiteral(red: 0.685315609, green: 0.7131230235, blue: 0.754701674, alpha: 1)
        
        imageView.contentMode = .scaleAspectFill
        
        locImg.contentMode = .scaleAspectFit
        locImg.image = #imageLiteral(resourceName: "location").withRenderingMode(.alwaysTemplate)
        locImg.tintColor = #colorLiteral(red: 0.685315609, green: 0.7131230235, blue: 0.754701674, alpha: 1)
        
        contentTV.isEditable = false
        contentTV.backgroundColor = .clear
        
//      addSubview(timeLabel)
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(locImg)
        addSubview(contentTV)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.updateFrame()
    }
    
    func updateFrame(){
        let bound = bounds
        if let _ = imageView.image{
            //shijian
            timeLabel.frame = CGRect(x: 20, y: 50, width: 140, height:  30)
            // 图片
            imageView.frame = CGRect(x: 0, y: 80, width: bound.width, height:  bound.width * 2 / 3)
            // 标题
            titleLabel.frame = CGRect(x: 20, y: imageView.maxY+10, width: bounds.width, height: 24)
            // 位置
            let subtitleLabelW = subtitleLabel.text!.stringWidth(UIFont.boldSystemFont(ofSize: 13))+5
            subtitleLabel.frame = CGRect(x: bounds.width-subtitleLabelW-20, y: titleLabel.y , width: subtitleLabelW, height: 24)
            locImg.frame = CGRect(x: subtitleLabel.x-20, y: subtitleLabel.y, width: 16, height: 24)

            let contentTVY = titleLabel.maxY+1
            contentTV.frame = CGRect(x: 13, y: contentTVY, width: KScreenWidth-26, height: KScreenHeight-contentTVY)
        }
    }
}


class NewsDetailCollectionVC: BaseVC {
    
    var titleView = UIView()
//    let timeLabel = UILabel()
    let timeLabel = LTMorphingLabel()
    let tagLab = LTMorphingLabel()

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
        self.view.backgroundColor = .clear

        visualEffectView.frame = CGRect(x: 0, y: 0, width: KScreenWidth, height: KScreenHeight)
        view.insertSubview(visualEffectView, at: 0)
        
        let v = UIView(frame: self.view.bounds)
        v.backgroundColor = #colorLiteral(red: 0.1450774968, green: 0.1451098621, blue: 0.1450754404, alpha: 1)
        v.hero.modifiers = [.fade, .spring(stiffness: stiffness, damping: damping)]
        view.addSubview(v)
        
        newsCollection = CollectionView(frame: CGRect(x: 0, y: 0, width: KScreenWidth, height: KScreenHeight))
        newsCollection.showsHorizontalScrollIndicator = false
        newsCollection.isPagingEnabled = true
        newsCollection.delaysContentTouches = false
        newsCollection.backgroundColor = .clear
        newsCollection.contentInsetAdjustmentBehavior = .never
        view.addSubview(newsCollection);
        
        // 添加边缘手势
        let gesView = UIView(frame: CGRect(x: -5, y: 80, width: 50, height: KScreenHeight))
        gesView.backgroundColor = .clear
        view.addSubview(gesView)
        let ges = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleBackGes(gr:)))
        ges.edges = .left
        gesView.addGestureRecognizer(ges)
        
        let dataSource = ArrayDataSource<Int>(data: Array(0..<30))
        let viewSource = ClosureViewSource(viewUpdater: { (view: NewsCollectView, data: Int, index: Int) in
            let model = self.newsArr.bm_object(index)
            //-------- 内容 --------
            view.timeLabel.text = model?.title ?? ""
            view.imageView.kf.setImage(with: model?.bigImg.resource, placeholder: UIImage(named: "temp"), options: [.transition(.fade(0.5))])
            view.titleLabel.text = model?.ui_sets["caption_subtitle"] ?? ""
            view.subtitleLabel.text = model?.location ?? ""
            
            let content = model?.content ?? ""
            let attributedString : NSMutableAttributedString = NSMutableAttributedString(string: content)
            let paragraphStyle : NSMutableParagraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 7
            attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, (content.count)))
            attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 16.5), range: NSMakeRange(0, (content.count)))
            attributedString.addAttribute(.foregroundColor, value:  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), range: NSMakeRange(0, (content.count)))
            view.contentTV.attributedText = attributedString

            view.updateFrame()
            
            //-------- 转场动画 --------
            view.hero.modifiers = [.fade, .spring(stiffness: stiffness, damping: damping)]
//            view.hero.id = model!.heroId
            
            let imgHeroId = model!.heroId + "image"// 图片
            view.imageView.hero.id = imgHeroId
            view.imageView.hero.modifiers = [.source(heroID: imgHeroId), .spring(stiffness: stiffness, damping: damping)]
            
            view.titleLabel.hero.id = model!.heroId + "title" //title
            view.titleLabel.hero.modifiers = [.fade, .spring(stiffness: stiffness, damping: damping)]

            view.locImg.hero.id = model!.heroId + "locImg" //title
            view.locImg.hero.modifiers = [.fade, .spring(stiffness: stiffness, damping: damping)]
            
            view.subtitleLabel.hero.id = model!.heroId + "subtitleLabel" //title
            view.subtitleLabel.hero.modifiers = [.fade, .spring(stiffness: stiffness, damping: damping)]
        })
        
        let sizeSource = { (index: Int, data: Int, collectionSize: CGSize) -> CGSize in
            return CGSize(width: KScreenWidth, height: KScreenHeight)}
        
        let provider = BasicProvider<Int, NewsCollectView>(
            dataSource: dataSource,
            viewSource: viewSource,
            sizeSource: sizeSource)
        
        provider.layout = RowLayout("RowLayout", spacing: 0)
        newsCollection.provider = provider
        newsCollection.reloadData()
        newsCollection.setContentOffset(CGPoint(x: KScreenWidth * CGFloat(selectedIndex), y: 0), animated: false)
        
        // 头部
        let model = self.newsArr.bm_object(selectedIndex)

        titleView.frame = CGRect(x: 0, y: 0, width: KScreenWidth, height: 80)
        titleView.backgroundColor = .clear
        titleView.hero.modifiers = [.fade, .cascade, .spring(stiffness: stiffness, damping: damping),]
        self.view.addSubview(titleView)
        
        timeLabel.font = UIFont(name: "Futura-Medium", size: 13)
        timeLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        timeLabel.morphingEffect = .evaporate
        timeLabel.frame = CGRect(x: 20, y: 50+5, width: 140, height:  22)
        titleView.addSubview(timeLabel)
        
        tagLab.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        tagLab.font = UIFont.boldSystemFont(ofSize: 12)
        tagLab.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        tagLab.layer.borderWidth = 1
        tagLab.layer.cornerRadius = 4
        tagLab.textAlignment = .center
        tagLab.morphingEffect = .evaporate
        tagLab.frame = CGRect(x: 20, y: 50 + 8, width: KScreenWidth, height:  16)
        tagLab.hero.modifiers = [.fade, .spring(stiffness: stiffness, damping: damping),]
        titleView.addSubview(tagLab)
        
        timeLabel.hero.id = model!.heroId + "time"
        timeLabel.hero.modifiers = [.source(heroID: timeLabel.hero.id!), .spring(stiffness: stiffness, damping: damping),]
        tagLab.hero.id = model!.heroId + "tag"
        tagLab.hero.modifiers = [.source(heroID: tagLab.hero.id!), .spring(stiffness: stiffness, damping: damping),]
        
        showInfo(selectedIndex)
        
        newsCollection.delegate = self
    }
    
    @objc func handleBackGes(gr: UIScreenEdgePanGestureRecognizer) {
        if finishHero{  return  }
        switch gr.state {
        case .began:
            dismiss(animated: true, completion: nil)
        case .changed:
            var progress = gr.translation(in: nil).x / view.bounds.width
            progress = progress < 0.001 ? 0.001: progress/2;
            if progress > 0.12{
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




extension NewsDetailCollectionVC:UIScrollViewDelegate{
    
    
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let i = Int((targetContentOffset.pointee.x + 1) / KScreenWidth)
        self.showInfo(i)
    }
    
    
    func showInfo(_ i:Int){
        let model = self.newsArr.bm_object(i)
        timeLabel.text = model?.title ?? ""
        
        tagLab.text = model?.tags.bm_object(0)?["name"] as? String
        var r = self.tagLab.frame
        r.size.width = CGFloat(self.tagLab.text!.stringWidth(UIFont.boldSystemFont(ofSize: 12)) + 10)
        r.origin.x = KScreenWidth - r.size.width - 20
        UIView.animate(withDuration: 0.15) {
            self.tagLab.frame = r
        }
    }
    
    
    
    
}

