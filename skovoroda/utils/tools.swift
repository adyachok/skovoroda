//
//  tools.swift
//  skovoroda
//
//  Created by Andras Gyacsok on 26.05.20.
//  Copyright © 2020 Andras Gyacsok. All rights reserved.
//

import Foundation


func getTimeNow() -> String {
    let df = DateFormatter()
    df.dateFormat = "dd-MM-yyyy hh:mm:ss"
    return  df.string(from: Date())
}
