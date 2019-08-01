//
//  FormViewController.swift
//  Queues
//
//  Created by Jonathan Ferrer on 7/30/19.
//  Copyright © 2019 Jonathan Ferrer. All rights reserved.
//

import UIKit

class UserFormViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {


    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return seatingOptions.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return seatingOptions[row]
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        userSeatingPicker.dataSource = self
        userSeatingPicker.delegate = self
        updateViews()

        userNameTextField.delegate = self
        userPartySizeTextField.delegate = self
        userNameTextField.returnKeyType = .done
        userPartySizeTextField.returnKeyType = .done

    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        userNameTextField.resignFirstResponder()
        userPartySizeTextField.resignFirstResponder()
        return true
    }

    func updateUserOptions() {

        guard let currentRestaurant = currentRestaurant else { return }

        if currentRestaurant.isCelebrationEnabled {
            userCelebrationTextField.isEnabled = true
        }

        if currentRestaurant.isIndoorEnabled {
            seatingOptions.append("Indoor Seating")
        }

        if currentRestaurant.isOutdoorEnabled {
            seatingOptions.append("Outdoor Seating")
        }

        if currentRestaurant.isBarEnabled {
            seatingOptions.append("Bar Seating")
        }
        userSeatingPicker.reloadAllComponents()
    }

    func updateViews() {
        guard let restaurantID = restaurantID else { return }

        networkController.getRestaurantInfo(for: restaurantID) { (restaurant, error) in
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
                self.updateUserOptions()

            }
        }
    }


    @IBAction func submitButtonPressed(_ sender: Any) {

        guard let name = userNameTextField.text,
            !name.isEmpty,
            let phone = userPhoneTextField.text,
            !phone.isEmpty,
            let celebration = userCelebrationTextField.text,
            let partySizeString = userPartySizeTextField.text,
            var partySize = Int(partySizeString),
            let restaurantID = restaurantID,
            let restaurant = currentRestaurant else { return }

        if partySizeString == "" {
            partySize = 1
        }

        let pickerSelection = userSeatingPicker.selectedRow(inComponent: 0)
        let seating = seatingOptions[pickerSelection]

        let form = Form(name: name, phone: phone, partySize: partySize, celebration: celebration, seating: seating, restaurantID: restaurantID)

        networkController.fillForm(restaurantID: restaurant.id, form: form) { (error) in
            if let error = error {
                NSLog("Error filling form: \(error)")
            }
            self.navigationController?.popToRootViewController(animated: true)
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

    var restaurantID: String?
    let networkController = NetworkController()
    var currentRestaurant: Restaurant?
    var seatingOptions: [String] = []

}
