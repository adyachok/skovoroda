//
//  DictionaryCardsCollectionVC.swift
//  skovoroda
//
//  Created by Andras Gyacsok on 22.06.20.
//  Copyright © 2020 Andras Gyacsok. All rights reserved.
//

import UIKit
import RealmSwift

private let reuseIdentifier = "CardCell"

class DictionaryCardsCollectionVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var wordsDictionary: WordsDictionary?  {
        didSet {
            if let wd = wordsDictionary {
                gameDictionary = GameDictionary.build(for: wd)
                collectionView.reloadData()
            }
        }
    }
    var gameDictionary: GameDictionary?

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.isPagingEnabled = true
    }


    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let gd = gameDictionary {
            return gd.words.count
        }
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CardCell
        if let gameDictionary = self.gameDictionary {
            let word = gameDictionary.words[indexPath.row]
            cell.foreignWordLabel.text = word.foreignWord
            cell.foreignWord = word
        } else {
            print("No game dictionary found!")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
}
