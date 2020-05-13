//
//  DictionaryTableViewController.swift
//  skovoroda
//
//  Created by Andras Gyacsok on 02.05.20.
//  Copyright © 2020 Andras Gyacsok. All rights reserved.
//

import UIKit

class DictionaryTableViewController: UITableViewController {
    
    var wordsDictionaries: [WordsDictionary]?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Dictionaries"
        navigationController?.navigationBar.prefersLargeTitles = true
        guard let _ = wordsDictionaries else {
            wordsDictionaries = WordsDictionary.loadFixtures()
            return
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let wordsDictionaries = wordsDictionaries else {
            return 0
        }
        return wordsDictionaries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dictionaryCell", for: indexPath) as! DictionaryCell
        guard let wordsDictionaries = wordsDictionaries, wordsDictionaries.count > 0 else {
            return cell
        }
        
        let selectedDictionary = wordsDictionaries[indexPath.row]
        cell.dictionary.text = selectedDictionary.name
        cell.flag.image = getDictionaryFlag(language: selectedDictionary.language)
        cell.desc.text = selectedDictionary.description
        cell.dateCreated.text = selectedDictionary.dateCreated
        return cell
    }
    
    
    func getDictionaryFlag(language: Language) -> UIImage? {
        switch language {
        case .Hungarian:
            return UIImage(named: "hungary-flag")
        case .German:
            return UIImage(named: "germany-flag")
        case .English:
            return UIImage(named: "united-kingdom-flag")
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showDictWordsSegue") {
            var destination = segue.destination as! WordsDictionaryContainer
            if let wordsDictionaries = wordsDictionaries {
                if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                    destination.wordsDictionary = wordsDictionaries[indexPath.row]
                }
                
            }
            
        }
    }

   

}
