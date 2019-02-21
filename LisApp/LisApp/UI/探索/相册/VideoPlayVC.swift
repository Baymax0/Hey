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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        videoPlayer = SJVideoPlayer.lightweight()
        videoPlayer.supportedOrientation = .all
        videoPlayer.orientation = .landscapeLeft
        view.addSubview(videoPlayer.view)
        
        videoPlayer.view.frame = CGRect(x: 0, y: 0, width: KScreenWidth, height: KScreenHeight)
        
        videoPlayer.clickedBackEvent = { (player) in
            self.dismiss(animated: true, completion: nil)
        }
        
        self.videoPlayer.assetURL = URL(string: videoURL)
    }
    
    

}
