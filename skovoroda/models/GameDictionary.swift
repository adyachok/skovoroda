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
    
    init(words: [Word]) {
        self.words = buildGameWords(words: words)
    }
    
    func buildGameWords(words: [Word]) -> [GameWord] {
        let gameWords: [GameWord] = []
        for word in words {
            let gameWord = GameWord(foreignWord: word.foreignWord,
                                    translation: joinTranslations(translations: word.translations))
            gameWord.wrongTranslationOptions = getRandomNotCorrectTranslationOptions(
                selectedWord: word,
                words: words)
            self.words.append(gameWord)
            
        }
        return gameWords
    }
    
    func getRandomNotCorrectTranslationOptions(selectedWord: Word, words: [Word]) -> Set<String> {
        var options = Set<String>()
        while options.count < 4 {
            if let word = words.randomElement(), word !== selectedWord {
                options.insert(
                    joinTranslations(translations: word.translations)
                )
            }
        }
        return options
    }
    
    func joinTranslations(translations:List<Translation>) -> String {
        return translations.map{$0.translation}.joined(separator: "\n")
    }
    
}

class GameWord {
    var foreignWord: String
    var translation: String
    var wrongTranslationOptions = Set<String>()
    
    init(foreignWord: String, translation: String) {
        self.foreignWord = foreignWord
        self.translation = translation
    }
    
}
