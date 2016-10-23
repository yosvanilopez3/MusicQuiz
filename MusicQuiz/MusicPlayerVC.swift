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
    private var musicPlayer: AVAudioPlayer!
    private var progressUpdater: Timer!
    private var currentSong: Song!
    private var length: Double = 60.0
    private var playEntireSong: Bool = false
    private var start: Double!
    private var end: Double!
    let songPaths = ["Antonio_Vivaldi&The_Four_Seasons_Autumn&1723&Movement_1", "Antonio_Vivaldi&The_Four_Seasons_Autumn&1723&Movement_2", "Antonio_Vivaldi&The_Four_Seasons_Autumn&1723&Movement_3", "Bernart_de_Ventadorn&Can_Vei_la_Lauzeta_Mover&1150",
        "Carlo_Gesualdo&Moro_lasso&1611",
        "Claudio_Monteverdi&L'Orfeo&1607&Act_3_Possente_spirto",
        "Arvo_Part&Fur_Alina&1976",
        "George_Friedrich_Handel&Messiah&1742&Overture",
        "Johann_Sebastian_Bach&Brandenburg_Concertos_5&1721&Movement_1"
    ]
    
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
            let resourcePath = Bundle.main.path(forResource: resourceString, ofType: "mp3")!
            let url = URL(fileURLWithPath: resourcePath)
            try musicPlayer = AVAudioPlayer(contentsOf: url)
        } catch let err as NSError {
            print(err.debugDescription)
        }
        // load length and play entire song from dataservice 
        
        
        // minimize lag between click and play time
        musicPlayer.delegate = self
        playMusic()
        startUpdater()
    }
    
    // Implement this function that will give a clip of a certain time interval from a song
     func playMusic() {
      setInterval()
      musicPlayer.currentTime = start
      musicPlayer.prepareToPlay()
      musicPlayer.numberOfLoops = 0
      musicPlayer.play()

     }
    
  // Initial Set up of player
    func setInterval() {
        let songLength = musicPlayer.duration
        if length >= songLength || playEntireSong {
            start = 0.0
            end = songLength
        }
        else {
            let midpoint = getRandomPoint()
            start = midpoint - length/2.0
            end = midpoint + length/2.0
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
    
    func getRandomPoint() -> Double {
        return Double(arc4random_uniform(UInt32(musicPlayer.duration)))
    }
    
    // song playing handling
    private func startUpdater() {
        if progressUpdater != nil {
            progressUpdater.invalidate()
        }
        progressUpdater = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateProgressBar), userInfo: nil, repeats: true)
    }
    
    @objc private func updateProgressBar() {
        let progress = (Float(musicPlayer.currentTime) - Float(start))/Float(length)
        songProgress.setProgress(progress, animated: true)
        if songProgress.progress == 1.0 {
            stopPlaying()
        }
    }
    
    @IBAction func homeBtn(_ sender: AnyObject) {
        musicPlayer.stop()
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func stopPlaying() {
        musicPlayer.stop()
        performSegue(withIdentifier: "goToQuiz", sender: nil)
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

