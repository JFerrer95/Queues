//
//  Form.swift
//  Queues
//
//  Created by Jonathan Ferrer on 7/30/19.
//  Copyright © 2019 Jonathan Ferrer. All rights reserved.
//

import Foundation

class Form: Codable {
    let name: String
    let phone: String
    let partySize: Int
    let timestamp: Double
    let celebration: String?
    let seating: String?
    let id: String

    init(name: String, phone: String, partySize: Int, timestamp: Double = Date().timeIntervalSince1970, celebration: String, seating: String, id: String = UUID().uuidString) {
        self.name = name
        self.phone = phone
        self.partySize = partySize
        self.timestamp = timestamp
        self.celebration = celebration
        self.seating = seating
        self.id = id
    }
}
