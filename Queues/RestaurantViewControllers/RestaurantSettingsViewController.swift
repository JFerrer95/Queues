//
//  RestaurantSettingsViewController.swift
//  Queues
//
//  Created by Jonathan Ferrer on 7/30/19.
//  Copyright © 2019 Jonathan Ferrer. All rights reserved.
//

import UIKit

class RestaurantSettingsViewController: UIViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        updateViews()
    }

    @IBAction func saveButtonPressed(_ sender: Any) {
        guard let name = self.nameTextField.text,
            !name.isEmpty,
            let phone = self.phoneTextField.text,
            !phone.isEmpty,
            let times = self.timesTextField.text,
            !times.isEmpty,
            let address = self.addressTextField.text,
            !address.isEmpty else { return }

        let alert = UIAlertController(title: "Info Changed", message: "Are you sure you want to change this information?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (nil) in


            if RestaurantController.shared.currentRestaurant == nil {
                let restaurant = Restaurant(name: name, phone: phone, times: times, address: address, isCelebrationEnabled: self.isCelebration.isOn, isIndoorEnabled: self.isIndoor.isOn, isOutdoorEnabled: self.isOutdoor.isOn, isBarEnabled: self.isBar.isOn)
                self.networkController.createRestaurant(restaurant: restaurant) { (error) in
                    if let error = error {
                        NSLog("Error creating restaurant \(error)")
                    }
                    RestaurantController.shared.restaurantID = restaurant.id
                    RestaurantController.shared.currentRestaurant = restaurant

                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)

                    }
                }
            } else {
                
                guard let restaurant = RestaurantController.shared.currentRestaurant else { return }
                restaurant.name = name
                restaurant.phone = phone
                restaurant.times = times
                restaurant.address = address
                restaurant.isCelebrationEnabled = self.isCelebration.isOn
                restaurant.isIndoorEnabled = self.isIndoor.isOn
                restaurant.isOutdoorEnabled = self.isOutdoor.isOn
                restaurant.isBarEnabled = self.isBar.isOn
                self.networkController.createRestaurant(restaurant: restaurant) { (error) in
                    if let error = error {
                        NSLog("Error creating restaurant \(error)")
                    }
                    RestaurantController.shared.restaurantID = restaurant.id
                    RestaurantController.shared.currentRestaurant = restaurant

                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }))


        alert.addAction(UIAlertAction(title: "No", style: .destructive, handler: nil))

        present(alert, animated: true, completion: nil)
    }



    func updateViews() {
        if RestaurantController.shared.currentRestaurant != nil {
            let currentRestaurnt = RestaurantController.shared.currentRestaurant
            guard let isCelebrationEnabled = currentRestaurnt?.isCelebrationEnabled,
                let isIndoorEnabled = currentRestaurnt?.isIndoorEnabled,
                let isOutdoorEnabled = currentRestaurnt?.isOutdoorEnabled,
                let isBarEnabled = currentRestaurnt?.isBarEnabled else { return }
            nameTextField.text = currentRestaurnt?.name
            phoneTextField.text = currentRestaurnt?.phone
            timesTextField.text = currentRestaurnt?.times
            addressTextField.text = currentRestaurnt?.address

            isCelebration.isOn = isCelebrationEnabled
            isIndoor.isOn = isIndoorEnabled
            isOutdoor.isOn = isOutdoorEnabled
            isBar.isOn = isBarEnabled
        }

    }


    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var timesTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var isCelebration: UISwitch!
    @IBOutlet weak var isIndoor: UISwitch!
    @IBOutlet weak var isOutdoor: UISwitch!
    @IBOutlet weak var isBar: UISwitch!

    let networkController = NetworkController()

}
