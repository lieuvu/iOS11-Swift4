//
//  Story.swift
//  Destini
//

import Foundation

struct Story {
    let story: String
    let answers: (a: Answer, b: Answer)?
    
    indirect enum Answer {
        case a(String, Story)
        case b(String, Story)
        
        func getAnswer() -> String {
            switch self {
                case .a(let answer, _): return answer
                case .b(let answer, _): return answer
            }
        }
        
        func getStory() -> Story {
            switch self {
                case .a(_, let story): return story
                case .b(_, let story): return story
            }
        }
    }
    
    init(_ story: String, answers: (a: Answer, b: Answer)? = nil) {
        self.story = story
        self.answers = answers
    }
}
