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
    private var length: Double = 30.0
    private var playEntireSong: Bool = false
    @IBOutlet weak var songProgress: UIProgressView!
    private var elapsedTime:Double!
    
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
                elapsedTime = 0;
                musicPlayer.playMusic(song: resourcePath, interval: length, atTime: musicPlayer.getRandomPoint())
                startUpdater()
            }
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }
    
    // song playing handling
    private func startUpdater() {
        if progressUpdater != nil {
            progressUpdater.invalidate()
        }
        progressUpdater = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateProgressBar), userInfo: nil, repeats: true)
    }
    

    @objc private func updateProgressBar() {
        let totalTime = Double.minimum(length, musicPlayer.duration.binade)
        let progress = Float(elapsedTime/totalTime)
        songProgress.setProgress(progress, animated: true)
        elapsedTime = elapsedTime + 1;
        if (elapsedTime > totalTime) {
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
        elapsedTime = 0;
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
            if songInfo.count >= 4 {
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

