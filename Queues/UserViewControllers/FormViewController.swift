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

        updateViews()
    }



    func updateViews() {
        guard let formID = formID else { return }

        networkController.getRestaurantInfo(for: formID) { (restaurant, error) in
            if let error = error {
                NSLog("error getting info: \(error)")
                return
            }

            self.currentRestaurant = restaurant
            guard let currentRestaurant = self.currentRestaurant else { return }
            DispatchQueue.main.async {
                self.restaurantNameLabel.text = currentRestaurant.name
                self.restaurantPhoneLabel.text = currentRestaurant.phone
                self.restaurantAddressLabel.text = currentRestaurant.address
                self.restaurantTimesLabel.text = currentRestaurant.times
            }
        }
    }

    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var restaurantPhoneLabel: UILabel!
    @IBOutlet weak var restaurantAddressLabel: UILabel!
    @IBOutlet weak var restaurantTimesLabel: UILabel!

    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var userPhoneTextField: UITextField!
    @IBOutlet weak var userCelebrationTextField: UITextField!
    @IBOutlet weak var userPartySizeTextField: UITextField!
    @IBOutlet weak var userSeatingPicker: UIPickerView!

    var formID: String?
    let networkController = NetworkController()
    var currentRestaurant: Restaurant?

}
