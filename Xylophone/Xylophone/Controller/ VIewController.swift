//
//  ViewController.swift
//  Xylophone
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate {
    
    // MARK: Properties
    // **********************************************************************
    
    /// The audio player.
    private var audioPlayer: AVAudioPlayer!

    // MARK: Actions
    // **********************************************************************
    
    @IBAction private func notePressed(_ sender: UIButton) {
        let selectedSoundFileName = "note\(sender.tag)"
        playSound(soundFileName: selectedSoundFileName)
    }
    
    // MARK: Others
    // **********************************************************************
    
    private func playSound(soundFileName: String) {
        guard let soundURL = Bundle.main.url(forResource: soundFileName, withExtension: "wav") else {
            print("File \(soundFileName).wav not found")
            return
        }
        
        do {
            try audioPlayer = AVAudioPlayer(contentsOf: soundURL)
            
            audioPlayer.prepareToPlay()
            audioPlayer.play()
        } catch let error {
            print(error)
        }
    }
}

