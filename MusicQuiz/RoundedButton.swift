//
//  RoundedButton.swift
//  MusicQuiz
//
//  Created by Yosvani Lopez on 10/15/16.
//  Copyright © 2016 Yosvani Lopez. All rights reserved.
//

import UIKit

class RoundedButton: UIButton {

    override func awakeFromNib() {
        self.layer.cornerRadius = 5.0
        self.clipsToBounds = true 
    }

}
