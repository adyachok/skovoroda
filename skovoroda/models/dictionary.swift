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
    public static func loadFixtures() -> [WordsDictionary] {
        var dictionaries: [WordsDictionary] = []
        let urls = Bundle.main.urls(forResourcesWithExtension: "json", subdirectory: "fixtures")
        if let urls = urls, urls.count > 0 {
            for url in urls {
                do {
                    let data = try Data(contentsOf: url, options: .mappedIfSafe)
                    let decoder = JSONDecoder()
                    let dict = WordsDictionary(name: "Petra's szotar", description: "Some description", language: .Hungarian)
                    dict.words = try decoder.decode([Word].self, from: data)
                    dictionaries.append(dict)
                } catch {
                     // handle error
                  print("Error occured! \(error.localizedDescription)")
                }
            }
            
        } else {
            print("No file found!")
        }
        return dictionaries
    }
}
