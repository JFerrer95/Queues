//
//  UserInfoViewController.swift
//  Queues
//
//  Created by Jonathan Ferrer on 8/2/19.
//  Copyright © 2019 Jonathan Ferrer. All rights reserved.
//

import UIKit

class UserInfoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }




    
    @IBAction func saveButtonPressed(_ sender: Any) {

        guard let name = nameLabel.text,
            !name.isEmpty,
            let phone = phoneLabel.text,
            !phone.isEmpty,
            let email = emailLabel.text,
            !email.isEmpty else { return }
        let user = User(name: name, phone: phone, email: email)
        UserController.shared.user = user
        navigationController?.popViewController(animated: true)
    }

    @IBOutlet weak var nameLabel: UITextField!

    @IBOutlet weak var phoneLabel: UITextField!
    
    @IBOutlet weak var emailLabel: UITextField!
    


}
