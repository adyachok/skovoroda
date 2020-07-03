//
//  CardsVC.swift
//  skovoroda
//
//  Created by Andras Gyacsok on 30.06.20.
//  Copyright © 2020 Andras Gyacsok. All rights reserved.
//

import UIKit


private let reuseIdentifier = "CardCell"


class CardsGameVC: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var scoreValue: UILabel!
    @IBOutlet var paginator: UILabel!
    @IBOutlet var mistakesValue: UILabel!
    
    var wordsDictionary: WordsDictionary?  {
        didSet {
            if let wd = wordsDictionary {
                gameDictionary = GameDictionary.build(for: wd)
            }
        }
    }
    var gameDictionary: GameDictionary?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.isPagingEnabled = true
        collectionView.delegate = self
        collectionView.dataSource = self
        navigationItem.largeTitleDisplayMode = .never
        updateScore()
    }

}

// MARK: Collection View extension

extension CardsGameVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let gd = gameDictionary {
            return gd.words.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CardCell
        if let gameDictionary = self.gameDictionary {
            let word = gameDictionary.words[indexPath.row]
            cell.foreignWord = word
            cell.delegate = self
            paginator.text = "\(indexPath.row + 1) / \(gameDictionary.words.count)"
        } else {
            print("No game dictionary found!")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    private func updateScore() {
        if let gd = gameDictionary {
            scoreValue.text = String(gd.score)
            mistakesValue.text = String(gd.mistakes)
        }
    }
}

// MARK: Update game results protocol implemenation
extension CardsGameVC: GameDictionaryScoreUpdate {
    func updateGameResults(success: Bool) {
        if success {
            self.gameDictionary?.score += 1
        } else {
            self.gameDictionary?.mistakes += 1
        }
        updateScore()
    }
    
}

