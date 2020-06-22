//
//  CardCell.swift
//  skovoroda
//
//  Created by Andras Gyacsok on 22.06.20.
//  Copyright © 2020 Andras Gyacsok. All rights reserved.
//

import UIKit


class CardCell: UICollectionViewCell  {
    
    @IBOutlet var foreignWord: UILabel!
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var cardButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setUpTableView()
        
        foreignWord.translatesAutoresizingMaskIntoConstraints =  false
        foreignWord.textAlignment = .center
        tableView.translatesAutoresizingMaskIntoConstraints = false
        cardButton.translatesAutoresizingMaskIntoConstraints = false
        
        let fwT = foreignWord.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 12)
        let fwL = foreignWord.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 10)
        let fwTr = foreignWord.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -10)
        let fwB = foreignWord.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: -50)
        
        let tvL = tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20)
        let tvTr = tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20)
        let tvB = tableView.bottomAnchor.constraint(equalTo: cardButton.topAnchor, constant: -50)
        
        let cbL = cardButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20)
        let cbTr = cardButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20)
        let cbB = cardButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -50)
        
        NSLayoutConstraint.activate([fwT, fwL, fwTr, fwB, tvL, tvTr, tvB, cbL, cbTr, cbB])
    }
    
    func setUpTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        tableView.isScrollEnabled = false
        tableView.layer.cornerRadius = 5
    }
}

extension CardCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnswerCell", for: indexPath) as! CardAnswersCell
        cell.answer.text = "A Lorem Ipsum egy egyszerû szövegrészlete, szövegutánzata a betûszedõ és nyomdaiparnak. A Lorem Ipsum az 1500-as évek óta standard szövegrészletként szolgált az iparban; mikor egy ismeretlen nyomdász összeállította a betûkészletét és egy példa-könyvet vagy szöveget nyomott papírra, ezt használta. Nem csak 5 évszázadot élt túl, de az elektronikus betûkészleteknél is változatlanul megmaradt. Az 1960-as években népszerûsítették a Lorem Ipsum részleteket magukbafoglaló Letraset lapokkal, és legutóbb softwarekkel mint például az Aldus Pagemaker."
        return cell
    }
}
