//
//  SpeechManage.swift
//  Lee
//
//  Created by 李志伟 on 2020/11/9.
//  Copyright © 2020 baymax. All rights reserved.
//

import UIKit
import AVFoundation
import AudioToolbox

class SpeechManage: NSObject {

    public static let shared = SpeechManage()

    var synthesizer = AVSpeechSynthesizer()
    var speechUtterance: AVSpeechUtterance!
    
    static func speak(_ str:String){
        SpeechManage.shared.speak(str)
    }
    
    
    static func shake(){
        //建立的SystemSoundID对象
        let soundID = SystemSoundID(kSystemSoundID_Vibrate)
        //振动
        AudioServicesPlaySystemSound(soundID)
    }
    
    static func ring(){
        //建立的SystemSoundID对象
        let soundID = SystemSoundID(kSystemSoundID_Vibrate)
        //振动
        AudioServicesPlaySystemSound(soundID)
    }
    
    override init() {
        super.init()
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, options: .duckOthers)
        } catch {
            print(error.localizedDescription)
        }
        synthesizer.delegate = self
    }
    
    func speak(_ str:String){
        if let _ = speechUtterance{
            synthesizer.stopSpeaking(at: .immediate)
        }
        do {
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print(error.localizedDescription)
        }
        
        speechUtterance = AVSpeechUtterance(string: str)
        speechUtterance.voice = .none
        synthesizer.speak(speechUtterance!)
    }
    
    
}

extension SpeechManage: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        do {
            try AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
        } catch {
            print(error.localizedDescription)
        }
        speechUtterance = nil
    }
}
