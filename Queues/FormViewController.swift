//
//  FormViewController.swift
//  Queues
//
//  Created by Jonathan Ferrer on 7/30/19.
//  Copyright © 2019 Jonathan Ferrer. All rights reserved.
//

import UIKit

class FormViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let formID = formID else { return }

        networkController.getInfo(for: formID) { (restaurant, error) in
            if let error = error {
                NSLog("error getting info: \(error)")
            }

            self.currentRestaurant = restaurant
            guard let currentRestaurant = self.currentRestaurant else { return }
            DispatchQueue.main.async {
                self.restaurantLabel.text = currentRestaurant.name

            }
        }
    }


    

    @IBOutlet weak var restaurantLabel: UILabel!
    var formID: String?
    let networkController = NetworkController()
    var currentRestaurant: Restaurant?

}
