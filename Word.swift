//
//  Word.swift
//  Project5
//
//  Created by Gabriel Lops on 12/26/19.
//  Copyright © 2019 Gabriel Lops. All rights reserved.
//

import UIKit

class Words: NSCoder, Codable {
    var currentWord = String()
    var usedWords = [String]()
    
    init(currentWord: String, usedWords: [String]){
        self.currentWord = currentWord
        self.usedWords = usedWords
    }
}
