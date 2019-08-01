//
//  UserController.swift
//  Queues
//
//  Created by Jonathan Ferrer on 7/31/19.
//  Copyright © 2019 Jonathan Ferrer. All rights reserved.
//

import Foundation

class UserController {

    static let shared = UserController()
    private init() {}

    func addForm(form: Form) {
        currentForm = form
        forms.append(form)
    }

    var forms: [Form] = []
    var currentForm: Form?
}
