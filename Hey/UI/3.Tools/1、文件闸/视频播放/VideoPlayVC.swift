//
//  VideoPlayVC.swift
//  LisApp
//
//  Created by yimi on 2019/2/21.
//  Copyright © 2019 baymax. All rights reserved.
//

import UIKit
import SJVideoPlayer
import Masonry

class VideoPlayVC: BaseVC {
    
    var videoPlayer:SJVideoPlayer!
    
    var videoURL:String!
    var index:Int = 0
    var videoList:Array<String>!
    
    var videoTab: UITableView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        get{return .lightContent}
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        addSlideBack(view)
        
        videoTab = UITableView(frame: CGRect(x: 0, y: KScreenHeight/2, width: KScreenWidth, height: KScreenHeight/2))
        videoTab.delegate = self
        videoTab.backgroundColor = .clear
        videoTab.dataSource = self
        videoTab.separatorStyle = .none
        self.view.addSubview(videoTab)
    }
    
    override func viewWillLayoutSubviews() {
        videoTab.w = view.w
        videoPlayer.view.w = view.w
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if videoPlayer == nil{
            videoPlayer = SJVideoPlayer.lightweight()
            
            videoPlayer.view.frame = CGRect(x: 0, y: 40, width: KScreenWidth, height: KScreenHeight/2-40)
            videoPlayer.clickedBackEvent = { (player) in
                self.dismiss(animated: true, completion: nil)
            }
            videoPlayer.playDidToEndExeBlock = {(videoPlayer)  in
                var newVideo = self.videoURL
                if self.videoList != nil && self.videoList.count > 1{
                    self.index = (self.index + 1) % self.videoList.count
                    newVideo = self.videoList[self.index]
                }
                videoPlayer.assetURL = URL(fileURLWithPath: newVideo!)
                self.videoTab.reloadData()
            }
            videoPlayer.assetURL = URL(fileURLWithPath: videoURL)
            videoPlayer.controlLayerNeedAppear()
            videoPlayer.pausedToKeepAppearState = true;
            videoPlayer.controlLayerAutoAppearWhenAssetInitialized = true;
            view.addSubview(videoPlayer.view)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        videoPlayer.playDidToEndExeBlock = nil
        videoPlayer.stop()
        videoPlayer = nil
    }
}

extension VideoPlayVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if videoList != nil{
            return videoList.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "cell")
        var name = videoList[indexPath.row]
        name = name.components(separatedBy: "/").last ?? "unknow name"
        cell.textLabel?.text = name
        cell.textLabel?.textColor = .white
        cell.backgroundColor = .rgb(87, 87, 87)
        if indexPath.row == index{
            cell.accessoryType = .checkmark
            cell.textLabel?.textColor = .white
        }else{
            cell.textLabel?.textColor = .rgb(153, 153, 153)
            cell.accessoryType = .none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.row
        videoPlayer.stop()
        videoPlayer.assetURL = URL(fileURLWithPath: self.videoList[indexPath.row])
        tableView.reloadData()
    }
    
}



