//
//  UltuManSIgnVC.swift
//  Lee
//
//  Created by 李志伟 on 2020/10/22.
//  Copyright © 2020 baymax. All rights reserved.
//

import UIKit
import AVFoundation
import Vision

class UltuManSIgnVC: BaseVC {

    @IBOutlet weak var cameraView: CameraView!
    @IBOutlet weak var drawBG: UIView!

    
    private let videoDataOutputQueue = DispatchQueue(label: "CameraFeedDataOutput", qos: .userInteractive)
    private var cameraFeedSession: AVCaptureSession?
    private var handPoseRequest = VNDetectHumanHandPoseRequest()

    @IBOutlet weak var reviewImage: UIImageView!
    
    private let drawOverlay = CAShapeLayer()
    private let drawPath = UIBezierPath()
    private var evidenceBuffer = [HandGestureProcessor.PointsPair]()
    private var lastDrawPoint: CGPoint?
    private var isFirstSegment = true
    private var lastObservationTimestamp = Date()
    
    private var gestureProcessor = HandGestureProcessor()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideNav = true
        
        drawOverlay.frame = view.layer.bounds
        drawOverlay.lineWidth = 5
        drawOverlay.backgroundColor = #colorLiteral(red: 0.9999018312, green: 1, blue: 0.9998798966, alpha: 0.5).cgColor
        drawOverlay.strokeColor = #colorLiteral(red: 0.6, green: 0.1, blue: 0.3, alpha: 1).cgColor
        drawOverlay.fillColor = #colorLiteral(red: 0.9999018312, green: 1, blue: 0.9998798966, alpha: 0).cgColor
        drawOverlay.lineCap = .round
        drawBG.layer.addSublayer(drawOverlay)
        
        handPoseRequest.maximumHandCount = 1

        gestureProcessor.didChangeStateClosure = { [weak self] state in
            self?.handleGestureStateChange(state: state)
        }
        // Add double tap gesture recognizer for clearing the draw path.
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
        recognizer.numberOfTouchesRequired = 1
        recognizer.numberOfTapsRequired = 2
        view.addGestureRecognizer(recognizer)

