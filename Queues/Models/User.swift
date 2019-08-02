//
//  User.swift
//  Queues
//
//  Created by Jonathan Ferrer on 8/1/19.
//  Copyright © 2019 Jonathan Ferrer. All rights reserved.
//

import Foundation

class User: Codable {

    var name: String
    var phone: String
    var email: String

    init(name: String, phone: String, email: String) {
        self.name = name
        self.phone = phone
        self.email = email
    }




}
