//
//  Recorder.swift
//  PitchPerfect
//
//  Created by Kittikawin Sontinarakul on 22/3/2563 BE.
//  Copyright © 2563 Kittikawin Sontinarakul. All rights reserved.
//

import Foundation
import AVFoundation

extension RecordSoundsViewController: AVAudioRecorderDelegate {
    
    func startRecord() {
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        startAndResumeRecord()
    }
    
    func startAndResumeRecord() {
        audioRecorder.record()
    }
        
    func getSoundMeterProgressView() -> Float {
        self.audioRecorder.updateMeters()
        let db = self.audioRecorder.averagePower(forChannel: 0)
        return (db + 70) / 100
    }
    
    func getSoundURL() -> URL {
        return filePath
    }
    
    func pauseRecord() {
        audioRecorder.pause()
        timer?.invalidate()
       // timerBlinkRec?.invalidate()
    }
    
    func stopRecord() {
        audioRecorder.stop()
        timer?.invalidate()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
}
