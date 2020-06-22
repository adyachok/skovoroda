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
    var usage = List<String>()
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
    @objc dynamic var partOfSpeech: String = ""
    var transcript = List<String>()
    
    convenience init(translation: String) {
        self.init()
        self.translation = translation
    }
}

class DailyDictionary: Object {
    @objc dynamic var wordsDictionary: WordsDictionary? = nil
    var selectedWords = List<Word>()
    @objc dynamic var progress: Float = 0
    @objc dynamic var creationDate: Date = Date()
    
    convenience init(wordsDictionary: WordsDictionary) {
        self.init()
        self.wordsDictionary = wordsDictionary
    }
    
    convenience init(wordsDictionary: WordsDictionary, selectedWords: [Word]) {
        self.init()
        self.wordsDictionary = wordsDictionary
        for word in selectedWords {
            self.selectedWords.append(word)
        }
    }
}

extension DailyDictionary {
    // TODO: move this extension's logic to repository
    static func build(for wordsDictionary: WordsDictionary, words number: Int) -> DailyDictionary {
        let states = [MemoizationStatus.State.readyForLearning, MemoizationStatus.State.inLearning]
        let selectedWordsList = wordsDictionary.words.filter{states.contains($0.status!.state)}

        let selectedWords = Array(selectedWordsList.prefix(10))
        
        let dailyDictionary = DailyDictionary(wordsDictionary: wordsDictionary, selectedWords: selectedWords)
        let realm = try! Realm()
        try! realm.write {
            realm.add(dailyDictionary)
        }
        return dailyDictionary
    }
    
    static func build(for wordsDictionaryRef: ThreadSafeReference<WordsDictionary>, words number: Int) -> DailyDictionary? {
        let realm = try! Realm()
        guard let wordsDictionary = realm.resolve(wordsDictionaryRef)  else {
            print("Cannot resolve dictionary!")
            return nil
        }
        return build(for: wordsDictionary, words: number)
    }
    
    static func getOrCreate(for wordsDictionaryRef: ThreadSafeReference<WordsDictionary>, words number: Int) -> DailyDictionary? {
        let realm = try! Realm()
        guard let wordsDictionary = realm.resolve(wordsDictionaryRef)  else {
            print("Cannot resolve dictionary!")
            return nil
        }
        let todaysTimeInterval = getTodayStartEndTimeInterval()
        if let dailyDict = realm.objects(DailyDictionary.self)
            .filter("creationDate BETWEEN %@ AND wordsDictionary = %@ ",
                    [todaysTimeInterval.startTime, todaysTimeInterval.endTime],
                    wordsDictionary).first {
            return dailyDict
        } else {
            return DailyDictionary.build(for: wordsDictionary, words: number)
        }
    }
    
    func getLearnedWordsCount() -> Int {
        return selectedWords.filter{
            if let status = $0.status, status.state == .learned
            {return true} else
            {return false}
            
        }.count
    }
    
    func updateProgress() {
        // Should not be calculated property, because one word can be learned in multiple
        // daily dictionaries, so all will point on the same word. This will make traking
        // progress impossible.
        // Method should be triggered every time a word is learned, and object shuld be saved.
        self.progress = Float(self.getLearnedWordsCount()) / Float(self.selectedWords.count)
    }
    
    static func getTodayStartEndTimeInterval() -> (startTime: Date, endTime: Date) {
        let todayStart = Calendar.current.startOfDay(for: Date())
        let todayEnd: Date = {
          let components = DateComponents(day: 1, second: -1)
          return Calendar.current.date(byAdding: components, to: todayStart)!
        }()
        return (startTime: todayStart, endTime: todayEnd)
    }
}
