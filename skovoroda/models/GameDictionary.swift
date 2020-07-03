//
//  GameDictionary.swift
//  skovoroda
//
//  Created by Andras Gyacsok on 22.06.20.
//  Copyright © 2020 Andras Gyacsok. All rights reserved.
//

import Foundation
import RealmSwift


class GameDictionary {
    
    var words = [GameWord]()
    var score: Int = 0
    var mistakes: Int = 0
    
    init(words: [Word]) {
        self.words = buildGameWords(words: words)
    }
    
    func buildGameWords(words: [Word]) -> [GameWord] {
        var gameWords: [GameWord] = []
        // There is no need to build game if learned words.count < 9
        if words.count > K.minLearnedWordsTestStartLimit {
            for word in words {
                let gameWord = GameWord(foreignWord: word.foreignWord,
                                        translation: !word.test.isEmpty ? word.test : joinTranslations(translations: word.translations))
                gameWord.wrongTranslationOptions = getRandomNotCorrectTranslationOptions(
                    selectedWord: word,
                    words: words)
                gameWords.append(gameWord)
                
            }
        } else {
            print("Not enough learned words: \(words.count)")
        }
        return gameWords
    }
    
    func getRandomNotCorrectTranslationOptions(selectedWord: Word, words: [Word]) -> Set<String> {
        var options = Set<String>()
        while options.count < 3 {
            if let word = words.randomElement(), word !== selectedWord {
                options.insert(
                    !word.test.isEmpty ? word.test : joinTranslations(translations: word.translations)
                )
            }
        }
        return options
    }
    
    func joinTranslations(translations:List<Translation>) -> String {
        return translations.map{$0.translation}.joined(separator: ";")
    }
    
}

class GameWord {
    var foreignWord: String
    var translation: String
    var wrongTranslationOptions = Set<String>()
    // When user selects answer it will be stored here
    var lastAnswerSelected: String?
    
    init(foreignWord: String, translation: String) {
        self.foreignWord = foreignWord
        self.translation = translation
    }
    
}

extension GameDictionary {
    static func build(for wordsDictionary: WordsDictionary) -> GameDictionary {
        let states: [MemoizationStatus.State] = [.learned, .needsRenew]
        let selectedWordsLazyList = wordsDictionary.words.filter{states.contains($0.status!.state)}
        let selectedWordsList = Array(selectedWordsLazyList)
        let gameDictionary = GameDictionary(words: selectedWordsList)
        return gameDictionary
    }
    
    static func build(for wordsDictionaryRef: ThreadSafeReference<WordsDictionary>) -> GameDictionary? {
        let realm = try! Realm()
        guard let wordsDictionary = realm.resolve(wordsDictionaryRef)  else {
            print("Cannot resolve dictionary!")
            return nil
        }
        return build(for: wordsDictionary)
    }
    
}

