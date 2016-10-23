//
//  ResultsVC.swift
//  MusicQuiz
//
//  Created by Yosvani Lopez on 10/15/16.
//  Copyright © 2016 Yosvani Lopez. All rights reserved.
//

import UIKit

class ResultsVC: UIViewController {
    var song: Song!
    var songInput: String!
    var composerInput: String!
    var yearInput:String!
    var movementInput: String!
    @IBOutlet weak var songIndicator: UIImageView!
    @IBOutlet weak var songNameGuess: UILabel!
    @IBOutlet weak var songName: UILabel!
    @IBOutlet weak var composerIndicator: UIImageView!
    @IBOutlet weak var composerGuess: UILabel!
    @IBOutlet weak var composer: UILabel!
    @IBOutlet weak var yearIndicator: UIImageView!
    @IBOutlet weak var yearGuess: UILabel!
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var movementLbl: UILabel!
    @IBOutlet weak var movementIndicator: UIImageView!
    @IBOutlet weak var movementGuess: UILabel!
    @IBOutlet weak var movement: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkAnswers()
        fillInResponse()
    }
    
    private func fillInResponse() {
        if let song = songInput, song != "" {
          songNameGuess.text = "Your Answer: \(song)"
        } else {
            songNameGuess.text = "Your Answer: N/A"
        }
        songName.text = "Correct Answer: \(song.name)"
        if let composer = composerInput, composer != "" {
        composerGuess.text = "Your Answer: \(composer)"
        }else {
        composerGuess.text = "Your Answer: N/A"
        }
        composer.text = "Correct Answer: \(song.composer)"
        if let year = yearInput, year != "" {
          yearGuess.text = "Your Answer: \(year)"
        } else {
            yearGuess.text = "Your Answer: N/A"
        }
        year.text = "Correct Answer: \(song.year)"
        if let movement = movementInput, movement != "" {
           movementGuess.text = "Your Answer: \(movement)"
        } else {
           movementGuess.text = "Your Answer: N/A" 
        }
        movement.text = "Correct Answer: \(song.movement_or_act)"
    }
    
    private func checkAnswers() {
        if setupString(s: songInput) == setupString(s:song.name) {
            songIndicator.image = UIImage(named: "right")
        } else {
            songIndicator.image = UIImage(named: "wrong")
        }
        if setupString(s:composerInput) == setupString(s: song.composer) {
            composerIndicator.image = UIImage(named: "right")
        } else {
            composerIndicator.image = UIImage(named: "wrong")
        }
        if setupString(s:yearInput) == setupString(s:song.year) {
            yearIndicator.image = UIImage(named: "right")
        } else {
          yearIndicator.image = UIImage(named: "wrong")
        }
        if setupString(s: movementInput) == setupString(s: song.movement_or_act) {
            movementIndicator.image = UIImage(named: "right")
        }
        else if setupString(s: song.movement_or_act) == setupString(s:"N/A") {
            movementIndicator.image = UIImage()
        }
        else{
            movementIndicator.image = UIImage(named: "wrong")
        }

    }
    
    @IBAction func playNextSongBtn(_ sender: AnyObject) {
        let parentVC = self.presentingViewController
        // finish finding a smooth transtion to reload music playing VC
        if let parentOfParentVC = parentVC?.presentingViewController as? MusicPlayerVC {
            self.dismiss(animated: false, completion: { 
                parentVC?.dismiss(animated: true, completion: nil)
                parentOfParentVC.viewDidLoad()
            })
        }
    }
    
    @IBAction func homeBtn(_ sender: AnyObject) {
        let parentVC = self.presentingViewController
        let parentOfParentVC = parentVC?.presentingViewController
        self.dismiss(animated: false) { 
            parentVC?.dismiss(animated: false, completion: {
                parentOfParentVC?.dismiss(animated: true, completion: nil)
            })
        }

    }

    private func setupString(s: String) -> String {
        return s.lowercased().replacingOccurrences(of: " ", with: "")
    }
}
