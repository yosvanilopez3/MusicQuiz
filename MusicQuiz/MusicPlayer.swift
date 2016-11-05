//
//  MusicPlayer.swift
//  MusicQuiz
//
//  Created by Yosvani Lopez on 11/1/16.
//  Copyright © 2016 Yosvani Lopez. All rights reserved.
//

import UIKit
import AVFoundation

class MusicPlayer: AVAudioPlayer {
    
    // Implement this function that will give a clip of a certain time interval from a song
    func playMusic(song: String, interval: Double, atTime: Double = Double.nan) {
        setInterval(length: interval)
        let musicTimer = createMusicTimer()
        playMusic(song: song)
    }
    // plays the entire song
    func playMusic(song: String) {
        self.prepareToPlay()
        self.numberOfLoops = 0
        self.play()
    }
    func createMusicTimer(time: Double) -> Timer {
        return Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(checkTime), userInfo: nil, repeats: true)
    }
    
    @objc private func checkTime(endTime: Double) {
        if self.currentTime == endTime {
            musicHasEnded()
        }
    }
    func musicHasEnded() {
        
    }
    func getRandomPoint() -> Double {
        return Double(arc4random_uniform(UInt32(self.duration)))
    }
    // Initial Set up of player
    func setInterval(length: Double) {
        let songLength = self.duration
        if length < songLength {
            let midpoint = getRandomPoint()
            var start = midpoint - length/2.0
            var end = midpoint + length/2.0
            if start < 0.0 {
                end = end + Double.abs(start)
                start = 0.0
            }
            else if end > songLength {
                start = start - (end - songLength)
                end = songLength
            }
    }

}
