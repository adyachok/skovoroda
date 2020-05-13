//
//  DictionaryCell.swift
//  skovoroda
//
//  Created by Andras Gyacsok on 13.05.20.
//  Copyright © 2020 Andras Gyacsok. All rights reserved.
//

import UIKit

class DictionaryCell: UITableViewCell {

    @IBOutlet weak var dictionary: UILabel!
    @IBOutlet weak var flag: UIImageView!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var dateCreated: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
