//
//  UserController.swift
//  Queues
//
//  Created by Jonathan Ferrer on 7/31/19.
//  Copyright © 2019 Jonathan Ferrer. All rights reserved.
//

import Foundation

class UserController {

    init() {
        let userDefaults = UserDefaults.standard
        if userDefaults.bool(forKey: "currentFormSet") {
            loadFormFromPersistentStore()
        }

        if userDefaults.bool(forKey: "user") {
            loadUserFromPersistentStore()
        }
    }

    func saveFormToPersitentStore() {
        guard let url = formURL else { return }

        do {
            let encoder = PropertyListEncoder()
            let data = try encoder.encode(currentForm)
            try data.write(to: url)
        } catch {
            print("Error saving stars: \(error)")
        }
    }

    func saveUserToPersitentStore() {
        guard let url = userURL else { return }

        do {
            let encoder = PropertyListEncoder()
            let data = try encoder.encode(user)
            try data.write(to: url)
        } catch {
            print("Error saving stars: \(error)")
        }
    }



    func loadFormFromPersistentStore() {
        // Make sure file exists
        let fileManager = FileManager.default
        guard let url = formURL, fileManager.fileExists(atPath: url.path) else {
            print("load failed to find file")
            return }

        // Load and decode
        do {
            let data = try Data(contentsOf: url)
            let decoder = PropertyListDecoder()
            currentForm = try decoder.decode(Form.self, from: data)
        } catch {
            print("Error loading data from disk: \(error)")
        }
    }

    func loadUserFromPersistentStore() {
        // Make sure file exists
        let fileManager = FileManager.default
        guard let url = userURL, fileManager.fileExists(atPath: url.path) else {
            print("load failed to find file")
            return }

        // Load and decode
        do {
            let data = try Data(contentsOf: url)
            let decoder = PropertyListDecoder()
            user = try decoder.decode(User.self, from: data)
        } catch {
            print("Error loading data from disk: \(error)")
        }
    }



    func addForm(form: Form) {
        currentForm = form
        forms.append(form)
    }

    private var formURL: URL? {
        let fileManager = FileManager.default
        guard let documents = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        print("Documents: \(documents.path)")
        return documents.appendingPathComponent("currentForm.plist")
    }

    private var userURL: URL? {
        let fileManager = FileManager.default
        guard let documents = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        print("Documents: \(documents.path)")
        return documents.appendingPathComponent("user.plist")
    }

    static let shared = UserController()
    var forms: [Form] = []
    var currentForm: Form? {
        didSet {
            let userDefaults = UserDefaults.standard
            userDefaults.set(true, forKey: "currentFormSet")
            saveFormToPersitentStore()
        }
    }

    var user: User?{
        didSet {
        let userDefaults = UserDefaults.standard
        userDefaults.set(true, forKey: "user")
        saveUserToPersitentStore()
    }
    }
}
