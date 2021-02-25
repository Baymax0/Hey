//
//  ARVC.swift
//  Hey
//
//  Created by 李志伟 on 2021/2/9.
//  Copyright © 2021 baymax. All rights reserved.
//

import UIKit
import ARKit
import Vision

class ARVC: BaseVC, ARSCNViewDelegate{

    @IBOutlet var sceneView: ARSCNView!
    
    var session: ARSession {
        return sceneView.session
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        
        abc()
        
        guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) else {
            fatalError("Missing expected asset catalog resources.")
        }
        let configuration = ARImageTrackingConfiguration()
        configuration.trackingImages = referenceImages
        session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        
    }
    
    func abc() {
        let healthView = UIView(frame: .init(x: 0, y: 0, width: 250, height: 220))
        let lab = UILabel(frame: .init(x: 0, y: 0, width: 250, height: 20))
        lab.text = "123da dadad "
        lab.textColor = .white
        healthView.addSubview(lab)
        
        let lab2 = UILabel(frame: .init(x: 0, y: 5, width: 250, height: 20))
        lab2.text = "jsbah jdna kjsd a"
        lab2.textColor = .white
        healthView.addSubview(lab2)
        
        healthView.backgroundColor = .clear
        healthView.isOpaque = false
        healthView.layoutIfNeeded()

        let image = imageWithView(view: healthView)
        ARImageStoreService.shared.forceHealthImage = image
    }
    
    func imageWithView(view: UIView) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0)
        defer { UIGraphicsEndImageContext() }
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        session.pause()
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if let imageAnchor = anchor as? ARImageAnchor{
            let referenceImage = imageAnchor.referenceImage
            DispatchQueue.main.async {
                let plane = SCNPlane(width: referenceImage.physicalSize.width,
                                     height: referenceImage.physicalSize.height)
                let planeNode = SCNNode(geometry: plane)
                planeNode.opacity = 0.25
                planeNode.eulerAngles.x = -.pi / 2
                planeNode.runAction(self.imageHighlightAction)
                node.addChildNode(planeNode)
                
                let tabNode = TabNode()
                tabNode.opacity = 0
                tabNode.scale = .init(0.6, 0.6, 0.6)
                tabNode.rotation.x = .pi / 3
                tabNode.position.z = -0.10
                tabNode.position.x = -0.14
                tabNode.runAction(self.tabPresentationAction)
                node.addChildNode(tabNode)
            }
        }
    }
    
    var tabPresentationAction: SCNAction {
        return .sequence([
            .wait(duration: 0.15),
            .group([
                .move(by: SCNVector3(0, 0, 0.05), duration: 0.3),
                .fadeIn(duration: 0.3),
                .scale(to: 1.2, duration: 0.3),
                .rotateTo(x: .pi/6, y: 0, z: 0, duration: 0.3)
            ]),
            .group([
                .scale(to: 1.0, duration: 0.3),
                .rotateTo(x: 0, y: 0, z: 0, duration: 0.3)
            ]),
        ])
    }
    
    var imageHighlightAction: SCNAction {
        return .sequence([
            .wait(duration: 0.25),
            .fadeOpacity(to: 0.85, duration: 0.25),
            .fadeOpacity(to: 0.15, duration: 0.25),
            .fadeOpacity(to: 0.85, duration: 0.25),
        ])
    }
}
