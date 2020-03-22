//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Kittikawin Sontinarakul on 22/3/2563 BE.
//  Copyright © 2563 Kittikawin Sontinarakul. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController {
    @IBOutlet weak var soundMeterPregressView: UIProgressView!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var startModSoundButton: UIButton!
    @IBOutlet weak var dbMeterLabel: UILabel!
    
    
    
    var timer, timerBlinkRec: Timer?
    
    var isStartRecord: Bool = true
    var isResumeRecord: Bool = false

    var stopTimer: Timer!
    
    var audioRecorder : AVAudioRecorder!
    var filePath: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startModSoundButton.layer.cornerRadius = 0.5 * startModSoundButton.bounds.size.width
        startModSoundButton.clipsToBounds = true
        //soundMeterPregressView.transform = CGAffineTransform(rotationAngle: .pi * -0.5)
    }
    
    @IBAction func recordSoundButtonPressed(_ sender: UIButton) {
        if isStartRecord {
            startRecord()
            isStartRecord = false
            updateMetorAndUI()
        } else {
            if isResumeRecord {
                startAndResumeRecord()
                updateMetorAndUI()
            } else {
                pauseRecord()
            }
            isResumeRecord = !isResumeRecord
        }
    }
    
    //MARK: - Monitoring sound recording Voulume
    
    func updateMetorAndUI() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { (timer) in
            let dbMeter = self.getSoundMeterProgressView()
            self.soundMeterPregressView.progress = dbMeter
            self.dbMeterLabel.text = String(format: "%0.1f", dbMeter * 100) + " db"
        })
        
        timerBlinkRec = Timer.scheduledTimer(withTimeInterval: 0.7, repeats: true, block: { (timer) in
            if self.recordButton.currentImage == UIImage(named: "recording1") {
                self.recordButton.setImage(UIImage(named: "recording2"), for: .normal)
            } else {
                self.recordButton.setImage(UIImage(named: "recording1"), for: .normal)
            }
            
        })
    }
    
    @IBAction func startModSoundButtonPressed(_ sender: UIButton) {
        isStartRecord = true
        isResumeRecord = false
        stopRecord()
        
        performSegue(withIdentifier: "PlaySounds", sender: getSoundURL())
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PlaySounds" {
            let playSoundVC = segue.destination as! PlaySoundsViewController
            let recordURL = sender as! URL
            playSoundVC.recordedAudioURL = recordURL
        }
    }
}

