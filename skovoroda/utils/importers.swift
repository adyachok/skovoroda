//
//  importers.swift
//  skovoroda
//
//  Created by Andras Gyacsok on 26.05.20.
//  Copyright © 2020 Andras Gyacsok. All rights reserved.
//

import Foundation


class WordsDictionaryFixture: Decodable {
    let name: String
    let description: String
    var words: [WordFixture] = []
    let language: Language

    
    init(name: String, description: String, language: Language) {
        self.name = name
        self.description = description
        self.language = language
    }
}


class WordFixture: Decodable {
    var foreignWord: String
    var transcript: String?
    var translation: String
    var learned: Bool? = false
    
    init(foreignWord: String, translation: String) {
        self.foreignWord = foreignWord
        self.translation = translation
    }
}


extension WordsDictionaryFixture {
    public static func loadFixtures() -> [WordsDictionaryFixture] {
        var dictionaries: [WordsDictionaryFixture] = []
        let urls = Bundle.main.urls(forResourcesWithExtension: "json", subdirectory: "fixtures")
        if let urls = urls, urls.count > 0 {
            for url in urls {
                do {
                    let data = try Data(contentsOf: url, options: .mappedIfSafe)
                    let decoder = JSONDecoder()
                    let dict = try decoder.decode(WordsDictionaryFixture.self, from: data)
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
