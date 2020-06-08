//
//  WordCellTableViewCell.swift
//  skovoroda
//
//  Created by Andras Gyacsok on 13.05.20.
//  Copyright © 2020 Andras Gyacsok. All rights reserved.
//

import UIKit
import RealmSwift

class WordCell: UITableViewCell, UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet var translationTable: UITableView!
    var translations = List<Translation>()

    @IBOutlet weak var foreignWord: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style , reuseIdentifier: reuseIdentifier)
        setUpTable()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.setUpTable()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setUpTable()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUpTable(){
        translationTable?.delegate = self
        translationTable?.dataSource = self
//        self.addSubview(translationTable)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return translations.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "translationCell", for: indexPath) as! TranslationCell
        let wordTranslation = self.translations[indexPath.row]
        cell.translation.text = wordTranslation.translation

        var transcript = ""
        for t in wordTranslation.transcript {
            transcript += t
        }
        cell.transcript.text = transcript
        
      return cell
    }

}
