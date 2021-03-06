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
    // I think the most effective way is to learn word
    // by word not jomping to different parts of daily
    // dictionary.
    var currentlyLearnedWordIndex: IndexPath?
    // Every day new DailyDictionary will be created
    // if user follows dictionary link and not learned
    // words are present.
    var dailyDictionary: DailyDictionary?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = wordsDictionary?.name
        self.tableView.delegate = self
        self.tableView.dataSource = self
        navigationItem.largeTitleDisplayMode = .never
        self.prepareDailyDictionary()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "playCardsSegue" {
            let controller = segue.destination as? CardsGameVC
            controller?.wordsDictionary = self.wordsDictionary
        }
    }
}



// MARK: Table data source

extension WordsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let dailyDictionary = dailyDictionary {
            return dailyDictionary.selectedWords.count
        }
        return 0
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dictionaryCell", for: indexPath) as! WordCell
        if let dailyDictionary = dailyDictionary {
            let word = dailyDictionary.selectedWords[indexPath.row]
            cell.foreignWord.text = word.foreignWord
            cell.translation.attributedText = self.prepareTranslation(word.translations)
            if word.partOfSpeech != "" {
                cell.partOfSpeech.text = word.partOfSpeech
            } else {
                cell.partOfSpeech.text = ""
            }
            if word.usage.count > 0 {
                cell.usage.text = word.usage.joined(separator: "\n\n")
            } else {
                cell.usage.text = ""
            }
            if let status = word.status, status.state == .learned {
                cell.backgroundColor = K.learnedWordColor
            } else {
                cell.backgroundColor = UIColor(named: "ApplicationBackgroundColor")
            }
        }
        
        return cell
    }
    
    func prepareTranslation(_ translations: List<Translation>) -> NSMutableAttributedString {
        var translationStrings:[NSMutableAttributedString] = []
        for wordTranslation in translations {
            let translationString = NSMutableAttributedString(string: "")
            if wordTranslation.transcript.count != 0 {
                for transcript in wordTranslation.transcript {
//                    translationString += "\t[\(transcript)]\n"
                    let transcript  = NSMutableAttributedString(string: "[\(transcript)]\n", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13)])
                    translationString.append(transcript)
                }
            }
            translationString.append(NSMutableAttributedString(string: "\(wordTranslation.translation)\n\n"))
            translationStrings.append(translationString)
        }
        let translation = NSMutableAttributedString(string: "")
        for attrString in translationStrings {
            translation.append(attrString)
        }
        return translation
    }
}



// MARK: Table view delegate extension

extension WordsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let dailyDictionary = dailyDictionary {
            let word = dailyDictionary.selectedWords[indexPath.row]
            if let status = word.status, status.state == .readyForLearning {
                let realm = try! Realm()
                try! realm.write {
                    word.status = MemoizationStatus(state: .learned)
                    // Update progress. Simple way. Will use in statistics.
                    dailyDictionary.updateProgress()
                }
                setProgress()
            }
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    private func setProgress() {
        if let dailyDictionary = dailyDictionary {
            let selectedWordsCount = dailyDictionary.selectedWords.count
            if selectedWordsCount > 0 {
                let progress = Float(dailyDictionary.getLearnedWordsCount()) / Float(selectedWordsCount)
                progressBar.progress = progress
                progressLabel.text = String(Int(progress * 100))
            }
        }
    }
}


// MARK: Prepare daily dictionary
extension WordsVC {
    func prepareDailyDictionary() {
        if let wordsDictionary = self.wordsDictionary {
            let wordsDictionaryRef = ThreadSafeReference(to: wordsDictionary)
            // FIXME: Fails on Realm obj accesed from diff thread
            // Possible issue: https://stackoverflow.com/questions/41781775/realm-accessed-from-incorrect-thread-again/41783688
//            DispatchQueue.global().async {
            guard let dailyDict = DailyDictionary.getOrCreate(for: wordsDictionaryRef, words: K.dailyDictionaryWordsQuantity) else {
                    return
                }
//                DispatchQueue.main.async {
                    self.dailyDictionary = dailyDict
                    self.tableView.reloadData()
                    self.setProgress()
//                }
//            }
            
        }
        
    }
    
}
