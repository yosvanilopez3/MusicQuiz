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
    var musicPlayer: AVAudioPlayer!
    var currentSong: Song!
    var timer: Timer!
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
        // minimize lag between click and play time
        musicPlayer.delegate = self
        musicPlayer.prepareToPlay()
        musicPlayer.numberOfLoops = 0
        musicPlayer.play()
        startTimer()
    }
    
    // Implement this function that will give a clip of a certain time interval from a song
    /* func playSnippet(length: double) {
     
     } */
    
    private func startTimer() {
        if timer != nil {
            timer.invalidate()
        }
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateProgressBar), userInfo: nil, repeats: true)
    }
    
    @objc private func updateProgressBar() {
        let progress = Float(musicPlayer.currentTime)/Float(musicPlayer.duration)
        songProgress.setProgress(progress, animated: true)
    }
    
    @IBAction func homeBtn(_ sender: AnyObject) {
        musicPlayer.stop()
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
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
        let songPaths = ["Antonio_Vivaldi&The_Four_Seasons_Autumn&1723&Movement_1", "Antonio_Vivaldi&The_Four_Seasons_Autumn&1723&Movement_2", "Antonio_Vivaldi&The_Four_Seasons_Autumn&1723&Movement_3", "Bernart_de_Ventadorn&Can_Vei_la_Lauzeta_Mover&1150", "Carlo_Gesualdo&Moro_lasso&1611",
                         "Claudio_Monteverdi&L'Orfeo&1607&Act_3_Possente_spirto", "Arvo_Part&Fur_Alina&1976", "George_Friedrich_Handel&Messiah&1742&Overture", "Johann_Sebastian_Bach&Brandenburg_Concertos_5&1721&Movement_1"]
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

