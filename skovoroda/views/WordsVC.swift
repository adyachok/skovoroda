//
//  ViewController.swift
//  skovoroda
//
//  Created by Andras Gyacsok on 01.05.20.
//  Copyright © 2020 Andras Gyacsok. All rights reserved.
//

import UIKit
import RealmSwift


class WordsVC: UIViewController, WordsDictionaryContainer {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var progressLabel: UILabel!
    var wordsDictionary: WordsDictionary?
    var currentlyLearnedWordIndex: IndexPath?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = wordsDictionary?.name
        self.tableView.delegate = self
        self.tableView.dataSource = self
        navigationController?.navigationBar.prefersLargeTitles = true
        setProgress()
    }
}



// MARK: Table data source

extension WordsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let wordsDictionary = wordsDictionary {
            return wordsDictionary.words.count
        }
        return 0
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dictionaryCell", for: indexPath) as! WordCell
        if let wordsDictionary = wordsDictionary {
            let word = wordsDictionary.words[indexPath.row]
            cell.foreignWord.text = word.foreignWord
            cell.transcript.text = word.transcript ?? ""
            cell.translation.text = word.translation
            if let status = word.status, status.state == .learned {
                cell.backgroundColor = K.learnedWordColor
            } else {
                cell.backgroundColor = K.readyForLearningColor
            }
        }
        
        return cell
    }
}



// MARK: Table view delegate extension

extension WordsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let wordsDictionary = wordsDictionary {
            let word = wordsDictionary.words[indexPath.row]
            if let status = word.status, status.state == .readyForLearning {
                let realm = try! Realm()
                try! realm.write {
                    word.status = MemoizationStatus(state: .learned)
                }
                setProgress()
            }
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    private func setProgress() {
        if let wordsDictionary = wordsDictionary {
            let progress = Float(wordsDictionary.getLearnedWordsCount()) / Float(wordsDictionary.words.count)
            progressBar.progress = progress
            progressLabel.text = String(Int(progress * 100))
        }
    }
}
