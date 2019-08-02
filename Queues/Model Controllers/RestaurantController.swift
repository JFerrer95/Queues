//
//  RestaurantController.swift
//  Queues
//
//  Created by Jonathan Ferrer on 7/30/19.
//  Copyright © 2019 Jonathan Ferrer. All rights reserved.
//

import Foundation

class RestaurantController {

    private init() {

        let userDefaults = UserDefaults.standard
        if userDefaults.bool(forKey: "currentRestaurant") {
            loadFromPersistentStore()
        }
        if userDefaults.bool(forKey: "forms") {
            loadFormsFromPersistentStore()
        }

    }

    func saveToPersitentStore() {
        guard let url = persistentURL else { return }

        do {
            let encoder = PropertyListEncoder()
            let data = try encoder.encode(currentRestaurant)
            try data.write(to: url)
        } catch {
            print("Error saving stars: \(error)")
        }
    }

    func saveFormsToPersitentStore() {
        guard let url = persistentURL else { return }

        do {
            let encoder = PropertyListEncoder()
            let data = try encoder.encode(forms)
            try data.write(to: url)
        } catch {
            print("Error saving stars: \(error)")
        }
    }


    func loadFromPersistentStore() {
        // Make sure file exists
        let fileManager = FileManager.default
        guard let url = persistentURL, fileManager.fileExists(atPath: url.path) else {
            print("load failed to find file")
            return }

        // Load and decode
        do {
            let data = try Data(contentsOf: url)
            let decoder = PropertyListDecoder()
            currentRestaurant = try decoder.decode(Restaurant.self, from: data)
        } catch {
            print("Error loading data from disk: \(error)")
        }
    }

    func loadFormsFromPersistentStore() {
        // Make sure file exists
        let fileManager = FileManager.default
        guard let url = formsURL, fileManager.fileExists(atPath: url.path) else {
            print("load failed to find file")
            return }

        // Load and decode
        do {
            let data = try Data(contentsOf: url)
            let decoder = PropertyListDecoder()
            forms = try decoder.decode([Form].self, from: data)
        } catch {
            print("Error loading data from disk: \(error)")
        }
    }

    //Mark: - Properties
    private var persistentURL: URL? {
        let fileManager = FileManager.default
        guard let documents = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        print("Documents: \(documents.path)")
        return documents.appendingPathComponent("RestaurantInfo.plist")
    }

    private var formsURL: URL? {
        let fileManager = FileManager.default
        guard let documents = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        print("Documents: \(documents.path)")
        return documents.appendingPathComponent("RestaurantForms.plist")
    }




    static let shared = RestaurantController()

    var restaurantID: String?
    var currentRestaurant: Restaurant? {
        didSet {
            let userDefaults = UserDefaults.standard
            userDefaults.set(true, forKey: "currentRestaurant")
            saveToPersitentStore()

        }
    }
    var forms: [Form] = [] {
        didSet {
            let userDefaults = UserDefaults.standard
            userDefaults.set(true, forKey: "forms")
            saveFormsToPersitentStore()
        }
    }

    


}
