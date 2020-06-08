//
//  dictionary.swift
//  skovoroda
//
//  Created by Andras Gyacsok on 01.05.20.
//  Copyright © 2020 Andras Gyacsok. All rights reserved.
//

import Foundation
import RealmSwift


class WordsDictionary: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var desc: String = ""
    var words = List<Word>()
    // IMPLEMENTATION OF https://stackoverflow.com/posts/33480806/timeline
    @objc private dynamic var _language: String = ""
    var language: Language {
        get { return Language(rawValue: _language)! }
        set { _language = newValue.rawValue }
    }
    @objc dynamic var dateCreated: String = ""
    @objc dynamic var dateUpdated: String? = ""
    
    convenience init(name: String, description: String, language: Language) {
        self.init()
        self.name = name
        self.desc = description
        self.language = language
        self.dateCreated = getTimeNow()
        self.dateUpdated = getTimeNow()
    }
    
    func getLearnedWordsCount() -> Int {
        return words.filter{
            if let status = $0.status, status.state == .learned
            {return true} else
            {return false}
            
        }.count
    }
    
}


class Word: Object{
    @objc dynamic var foreignWord: String = ""
    @objc dynamic var partOfSpeech: String = ""
    var translations = List<Translation>()
    // SOLUTION FOUND https://santoshm.com.np/2019/11/19/swift-didset-and-willset-on-properties-in-realm-doesnt-work/
    @objc private dynamic var _status: MemoizationStatus?
    var status: MemoizationStatus? {
        get { return _status}
        set {
            if let value = _status {
                self.learningStatistics.append(value)
            }
            _status = newValue
        }
    }        
    var learningStatistics = List<MemoizationStatus>()
    
    convenience init(foreignWord: String, partOfSpeech:String = "", status: MemoizationStatus = MemoizationStatus()) {
        self.init()
        self.foreignWord = foreignWord
        self.status = status
        self.partOfSpeech = partOfSpeech
    }
}


class MemoizationStatus: Object {
    @objc enum State: Int, RealmEnum {
        case readyForLearning = 0
        case inLearning
        case learned
        case needsRenew
    }
    
    @objc dynamic var state: State = .readyForLearning
    @objc dynamic var date: Double = Date().timeIntervalSince1970
    
    convenience init(state: State) {
        self.init()
        self.state = state
    }
}

class Translation: Object {
    @objc dynamic var translation: String = ""
    var transcript = List<String>()
    
    convenience init(translation: String) {
        self.init()
        self.translation = translation
    }
}
