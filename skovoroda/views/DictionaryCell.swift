//
//  DictionaryCell.swift
//  skovoroda
//
//  Created by Andras Gyacsok on 13.05.20.
//  Copyright © 2020 Andras Gyacsok. All rights reserved.
//

import UIKit
import UICircularProgressRing


class DictionaryCell: UITableViewCell {

    @IBOutlet weak var dictionary: UILabel!
    @IBOutlet weak var flag: UIImageView!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var dateCreated: UILabel!
    @IBOutlet var progressStatus: UIView!
    // 40 % set for debugging purpose
    var dictionaryProgress: Float = 40.0 {
        didSet {
            drawProgress()
        }
    }
    let progressRing = UICircularProgressRing()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // Change any of the properties you'd like
        progressRing.maxValue = 100
        progressRing.style =  .ontop
        progressRing.outerRingWidth = 4.0
        progressRing.innerRingWidth = 3.0
        progressRing.font = UIFont.systemFont(ofSize: 13)
        progressRing.innerRingColor = UIColor(named: "SuccessColor")!
        progressRing.outerRingColor = UIColor(named: "ApplicationGrayColor")!


        progressStatus.addSubview(progressRing)
        progressRing.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            progressRing.centerYAnchor.constraint(equalTo: progressStatus.centerYAnchor),
            progressRing.centerYAnchor.constraint(equalTo: progressStatus.centerYAnchor),
            progressRing.heightAnchor.constraint(equalTo: progressStatus.widthAnchor, constant: -6),
            progressRing.widthAnchor.constraint(equalTo: progressStatus.widthAnchor, constant: -6)
        ])
        drawProgress()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func drawProgress() {
        progressRing.startProgress(to: CGFloat(dictionaryProgress), duration: 2.0) {
          // Do anything your heart desires...
        }
    }

}
