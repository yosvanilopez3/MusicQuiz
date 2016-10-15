//
//  QuizVC.swift
//  MusicQuiz
//
//  Created by Yosvani Lopez on 10/14/16.
//  Copyright © 2016 Yosvani Lopez. All rights reserved.
//

import UIKit

class QuizVC: UIViewController {
    var song: Song!

    @IBOutlet weak var songInput: UITextField!
    @IBOutlet weak var composerInput: UITextField!
    @IBOutlet weak var yearInput: UITextField!
    @IBOutlet weak var movementInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToCheckAnswers" {
            if let destination = segue.destination as? ResultsVC {
                destination.song = song
                destination.songInput = songInput.text
                destination.composerInput = composerInput.text
                destination.yearInput = yearInput.text
                destination.movementInput = movementInput.text
            
            }
        }
    }
    
    @IBAction func doneBtn(_ sender: AnyObject) {
        self.parent?.dismiss(animated: true, completion: nil)
        self.dismiss(animated: true, completion: nil)
    }


}
