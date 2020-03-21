//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Kittikawin Sontinarakul on 22/3/2563 BE.
//  Copyright © 2563 Kittikawin Sontinarakul. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    @IBOutlet weak var soundMeterPregressView: UIProgressView!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var startModSoundButton: UIButton!
    
    var audioRecorder : AVAudioRecorder!
    
    var timer: Timer?
    
    var isStartRecord: Bool = true
    var isResumeRecord: Bool = false
    
    var recordedAudioURL: URL!
    var audioFile: AVAudioFile!
    var audioEngine: AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var stopTimer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func recordSoundButtonPressed(_ sender: UIButton) {
        if isStartRecord {
            let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
            let recordingName = "recordedVoice.wav"
            let pathArray = [dirPath, recordingName]
            let filePath = URL(string: pathArray.joined(separator: "/"))
            
            let session = AVAudioSession.sharedInstance()
            try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
            
            try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
            audioRecorder.delegate = self
            audioRecorder.isMeteringEnabled = true
            audioRecorder.prepareToRecord()
            startMonitoringAndRecord()
            isStartRecord = false
        } else {
            if isResumeRecord {
                startMonitoringAndRecord()
            } else {
                pauseRecord()
            }
            isResumeRecord = !isResumeRecord
        }
    }
    
    //MARK: - Monitoring sound recording Voulume
    private func startMonitoringAndRecord() {
        audioRecorder.record()
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { (timer) in
            self.audioRecorder.updateMeters()
            let db = self.audioRecorder.averagePower(forChannel: 0)
            self.soundMeterPregressView.progress = (db + 70) / 100
        })
    }
    
    private func pauseRecord() {
        timer?.invalidate()
        audioRecorder.pause()
    }
    
    
    @IBAction func startModSoundButtonPressed(_ sender: UIButton) {
        isStartRecord = true
        isResumeRecord = false
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    @IBAction func playSoundButtonPressed(_ sender: UIButton) {
        recordedAudioURL = audioRecorder.url
        setupAudio()
        playSound(pitch: -1000)
    }
    
}

