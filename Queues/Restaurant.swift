//
//  Restaurant.swift
//  Queues
//
//  Created by Jonathan Ferrer on 7/30/19.
//  Copyright © 2019 Jonathan Ferrer. All rights reserved.
//

import Foundation

class Restaurant: Codable {

    var forms: [Form]
    let name: String
    var phone: String
    var times: String
    let id: String
    var isCelebrationEnabled: Bool
    var isIndoorEnabled: Bool
    var isOutdoorEnabled: Bool
    var isBarEnabled: Bool

    init(forms: [Form] = [], name: String, phone: String, times: String, id: String = UUID().uuidString, isCelebrationEnabled: Bool = false, isIndoorEnabled: Bool = false, isOutdoorEnabled: Bool = false, isBarEnabled: Bool = false) {
        self.forms = forms
        self.name = name
        self.phone = phone
        self.times = times
        self.id = id
        self.isCelebrationEnabled = isCelebrationEnabled
        self.isIndoorEnabled = isIndoorEnabled
        self.isOutdoorEnabled = isOutdoorEnabled
        self.isBarEnabled = isBarEnabled
    }
    
}



