//
//  WFPermissionTool.swift
//  wangfu2
//
//  Created by yimi on 2018/11/14.
//  Copyright © 2018 zbkj. All rights reserved.
//

import UIKit
import Photos
import AssetsLibrary
import MediaPlayer
import CoreTelephony
import CoreLocation
import AVFoundation

enum WFPermissionType:String{
    case library = "相册"
    case capture = "摄像头"
    case address = "位置"
    
    func hasRight() -> Bool{
        switch self{
        case .library:
            let authStatus = PHPhotoLibrary.authorizationStatus()
            if authStatus == PHAuthorizationStatus.restricted || authStatus == PHAuthorizationStatus.denied {
                return false;
            }
        case .capture:
            let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
            if authStatus == AVAuthorizationStatus.notDetermined {
                AVCaptureDevice.requestAccess(for: AVMediaType.video) { (granted) in
                    return granted
                }
            } else if authStatus == AVAuthorizationStatus.restricted || authStatus == AVAuthorizationStatus.denied {
                return false
            } else {
                return true
            }
        case .address:
            if CLLocationManager.locationServicesEnabled() || CLLocationManager.authorizationStatus() != .denied {
                return true
            }
            return false
        }
        return true
    }
    
    func showAlert(){
        let url = URL(string: UIApplication.openSettingsURLString)
        let title = "“”"+self.rawValue + "”" + "访问受限"
        let alertController = UIAlertController(title: title,
                                                message: "点击“设置”，允许访问权限",
                                                preferredStyle: .alert)
        let cancelAction = UIAlertAction(title:"取消", style: .cancel, handler:nil)
        let settingsAction = UIAlertAction(title:"设置", style: .default, handler: {
            (action) -> Void in
            if  UIApplication.shared.canOpenURL(url!) {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url!, options: [:],completionHandler: {(success) in})
                } else {
                    UIApplication.shared.openURL(url!)
                }
            }
        })
        alertController.addAction(cancelAction)
        alertController.addAction(settingsAction)
        
        UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
}


