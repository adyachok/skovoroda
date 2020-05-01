//
//  dictionary.swift
//  skovoroda
//
//  Created by Andras Gyacsok on 01.05.20.
//  Copyright © 2020 Andras Gyacsok. All rights reserved.
//

import Foundation


enum Language: String {
    case English, Hungarian, German
}


class WordsDictionary {
    let name: String
    let description: String
    var words: [Word] = []
    let language: Language
    
    init(name: String, description: String, language: Language) {
        self.name = name
        self.description = description
        self.language = language
    }
}


class Word: Decodable {
    var foreignWord: String
    var tanscript: String?
    var translation: String
    
    init(foreignWord: String, translation: String) {
        self.foreignWord = foreignWord
        self.translation = translation
    }
}


extension WordsDictionary {
    public static func loadFixtures() -> WordsDictionary? {
        if let path = Bundle.main.path(forResource: "szotar", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let decoder = JSONDecoder()
                let hu_dict = WordsDictionary(name: "Petra's szotar", description: "Some description", language: .English)
                hu_dict.words = try decoder.decode([Word].self, from: data)
                return hu_dict
              } catch {
                   // handle error
                print("Error occured! \(error.localizedDescription)")
              }
        } else {
            print("No file found!")
        }
        return nil
    }
}
