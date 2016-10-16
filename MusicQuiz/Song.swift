//
//  Song.swift
//  MusicQuiz
//
//  Created by Yosvani Lopez on 10/14/16.
//  Copyright © 2016 Yosvani Lopez. All rights reserved.
//

import Foundation
class Song {
    private var _path: String!
    private var _name: String!
    private var _composer: String!
    private var _year: String!
    private var _movement_or_act: String!
    
    var path: String {
        return _path
    }
    var name: String {
        return _name
    }
    var composer: String {
        return _composer
    }
    
    var year: String {
        return _year
    }
    
    var movement_or_act: String {
        return _movement_or_act
    }
    
    init(path: String, composer: String, name:String, year: String, extra: String = "N/A") {
        self._path = path
        self._name = name
        self._composer = composer
        self._year = year
        self._movement_or_act = extra
    }
    
    
    
}
