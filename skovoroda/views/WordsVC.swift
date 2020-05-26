//
//  ViewController.swift
//  skovoroda
//
//  Created by Andras Gyacsok on 01.05.20.
//  Copyright © 2020 Andras Gyacsok. All rights reserved.
//

import UIKit


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
        // TODO: Introduce sections or dict selection
        if let wordsDictionary = wordsDictionary {
            print(wordsDictionary.words.count)
            return wordsDictionary.words.count
        }
        return 0
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dictionaryCell", for: indexPath) as! WordCell
        // TODO: Introduce sections or dict selection
        if let wordsDictionary = wordsDictionary {
            let word = wordsDictionary.words[indexPath.row]
            cell.foreignWord.text = word.foreignWord
            cell.transcript.text = word.transcript ?? ""
            cell.translation.text = word.translation
            if word.status.state == .learned {
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
            if word.status.state == .readyForLearning {
                word.status = MemoizationStatus(state: .learned)
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
