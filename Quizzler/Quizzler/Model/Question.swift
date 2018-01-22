//
//  Question.swift
//  Quizzler
//
//  Created by Lieu Vu on 1/9/18.
//  Copyright © 2018 London App Brewery. All rights reserved.
//

import Foundation

struct Question {
    
    let questionText: String
    let answer: Bool
    
    init(questionText: String, answer: Bool) {
        self.questionText = questionText
        self.answer = answer
    }
}
