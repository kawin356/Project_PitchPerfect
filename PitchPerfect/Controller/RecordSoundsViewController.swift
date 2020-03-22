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
    
    @IBOutlet weak var soundMeterProgressView: UIProgressView!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var pauseRecordButton: UIButton!
    @IBOutlet weak var dbMeterLabel: UILabel!
    
    var timerUpdateMeter: Timer?
    
    var isStartRecord: Bool = true
    var isResumeRecord: Bool = false
    var stopTimer: Timer!
    var audioRecorder : AVAudioRecorder!
    var filePath: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    //MARK: - UI
    
    func setupUI() {
        pauseRecordButton.layer.cornerRadius = 0.5 * pauseRecordButton.bounds.size.width
        pauseRecordButton.clipsToBounds = true
        recordButton.layer.cornerRadius = 0.5 * recordButton.bounds.size.width
        recordButton.clipsToBounds = true
        recordButton.layer.borderWidth = 1
        recordButton.layer.borderColor = UIColor.gray.cgColor
    }
    
    enum StateRecord {
        case recording, stop, pause
    }
    
    func changeRecordUIButton(state: StateRecord) {
        switch state {
        case .recording:
            recordButton.backgroundColor = .red
            recordButton.setTitle("Stop", for: .normal)
            recordButton.isEnabled = true
            pauseRecordButton.isEnabled = true
        case .pause:
            recordButton.backgroundColor = .darkGray
            recordButton.setTitle("Pause", for: .normal)
            recordButton.isEnabled = false
            resetDbSound()
        case .stop:
            recordButton.backgroundColor = .black
            recordButton.setTitle("Start", for: .normal)
            recordButton.isEnabled = true
            pauseRecordButton.isEnabled = false
            resetDbSound()
        }
    }
    
    func resetDbSound() {
        dbMeterLabel.text = "0.0 db"
        soundMeterProgressView.progress = 0
    }
    
    //MARK: - IBAction
    
    @IBAction func recordSoundButtonPressed(_ sender: UIButton) {
        if isStartRecord {
            startRecord()
            isStartRecord = false
            updateMetorAndUI()
            changeRecordUIButton(state: .recording)
        } else {
            isStartRecord = true
            isResumeRecord = false
            stopRecord()
            changeRecordUIButton(state: .stop)
            performSegue(withIdentifier: "PlaySounds", sender: getSoundURL())
        }
    }
    
    @IBAction func pauseButtonPressed(_ sender: UIButton) {
        if isResumeRecord {
            startAndResumeRecord()
            updateMetorAndUI()
            changeRecordUIButton(state: .recording)
        } else {
            pauseRecord()
            changeRecordUIButton(state: .pause)
        }
        isResumeRecord = !isResumeRecord
    }
    
    
    
    
    //MARK: - Monitoring sound recording Voulume
    
    func updateMetorAndUI() {
        timerUpdateMeter = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { (timer) in
            let dbMeter = self.getSoundMeterProgressView()
            self.soundMeterProgressView.progress = dbMeter
            self.dbMeterLabel.text = String(format: "%0.1f", dbMeter * 100) + " db"
        })
    }
    

    //MARK: - Prepare Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PlaySounds" {
            let playSoundVC = segue.destination as! PlaySoundsViewController
            let recordURL = sender as! URL
            playSoundVC.recordedAudioURL = recordURL
        }
    }
}

