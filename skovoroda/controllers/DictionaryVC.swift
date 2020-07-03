//
//  DictionaryTableViewController.swift
//  skovoroda
//
//  Created by Andras Gyacsok on 02.05.20.
//  Copyright © 2020 Andras Gyacsok. All rights reserved.
//

import UIKit
import RealmSwift


class DictionaryVC: UITableViewController {
    
    var wordsDictionaries: Results<WordsDictionary>?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Dictionaries"
        navigationItem.largeTitleDisplayMode = .never
        checkAndLoadDictionariesFixtures()
        _ = try! Realm()
//        print(Realm.Configuration.defaultConfiguration.fileURL)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let dictionaries  = wordsDictionaries {
            return dictionaries.count
        } else {
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dictionaryCell", for: indexPath) as! DictionaryCell
        guard let dictionaries = wordsDictionaries, dictionaries.count > 0 else {
            return cell
        }
        
        let selectedDictionary = dictionaries[indexPath.row]
        cell.dictionary.text = selectedDictionary.name
        cell.flag.image = getDictionaryFlag(language: selectedDictionary.language)
        cell.desc.text = selectedDictionary.desc
        cell.dateCreated.text = selectedDictionary.dateCreated
        cell.dictionaryProgress = Float(selectedDictionary.getLearnedWordsCount()) / Float(selectedDictionary.words.count) * 100
        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showDictWordsSegue") {
            var destination = segue.destination as! WordsDictionaryContainer
            if let dictionaries = wordsDictionaries, dictionaries.count > 0 {
                if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                    destination.wordsDictionary = dictionaries[indexPath.row]
                }
                
            }
            
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

// MARK: Tools extention

extension DictionaryVC {
    
    // MARK: - Check and load dictionaries
    
    func checkAndLoadDictionariesFixtures() {
        // Method checks for fixtures and uploades them
        DispatchQueue.global().async {
        for dictionary in WordsDictionaryFixture.loadFixtures() {
            if self.isDictionaryInDatabase(check: dictionary.name) {
                print("Dictionary with name \(dictionary.name) is in the database already.")
                continue
            }
            let newDict = WordsDictionary(name: dictionary.name, description: dictionary.description, language: dictionary.language)
            if dictionary.words.count > 0 {
                let newWords = List<Word>()
                for word in dictionary.words {
                    let newWord = Word(foreignWord: word.foreignWord)
                    if let partOfSpeech = word.partOfSpeech {
                        newWord.partOfSpeech = partOfSpeech
                    }
                    if let testString = word.test {
                        newWord.test = testString
                    }
                    for translation in word.translations {
                        
                        let wordTranslation = Translation(translation: translation.translation)
                        for transcript in translation.transcript {
                            wordTranslation.transcript.append(transcript)
                        }
                        if let partOfSpeech = translation.partOfSpeech {
                            wordTranslation.partOfSpeech = partOfSpeech
                        }
                        newWord.translations.append(wordTranslation)
                    }
                    if let usage = word.usage {
                        if usage.count > 0 {
                            for sentence in usage {
                                newWord.usage.append(sentence)
                            }
                        }
                    }
                    
                    newWords.append(newWord)
                }
                newDict.words = newWords
                autoreleasepool {
                    let realm = try! Realm()
                    try! realm.write {
                        realm.add(newDict)

                    }
                }
             }
            }
            DispatchQueue.main.async {
                self.wordsDictionaries = self.getAllDictionaries()
                self.tableView.reloadData()
                
            }
        }
    }
    
    func getAllDictionaries() -> Results<WordsDictionary> {
        let realm = try! Realm()
        return realm.objects(WordsDictionary.self)
    }
    
    func isDictionaryInDatabase(check name: String) -> Bool {
        let realm = try! Realm()
        let predicate = NSPredicate(format: "name = %@", name)
        return realm.objects(WordsDictionary.self).filter(predicate).count > 0
    }
    
}
