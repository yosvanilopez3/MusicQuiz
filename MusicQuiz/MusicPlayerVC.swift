//
//  MusicPlayerVC.swift
//  MusicQuiz
//
//  Created by Yosvani Lopez on 10/16/16.
//  Copyright © 2016 Yosvani Lopez. All rights reserved.
//

import UIKit
import AVFoundation
class MusicPlayerVC: UIViewController, AVAudioPlayerDelegate{
    private var musicPlayer: MusicPlayer!
    private var progressUpdater: Timer!
    private var currentSong: Song!
    private var length: Double = 120.0
    private var playEntireSong: Bool = false
    private var start: Double!
    private var end: Double!
    @IBOutlet weak var songProgress: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch _ {
            return print("error")
        }
        do {
            currentSong = getRandomSong()
            let resourceString = currentSong.path
            if let resourcePath = Bundle.main.path(forResource: resourceString, ofType: "mp3") {
                let url = URL(fileURLWithPath: resourcePath)
                try musicPlayer = MusicPlayer(contentsOf: url)
                // minimize lag between click and play time
                musicPlayer.delegate = self
                musicPlayer.playMusic()
                startUpdater()
            }
        } catch let err as NSError {
            print(err.debugDescription)
        }
        // load length and play entire song from dataservice
    }
    
    // song playing handling
    private func startUpdater() {
        if progressUpdater != nil {
            progressUpdater.invalidate()
        }
        progressUpdater = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateProgressBar), userInfo: nil, repeats: true)
    }
    // need to change use of device current time when pause button is implemented
    @objc private func updateProgressBar() {
        let progress = (Float(musicPlayer.currentTime) - Float(start))/(Float(end) - Float(start))
        songProgress.setProgress(progress, animated: true)
        // the players current time resets back to 0 whenever the song finishes, it will never be zero otherwise because this function is called 1 second after the music is started. could be possible complication once rewind and foward are implements, possibility is to not allow user to bring back to time = 0 instead only bring back to like time = 1 or something in between, progress needs to be >1 also must be check because otherwise songs continue playing
        if musicPlayer.currentTime == 0 || progress > 1.0 {
            endPlaying()
        }
    }
    
    @IBAction func homeBtn(_ sender: AnyObject) {
        resetProgress()
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func endPlaying() {
        resetProgress()
        progressUpdater.invalidate()
        performSegue(withIdentifier: "goToQuiz", sender: nil)
    }
    
    func resetProgress() {
        musicPlayer.stop()
        musicPlayer.currentTime = 0.0
        songProgress.progress = 0.0
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToQuiz" {
            if let destination = segue.destination as? QuizVC{
                destination.song = currentSong
            }
        }
    }
    
    private func getRandomSong() -> Song {
        var songs = [Song]()
        for song in songPaths {
            let songInfo = parseSongPath(path: song)
            if songInfo.count == 4 {
                songs.append(Song(path: song, composer: songInfo[0], name: songInfo[1], year: songInfo[2], extra: songInfo[3]))
            }
        }
        return songs[Int(arc4random_uniform(UInt32(songs.count)))]
        
    }
    
    private func parseSongPath(path:String) -> [String] {
        let pathWithSpaces = path.replacingOccurrences(of: "_", with: " ")
        var info = pathWithSpaces.components(separatedBy: "&")
        if info.count < 4 {
            info.append("N/A")
        }
        return info
    }
}

