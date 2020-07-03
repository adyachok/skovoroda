//
//  language.swift
//  skovoroda
//
//  Created by Andras Gyacsok on 26.05.20.
//  Copyright © 2020 Andras Gyacsok. All rights reserved.
//

import UIKit
import RealmSwift

enum Language: String, Codable {
    case English, Hungarian, German
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
