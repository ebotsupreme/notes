//
//  Note.swift
//  Project19-21
//
//  Created by Eddie Jung on 8/27/21.
//

import UIKit

class Note: Codable {
    var title: String
    var description: String
    var timeStamp: String
    
    init(title: String, description: String, timeStamp: String) {
        self.title = title
        self.description = description
        self.timeStamp = timeStamp
    }
}
