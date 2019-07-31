//
//  RestaurantController.swift
//  Queues
//
//  Created by Jonathan Ferrer on 7/30/19.
//  Copyright © 2019 Jonathan Ferrer. All rights reserved.
//

import Foundation

class RestaurantController {

    static let shared = RestaurantController()
    private init() {}

    var restaurantID: String?
    var currentRestaurant: Restaurant?
    var forms: [Form] = []

    


}
