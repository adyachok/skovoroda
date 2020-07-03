//
//  protocols.swift
//  skovoroda
//
//  Created by Andras Gyacsok on 02.05.20.
//  Copyright © 2020 Andras Gyacsok. All rights reserved.
//

import Foundation


protocol WordsDictionaryContainer {
    var wordsDictionary: WordsDictionary? {get set}
}

protocol GameDictionaryScoreUpdate {
    func updateGameResults(success: Bool)
}