        if cameraFeedSession == nil {
            cameraView.previewLayer.videoGravity = .resizeAspectFill
            setupAVSession()
            cameraView.previewLayer.session = cameraFeedSession
        }
        cameraFeedSession?.startRunning()
    }
    
    @IBAction func chooseUltmanAction(_ sender: UIButton) {
        let name = "ulterman-sign-" + sender.tag.toString()!
        reviewImage.image = UIImage(named: name)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        cameraFeedSession?.stopRunning()
        super.viewWillDisappear(animated)
    }
    
    func setupAVSession() {
        // Select a front facing camera, make an input.
        let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
        let deviceInput = try? AVCaptureDeviceInput(device: videoDevice!)
        
        
        
        let session = AVCaptureSession()
        session.beginConfiguration()
        session.sessionPreset = AVCaptureSession.Preset.high
        
        session.canAddInput(deviceInput!)
        
        session.addInput(deviceInput!)
        
        let dataOutput = AVCaptureVideoDataOutput()
        if session.canAddOutput(dataOutput) {
            session.addOutput(dataOutput)
            // Add a video data output.
            dataOutput.alwaysDiscardsLateVideoFrames = true
            dataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)]
            dataOutput.setSampleBufferDelegate(self, queue: videoDataOutputQueue)
        }
        session.commitConfiguration()
        cameraFeedSession = session
    }
    
    func processPoints(thumbTip: CGPoint?, indexTip: CGPoint?) {
        // Check that we have both points.
        guard let thumbPoint = thumbTip, let indexPoint = indexTip else {
            // If there were no observations for more than 2 seconds reset gesture processor.
            if Date().timeIntervalSince(lastObservationTimestamp) > 2 {
                gestureProcessor.reset()
            }
            cameraView.showPoints([], color: .clear)
            return
        }
        
        // Convert points from AVFoundation coordinates to UIKit coordinates.
        let previewLayer = cameraView.previewLayer
        let thumbPointConverted = previewLayer.layerPointConverted(fromCaptureDevicePoint: thumbPoint)
        let indexPointConverted = previewLayer.layerPointConverted(fromCaptureDevicePoint: indexPoint)
        
        // Process new points
        gestureProcessor.processPointsPair((thumbPointConverted, indexPointConverted))
    }
    
    private func handleGestureStateChange(state: HandGestureProcessor.State) {
        let pointsPair = gestureProcessor.lastProcessedPointsPair
        var tipsColor: UIColor
        switch state {
        case .possiblePinch, .possibleApart:
            // We are in one of the "possible": states, meaning there is not enough evidence yet to determine
            // if we want to draw or not. For now, collect points in the evidence buffer, so we can add them
            // to a drawing path when required.
            evidenceBuffer.append(pointsPair)
            tipsColor = .orange
        case .pinched:
            // We have enough evidence to draw. Draw the points collected in the evidence buffer, if any.
            for bufferedPoints in evidenceBuffer {
                updatePath(with: bufferedPoints, isLastPointsPair: false)
            }
            // Clear the evidence buffer.
            evidenceBuffer.removeAll()
            // Finally, draw the current point.
            updatePath(with: pointsPair, isLastPointsPair: false)
            tipsColor = .green
        case .apart, .unknown:
            // We have enough evidence to not draw. Discard any evidence buffer points.
            evidenceBuffer.removeAll()
            // And draw the last segment of our draw path.
            updatePath(with: pointsPair, isLastPointsPair: true)
            tipsColor = .red
        }
        cameraView.showPoints([pointsPair.thumbTip, pointsPair.indexTip], color: tipsColor)
    }
    
    private func updatePath(with points: HandGestureProcessor.PointsPair, isLastPointsPair: Bool) {
        // Get the mid point between the tips.
        let (thumbTip, indexTip) = points
        let drawPoint = CGPoint.midPoint(p1: thumbTip, p2: indexTip)

        if isLastPointsPair {
            if let lastPoint = lastDrawPoint {
                // Add a straight line from the last midpoint to the end of the stroke.
                drawPath.addLine(to: lastPoint)
            }
            // We are done drawing, so reset the last draw point.
            lastDrawPoint = nil
        } else {
            if lastDrawPoint == nil {
                // This is the beginning of the stroke.
                drawPath.move(to: drawPoint)
                isFirstSegment = true
            } else {
                let lastPoint = lastDrawPoint!
                // Get the midpoint between the last draw point and the new point.
                let midPoint = CGPoint.midPoint(p1: lastPoint, p2: drawPoint)
                if isFirstSegment {
                    // If it's the first segment of the stroke, draw a line to the midpoint.
                    drawPath.addLine(to: midPoint)
                    isFirstSegment = false
                } else {
                    // Otherwise, draw a curve to a midpoint using the last draw point as a control point.
                    drawPath.addQuadCurve(to: midPoint, controlPoint: lastPoint)
                }
            }
            // Remember the last draw point for the next update pass.
            lastDrawPoint = drawPoint
        }
        // Update the path on the overlay layer.
        drawOverlay.path = drawPath.cgPath
    }
    
    @IBAction func handleGesture(_ gesture: UITapGestureRecognizer) {
        guard gesture.state == .ended else {
            return
        }
        evidenceBuffer.removeAll()
        drawPath.removeAllPoints()
        drawOverlay.path = drawPath.cgPath
    }
}

extension UltuManSIgnVC: AVCaptureVideoDataOutputSampleBufferDelegate {

//    对每一帧的数据流 进行操作
    public func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        var thumbTip: CGPoint?
        var indexTip: CGPoint?
        
        defer {
            DispatchQueue.main.sync {
                self.processPoints(thumbTip: thumbTip, indexTip: indexTip)
            }
        }
        //拿到句柄
        let handler = VNImageRequestHandler(cmSampleBuffer: sampleBuffer, orientation: .up, options: [:])
        do {
            // 执行一次 手势请求
            try handler.perform([handPoseRequest])
            // 只有当图像内识别到 手势 才会继续
            // maximumHandCount 设为了1，所以第一个就是我们需要的手势识别对象
            guard let observation = handPoseRequest.results?.first else {
                return
            }
            // 获得大拇指 和 食指 的关节数组
            let thumbPoints = try observation.recognizedPoints(.thumb)//大拇指
            let indexFingerPoints = try observation.recognizedPoints(.indexFinger)//食指
            // TIP为最外侧的关节点，
            guard let thumbTipPoint = thumbPoints[.thumbTip], let indexTipPoint = indexFingerPoints[.indexTip] else {
                return
            }
            // 忽略识别可行度低的值
            guard thumbTipPoint.confidence > 0.3 && indexTipPoint.confidence > 0.3 else {
                return
            }
            // Vision 坐标系（原点在左下角） 转为 AVFoundation 坐标系（原点在左上角）
            thumbTip = CGPoint(x: thumbTipPoint.location.x, y: 1 - thumbTipPoint.location.y)
            indexTip = CGPoint(x: indexTipPoint.location.x, y: 1 - indexTipPoint.location.y)
        } catch {
            cameraFeedSession?.stopRunning()
        }
    }
}


