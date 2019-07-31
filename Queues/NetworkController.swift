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
}

enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
}
