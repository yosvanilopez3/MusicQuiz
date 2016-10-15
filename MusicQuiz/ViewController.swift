//
//  ViewController.swift
//  MusicQuiz
//
//  Created by Yosvani Lopez on 10/14/16.
//  Copyright © 2016 Yosvani Lopez. All rights reserved.
//

import UIKit
import AVFoundation
class ViewController: UIViewController, AVAudioPlayerDelegate{
    var musicPlayer: AVAudioPlayer!
    //var currentSong: Song!
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            //currentSong = getRandomSong()
            let resourcePath = Bundle.main.path(forResource: resourceString, ofType: "mp3")!
            let url = URL(fileURLWithPath: resourcePath)
            try musicPlayer = AVAudioPlayer(contentsOf: url)
        } catch let err as NSError {
            print(err.debugDescription)
        }
        // minimize lag between click and play time
        musicPlayer.delegate = self
        musicPlayer.prepareToPlay()
        musicPlayer.numberOfLoops = 1
        musicPlayer.play()
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        performSegue(withIdentifier: "goToQuiz", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToQuiz" {
            if let destination = segue.destination as? QuizVC{
                //destination.song = currentSong
            }
        }
    }
    func getRandomSong() -> Song {
       var songs = [Song]()
       let songPaths = ["Antonio_Vivaldi&The_Four_Seasons_Autumn&1723&Movement_1", "Antonio_Vivaldi&The_Four_Seasons_Autumn&1723&Movement_2", "Antonio_Vivaldi&The_Four_Seasons_Autumn&1723&Movement_3", "Bernart_de_Ventadorn&Can_Vei_la_Lauzeta_Mover&1150", "Carlo_Gesualdo&Moro_lasso&1611",
           "Claudio_Monteverdi&L’Orfeo&1607&Act_3_Possente_spirto", 
        for song in songPaths {
            let songInfo = parseSongPath(path: song)
            if songInfo.count = 4 {
                songs.append(Song(path: song, name: songInfo[0], composer: songInfo[1], year: songInfo[2], extra: songInfo[3]))
            }
      }
        return songs[Int(arc4random_uniform(4))]
    }
        
    func parseSongPath(path:String) -> [String] {
        let pathWithSpaces = path.replacingOccurrences(of: "_", with: " ")
        var info = pathWithSpaces.components(separatedBy: "&")
        if info.count < 5 {
           info.append("None")
        }
        return info
    }
}

