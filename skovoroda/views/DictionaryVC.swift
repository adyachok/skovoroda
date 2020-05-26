//
//  DictionaryTableViewController.swift
//  skovoroda
//
//  Created by Andras Gyacsok on 02.05.20.
//  Copyright © 2020 Andras Gyacsok. All rights reserved.
//

import UIKit


class DictionaryVC: UITableViewController {
    
    var wordsDictionaries: [WordsDictionary] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Dictionaries"
        navigationController?.navigationBar.prefersLargeTitles = true
        checkAndLoadDictionariesFixtures()
    }    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wordsDictionaries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dictionaryCell", for: indexPath) as! DictionaryCell
        guard wordsDictionaries.count > 0 else {
            return cell
        }
        
        let selectedDictionary = wordsDictionaries[indexPath.row]
        cell.dictionary.text = selectedDictionary.name
        cell.flag.image = getDictionaryFlag(language: selectedDictionary.language)
        cell.desc.text = selectedDictionary.description
        cell.dateCreated.text = selectedDictionary.dateCreated
        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("RRRRRR")
        if (segue.identifier == "showDictWordsSegue") {
            var destination = segue.destination as! WordsDictionaryContainer
            if wordsDictionaries.count > 0 {
                if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                    destination.wordsDictionary = wordsDictionaries[indexPath.row]
                }
                
            }
            
        }
    }

}

// MARK: Tools extention

extension DictionaryVC {
    
    // MARK: - Check and load dictionaries
    
    func checkAndLoadDictionariesFixtures() {
        // Method checks for fixtures and uploades them
        DispatchQueue.global().async {
        for dictionary in WordsDictionaryFixture.loadFixtures() {
            let newDict = WordsDictionary(name: dictionary.name, description: dictionary.description, language: dictionary.language)
            if dictionary.words.count > 0 {
                var newWords:[Word] = []
                for word in dictionary.words {
                    let newWord = Word(foreignWord: word.foreignWord, translation: word.translation)
                    if let transcript = word.transcript {
                        newWord.transcript = transcript
                    }
                    newWords.append(newWord)
                }
                newDict.words = newWords
                self.wordsDictionaries.append(newDict)
             }
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
}
