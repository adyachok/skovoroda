//
//  ViewController.swift
//  skovoroda
//
//  Created by Andras Gyacsok on 01.05.20.
//  Copyright © 2020 Andras Gyacsok. All rights reserved.
//

import UIKit

class DictionaryWordsViewController: UITableViewController, WordsDictionaryContainer {
    
    
    var wordsDictionary: WordsDictionary?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = wordsDictionary?.name
        navigationController?.navigationBar.prefersLargeTitles = true

    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // TODO: Introduce sections or dict selection
        if let wordsDictionary = wordsDictionary {
            return wordsDictionary.words.count
        }
        return 0
    }
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dictionaryCell", for: indexPath) as! WordCell
        // TODO: Introduce sections or dict selection
        if let wordsDictionary = wordsDictionary {
            let word = wordsDictionary.words[indexPath.row]
            cell.foreignWord.text = word.foreignWord
            cell.transcript.text = word.tanscript ?? ""
            cell.translation.text = word.translation
        }
        
        return cell
    }


}

