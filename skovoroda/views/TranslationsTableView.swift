//
//  TranslationsTableView.swift
//  skovoroda
//
//  Created by Andras Gyacsok on 08.06.20.
//  Copyright © 2020 Andras Gyacsok. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class TranslationsTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.delegate = self
        self.dataSource = self
        self.translations = List<Translation>()
    }

    var translations: List<Translation> {
    didSet {
            self.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.translations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: "translationCell") as! TranslationCell
//        if let translation = try? self.translations[indexPath.row] {
//
//        }
        return cell
    }
    
    
    
    
}
