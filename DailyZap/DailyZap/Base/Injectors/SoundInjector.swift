//
//  SoundInjector.swift
//  DailyZap
//
//  Created by David LoBosco on 4/7/18.
//  Copyright © 2018 dqlobo. All rights reserved.
//

import Foundation
import AudioToolbox

fileprivate struct SoundInstance {
    static let soundManager: SoundManager = SoundManager()
}

protocol SoundInjector { }
extension SoundInjector {
    var soundManager: SoundManager { return SoundInstance.soundManager }
}

class SoundManager {
    private var pointsSoundID: UInt32 = 0
    private var boltSoundID: UInt32 = 0
    private var successSoundID: UInt32 = 0
    private var negativeSoundID: UInt32 = 0

    init() {
        registerSound(named: "points_only", id: &pointsSoundID)
        registerSound(named: "success", id: &successSoundID)
        registerSound(named: "bolt", id: &boltSoundID)
        registerSound(named: "negative", id: &negativeSoundID)
    }
    
    func registerSound(named name: String, ext: String = "mp3", id: inout UInt32) {
        if let url = Bundle.main.url(forResource: name, withExtension: ext) {
            AudioServicesCreateSystemSoundID(url as CFURL, &id)
        }
    }
    
    func playBoltSound() {
        AudioServicesPlaySystemSound(boltSoundID)
    }
    func playPointsSound() {
        AudioServicesPlaySystemSound(pointsSoundID)
    }
    func playSuccessSound() {
        AudioServicesPlaySystemSound(successSoundID)
    }
    
    func playNegativeSound() {
        AudioServicesPlaySystemSound(negativeSoundID)

    }
}
