//
//  NetworkController.swift
//  Queues
//
//  Created by Jonathan Ferrer on 7/30/19.
//  Copyright © 2019 Jonathan Ferrer. All rights reserved.
//

import Foundation

class NetworkController {

    static let baseURL = URL(string: "https://queues-fenam.firebaseio.com/")!

    func createRestaurant(restaurant: Restaurant, completion: @escaping (Error?) -> Void) {
        let identifierURL = NetworkController.baseURL.appendingPathComponent("Restaurants").appendingPathComponent(restaurant.id).appendingPathExtension("json")
        var request = URLRequest(url: identifierURL)
        request.httpMethod = HTTPMethod.put.rawValue
        do {
            let jsonEncoder = JSONEncoder()
            request.httpBody = try jsonEncoder.encode(restaurant)
        } catch {
            NSLog("Error encoding restaurant: \(error)")
        }
        URLSession.shared.dataTask(with: request) { (data, _, error) in

            if let error = error {
                NSLog("Error pushing restaurant to Firebase: \(error)")
                completion(error)
                return
            }
            completion(nil)
            }.resume()
    }

    func fillForm(restaurantID: String, form: Form, completion: @escaping (Error?) -> Void) {

        let identifierURL = NetworkController.baseURL.appendingPathComponent("Restaurants")
                                                    .appendingPathComponent(restaurantID)
                                                    .appendingPathComponent("Forms")
                                                    .appendingPathComponent(form.id)
                                                    .appendingPathExtension("json")
        var request = URLRequest(url: identifierURL)
        request.httpMethod = HTTPMethod.put.rawValue
        do {
            let jsonEncoder = JSONEncoder()
            request.httpBody = try jsonEncoder.encode(form)
        } catch {
            NSLog("Error encoding form: \(error)")
        }
        URLSession.shared.dataTask(with: request) { (data, _, error) in

            if let error = error {
                NSLog("Error pushing form to Firebase: \(error)")
                completion(error)
                return
            }
            completion(nil)
            }.resume()
    }

    func getRestaurantInfo(for restaurantID: String, completion: @escaping (Restaurant?,Error?) -> Void) {
        let identifierURL = NetworkController.baseURL.appendingPathComponent("Restaurants").appendingPathComponent(restaurantID).appendingPathExtension("json")
        var request = URLRequest(url: identifierURL)
        request.httpMethod = HTTPMethod.get.rawValue
        URLSession.shared.dataTask(with: request) { (data, _, error) in

            if let error = error {
                NSLog("Error fetching restaurant: \(error)")
                completion(nil, error)
                return
            }
            guard let data = data else {
                NSLog("No data returned from dataTask")
                completion(nil, error)
                return
            }

            let decoder = JSONDecoder()
            do {

                let restaurant = try decoder.decode(Restaurant.self, from: data)
                completion(restaurant, nil)

            } catch {
                NSLog("Error decoding restaurant: \(error)")
                completion(nil, error)
            }
            }.resume()
    }

    func getForms(restaurantID: String, completion: @escaping ([Form]?,Error?) -> Void) {
        let identifierURL = NetworkController.baseURL.appendingPathComponent("Restaurants").appendingPathComponent(restaurantID).appendingPathComponent("Forms").appendingPathExtension("json")
        var request = URLRequest(url: identifierURL)
        request.httpMethod = HTTPMethod.get.rawValue
        URLSession.shared.dataTask(with: request) { (data, _, error) in

            if let error = error {
                NSLog("Error fetching forms: \(error)")
                completion(nil, error)
                return
            }
            guard let data = data else {
                NSLog("No data returned from dataTask")
                completion(nil, error)
                return
            }

            let decoder = JSONDecoder()
            do {

                let forms = try decoder.decode([Form].self, from: data)
                completion(forms, nil)

            } catch {
                NSLog("Error decoding forms: \(error)")
                completion(nil, error)
            }
            }.resume()
    }

}

enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
}

enum NetworkError: Error {
    case noDataReturned
    case noBearer
    case badAuth
    case apiError
    case noDecode
}
