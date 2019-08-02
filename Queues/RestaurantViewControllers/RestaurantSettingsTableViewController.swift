//
//  RestaurantSettingsTableViewController.swift
//  Queues
//
//  Created by Jonathan Ferrer on 8/2/19.
//  Copyright © 2019 Jonathan Ferrer. All rights reserved.
//

import UIKit

class RestaurantSettingsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return settings.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantSettingsCell", for: indexPath)

        let setting = settings[indexPath.row]

        cell.textLabel?.text = setting


        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(100)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.row){
        case 0:
            performSegue(withIdentifier: "ShowRestaurantInfo", sender: nil)
        case 2:
            navigationController?.popToRootViewController(animated: true)
            guard let userVC = UIStoryboard(name: "User", bundle: nil).instantiateViewController(withIdentifier: "UserVC") as? UserNavigationController else {
                print("UserVC was not found!")
                return
            }

            self.dismiss(animated: true) { () -> Void in
                //Perform segue or push some view with your code
                UIApplication.shared.keyWindow?.rootViewController = userVC
            }

            view.window?.rootViewController = userVC
            view.window?.makeKeyAndVisible()
//        case 2:
//            performSegue(withIdentifier: "ShowUser", sender: nil)
        default:
            print("nothing")
        }

    }

    let settings: [String] = ["Logo","Restaurant Info", "Theme Settings", "User Mode"]

}
