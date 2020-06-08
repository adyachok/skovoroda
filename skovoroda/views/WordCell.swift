//
//  WordCellTableViewCell.swift
//  skovoroda
//
//  Created by Andras Gyacsok on 13.05.20.
//  Copyright © 2020 Andras Gyacsok. All rights reserved.
//

import UIKit


class WordCell: UITableViewCell {

    @IBOutlet weak var foreignWord: UILabel!
    @IBOutlet var translation: UILabel!
    @IBOutlet var partOfSpeech: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
