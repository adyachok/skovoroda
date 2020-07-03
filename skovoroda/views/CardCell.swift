//
//  CardCell.swift
//  skovoroda
//
//  Created by Andras Gyacsok on 22.06.20.
//  Copyright © 2020 Andras Gyacsok. All rights reserved.
//

import UIKit


class CardCell: UICollectionViewCell  {
    
    @IBOutlet var foreignWordLabel: UILabel!
    
    var delegate: GameDictionaryScoreUpdate?
    
    var foreignWord: GameWord? {
        didSet {
            if let fw = foreignWord {
                var options: [String] = Array(fw.wrongTranslationOptions)
                options.append(fw.translation)
                options.shuffle()
                self.options = options
                tableView.reloadData()
                foreignWordLabel.text = fw.foreignWord
            }
            
        }
    }
    private var options: [String] = []
    
    @IBOutlet var tableView: UITableView!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setUpTableView()
        
        foreignWordLabel.translatesAutoresizingMaskIntoConstraints =  false
        foreignWordLabel.textAlignment = .center
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        let fwT = foreignWordLabel.topAnchor.constraint(equalTo: topAnchor, constant: 50)
        let fwL = foreignWordLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10)
        let fwTr = foreignWordLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        let fwB = foreignWordLabel.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: -50)
        
        let tvL = tableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20)
        let tvTr = tableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        let tvB = tableView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50)
        
        
        NSLayoutConstraint.activate([fwT, fwL, fwTr, fwB, tvL, tvTr, tvB])
    }
    
    func setUpTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        tableView.isScrollEnabled = false
        tableView.layer.cornerRadius = 5
    }
}

extension CardCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnswerCell", for: indexPath) as! CardAnswersCell
        cell.answer.text = options[indexPath.row]
        cell.backgroundColor = .clear
        if let answer = foreignWord?.lastAnswerSelected {
            if cell.answer.text == foreignWord?.translation {
                cell.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
            } else if answer == cell.answer.text, answer != foreignWord?.translation {
                cell.backgroundColor = .red
            }
        }
        return cell
    }
    
    private func updateCellAccordinglyToAnswers(_ tableView: UITableView, _ indexPath: IndexPath, _ selectedCell: CardAnswersCell, _ updateScore: Bool) {
        if let foreignWord = foreignWord {
            // If right answer
            if let selectedOptionStored = foreignWord.lastAnswerSelected {
                // Get idx of stored selected option and right answer
                let idxSelectedOptionStored = options.firstIndex(where: {$0 == selectedOptionStored})!
                let  idxRightTranslation = options.firstIndex(where: {$0 == foreignWord.translation})!
                
                if idxSelectedOptionStored == idxRightTranslation {
                    let rightCell = tableView.cellForRow(at: IndexPath(item: idxRightTranslation, section: 0)) as! CardAnswersCell
                    rightCell.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
                    if updateScore {
                        self.updateScore(success: true)
                    }
                } else {
                    if indexPath.row == idxSelectedOptionStored {
                        selectedCell.backgroundColor = .red
                        let rightCell = tableView.cellForRow(at: IndexPath(item: idxRightTranslation, section: 0)) as! CardAnswersCell
                        rightCell.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
                        if updateScore {
                            self.updateScore(success: false)
                        }
                    }
                }
            }
        }
    }
    
    func updateScore(success: Bool) {
            self.delegate?.updateGameResults(success: success)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = tableView.cellForRow(at: indexPath) as! CardAnswersCell
        var updateScore = false
        let selectedOption = selectedCell.answer.text!
        if foreignWord?.lastAnswerSelected  == nil {
            self.foreignWord?.lastAnswerSelected = selectedOption
            updateScore = true
        }
        
        updateCellAccordinglyToAnswers(tableView, indexPath, selectedCell, updateScore)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
