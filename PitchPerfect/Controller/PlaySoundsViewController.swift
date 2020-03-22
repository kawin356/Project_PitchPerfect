//
//  PlaySoundsViewController.swift
//  PitchPerfect
//
//  Created by Kittikawin Sontinarakul on 22/3/2563 BE.
//  Copyright © 2563 Kittikawin Sontinarakul. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    @IBOutlet weak var speedSlider: UISlider!
    @IBOutlet weak var pitchSlider: UISlider!
    @IBOutlet weak var echoSwitch: UISwitch!
    @IBOutlet weak var reverbSwitch: UISwitch!
    @IBOutlet weak var playStopButton: UIButton!
    
    var recordedAudioURL: URL!
    var audioFile: AVAudioFile!
    var audioEngine: AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var stopTimer: Timer!
    
    var isPlayingSound: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAudio()
        configureUI(.notPlaying)
    }
    
    @IBAction func playOrStopButton(_ sender: UIButton) {
        if !isPlayingSound {
            let rate = speedSlider.value / 1000
            let pitch = pitchSlider.value * -1
            let echo = echoSwitch.isOn
            let reverb = reverbSwitch.isOn
            
            playSound(rate: rate, pitch: pitch, echo: echo, reverb: reverb)
            configureUI(.playing)
        } else {
            stopAudio()
        }
    }
    
    
}
