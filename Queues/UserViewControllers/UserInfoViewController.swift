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

        self.navigationController?.navigationBar.backIndicatorImage = UIImage(named: "Back")
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "Back")
        self.navigationController?.navigationBar.backItem?.title = ""
        self.navigationController?.navigationBar.tintColor = .black

        updateViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.navigationBar.backIndicatorImage = UIImage(named: "Back")
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "Back")
        self.navigationController?.navigationBar.backItem?.title = ""
        self.navigationController?.navigationBar.tintColor = .black

        updateViews()
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

    func updateViews() {
        guard let user = UserController.shared.user else { return }
        nameLabel.text = user.name
        phoneLabel.text = user.phone
        emailLabel.text = user.email
    }

    @IBOutlet weak var nameLabel: UITextField!

    @IBOutlet weak var phoneLabel: UITextField!
    
    @IBOutlet weak var emailLabel: UITextField!
    


}
