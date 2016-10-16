//
//  QuizVC.swift
//  MusicQuiz
//
//  Created by Yosvani Lopez on 10/14/16.
//  Copyright © 2016 Yosvani Lopez. All rights reserved.
//

import UIKit

class QuizVC: UIViewController, UITextFieldDelegate {
    var song: Song!

    @IBOutlet weak var songInput: UITextField!
    @IBOutlet weak var composerInput: UITextField!
    @IBOutlet weak var yearInput: UITextField!
    @IBOutlet weak var movementInput: UITextField!
    var currentTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        songInput.delegate = self
        composerInput.delegate = self
        yearInput.delegate = self
        movementInput.delegate = self
        
        
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        currentTextField = textField
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
    @IBAction func tapOutsideBox(_ sender: AnyObject) {
        if (currentTextField) != nil {
       currentTextField.resignFirstResponder()
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        currentTextField.resignFirstResponder()
        if textField.tag == 1 {
            currentTextField = composerInput
            currentTextField.becomeFirstResponder()
        } else if textField.tag == 2 {
            currentTextField = yearInput
            currentTextField.becomeFirstResponder()
        } else if textField.tag == 3 {
            currentTextField = movementInput
            currentTextField.becomeFirstResponder()
        } else if textField.tag == 4 {
            performSegue(withIdentifier: "goToCheckAnswers", sender: nil)
        }
        return true
    }
    @IBAction func homeBtn(_ sender: AnyObject) {
        let parentVC = self.presentingViewController
        self.dismiss(animated: false, completion: nil)
        parentVC?.dismiss(animated: true, completion: nil)
    }
  
}
