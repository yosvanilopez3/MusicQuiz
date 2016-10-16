//
//  RoundedButton.swift
//  MusicQuiz
//
//  Created by Yosvani Lopez on 10/15/16.
//  Copyright © 2016 Yosvani Lopez. All rights reserved.
//

import UIKit

class RoundedButton: UIButton {
    let SHADOW_COLOR: CGFloat = 157/255
    
    override func awakeFromNib() {
        self.layer.cornerRadius = 3.0
        layer.borderColor = UIColor(red: SHADOW_COLOR, green: SHADOW_COLOR, blue: SHADOW_COLOR, alpha: 0.5).cgColor
        layer.borderWidth = 1.0
        self.clipsToBounds = true 
    }

}
