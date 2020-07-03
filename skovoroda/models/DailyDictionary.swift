//
//  Word.swift
//  skovoroda
//
//  Created by Andras Gyacsok on 23.06.20.
//  Copyright © 2020 Andras Gyacsok. All rights reserved.
//

import UIKit
import RealmSwift


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

        let selectedWords = Array(selectedWordsList.prefix(K.dailyDictionaryWordsQuantity))
        
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

