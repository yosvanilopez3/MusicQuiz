//
//  ShadowedView.swift
//  MusicQuiz
//
//  Created by Yosvani Lopez on 10/16/16.
//  Copyright © 2016 Yosvani Lopez. All rights reserved.
//

import UIKit

class ShadowedView: UIView {

    let SHADOW_COLOR: CGFloat = 157/255
    
    override func awakeFromNib() {
        layer.borderColor = UIColor(red: SHADOW_COLOR, green: SHADOW_COLOR, blue: SHADOW_COLOR, alpha: 0.6).cgColor
        layer.borderWidth = 1.0
    }

}
