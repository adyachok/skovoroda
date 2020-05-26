//
//  dictionary.swift
//  skovoroda
//
//  Created by Andras Gyacsok on 01.05.20.
//  Copyright © 2020 Andras Gyacsok. All rights reserved.
//

import Foundation


class WordsDictionary {
    let name: String
    let description: String
    var words: [Word] = []
    let language: Language
    var dateCreated: String
    var dateUpdated: String?
    
    init(name: String, description: String, language: Language) {
        self.name = name
        self.description = description
        self.language = language
        self.dateCreated = getTimeNow()
        self.dateUpdated = getTimeNow()
    }
    
    func getLearnedWordsCount() -> Int {
        return words.filter{$0.status.state == .learned}.count
    }
    
}


class Word {
    var foreignWord: String
    var transcript: String?
    var translation: String
    var status: MemoizationStatus
    
    init(foreignWord: String, translation: String, status: MemoizationStatus = MemoizationStatus()) {
        self.foreignWord = foreignWord
        self.translation = translation
        self.status = status
    }
}


class MemoizationStatus {
    enum State: String {
        case readyForLearning, inLearning, learned, needsRenew
    }
    
    var state: State
    var date: Double
    
    init(state: State = .readyForLearning) {
        self.state = state
        self.date = Date().timeIntervalSince1970
    }
}

