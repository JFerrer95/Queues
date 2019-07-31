//
//  RestaurantDetailViewController.swift
//  Queues
//
//  Created by Jonathan Ferrer on 7/30/19.
//  Copyright © 2019 Jonathan Ferrer. All rights reserved.
//

import UIKit

class RestaurantDetailViewController: UIViewController {

    @IBAction func saveButtonPressed(_ sender: Any) {

        guard let name = nameTextField.text,
            !name.isEmpty,
            let phone = phoneTextField.text,
            !phone.isEmpty,
            let times = timesTextField.text,
            !times.isEmpty else { return }

        let restaurant = Restaurant( name: name, phone: phone, times: times, id: UUID().uuidString)

        networkController.createRestaurant(restaurant: restaurant) { (error) in
            if let error = error {
                NSLog("Error creating restaurant \(error)")
            }
            self.restaurantController?.restaurantID = restaurant.id
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var timesTextField: UITextField!
    let networkController = NetworkController()
    var restaurantController: RestaurantController?
}
