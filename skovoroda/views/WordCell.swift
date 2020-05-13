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
    @IBOutlet weak var transcript: UILabel!
    @IBOutlet weak var translation: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
