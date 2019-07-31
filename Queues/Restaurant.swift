//
//  Restaurant.swift
//  Queues
//
//  Created by Jonathan Ferrer on 7/30/19.
//  Copyright © 2019 Jonathan Ferrer. All rights reserved.
//

import Foundation

struct Restaurant: Codable {

    let forms: [Form]
    let name: String
    let phone: String
    let times: String
    let id: String
    
}

struct Form: Codable {

    let name: String
    let phone: String
    let partySize: Int
    let id: String
}

