//
//  dictionary.swift
//  skovoroda
//
//  Created by Andras Gyacsok on 01.05.20.
//  Copyright © 2020 Andras Gyacsok. All rights reserved.
//

import Foundation


enum Language: String, Decodable {
    case English, Hungarian, German
}


class WordsDictionary: Decodable {
    let name: String
    let description: String
    var words: [Word] = []
    let language: Language
    var dateCreated: String
    var dateUpdated: String?
    
    init(name: String, description: String, language: Language, dateCreated: String?, dateUpdated: String?) {
        self.name = name
        self.description = description
        self.language = language
        if let dateCreated = dateCreated {
            self.dateCreated = dateCreated
        } else {
            self.dateCreated = getTimeNow()
        }
        if let dateUpdated = dateUpdated {
            self.dateUpdated = dateUpdated
        } else {
            self.dateUpdated = self.dateCreated
        }
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
                    let dict = try decoder.decode(WordsDictionary.self, from: data)
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


func getTimeNow() -> String {
    let df = DateFormatter()
    df.dateFormat = "dd-MM-yyyy hh:mm:ss"
    return  df.string(from: Date())
}
