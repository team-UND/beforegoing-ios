//
//  AudioManager.swift
//  BeforeGoing
//
//  Created by APPLE on 12/28/25.
//

import AVFAudio
import Foundation

final class AudioManager {
    
    static let shared = AudioManager()
    
    private var timer: Timer?
    private var remainingSeconds = 60
    
    private init() {}
    
    func startSound() {
        stopSound()
        remainingSeconds = 60
        
        timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            if self.remainingSeconds > 0 {
                AudioServicesPlaySystemSound(SystemSoundID(1005))
                self.remainingSeconds -= 1
                return
            }
            self.stopSound()
        }
    }
    
    func stopSound() {
        timer?.invalidate()
        timer = nil
    }
}
