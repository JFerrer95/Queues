//
//  CurrentReservationViewController.swift
//  Queues
//
//  Created by Jonathan Ferrer on 7/31/19.
//  Copyright © 2019 Jonathan Ferrer. All rights reserved.
//

import UIKit

class CurrentReservationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        updateCurrentForm()
    }

    func updateCurrentForm() {
    guard let restaurantID = UserController.shared.currentForm?.restaurantID,
            let formID = UserController.shared.currentForm?.id else { return }
        networkController.getForm(restaurantID: restaurantID, formID: formID) { (form, error) in
            if let error = error {
                NSLog("Error fetching form: \(error)")
            }
            guard let form = form else { return }
            UserController.shared.currentForm = form

        }
    }

    func updateViews() {
        guard let form = UserController.shared.currentForm else { return }

        restaurantNameLabel.text = form.restaurantName
        restaurantPhoneLabel.text = form.restaurantPhone
        partySizeLabel.text = "Party of \(form.partySize)"
        
    }
    
    @IBAction func scanButtonPressed(_ sender: Any) {
        
    }


    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var restaurantPhoneLabel: UILabel!
    @IBOutlet weak var partySizeLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    var networkController = NetworkController()

}
