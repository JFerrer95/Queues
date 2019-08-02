//
//  UserSettingsTableViewController.swift
//  Queues
//
//  Created by Jonathan Ferrer on 8/1/19.
//  Copyright © 2019 Jonathan Ferrer. All rights reserved.
//

import UIKit

class UserSettingsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.separatorStyle = .none
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return settings.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserSettingsCell", for: indexPath)
        let setting = settings[indexPath.row]

        if indexPath.row == 0 {
            cell.textLabel?.text = ""
            cell.imageView?.image = UIImage(named: "Logo")
            return cell
        }

        cell.textLabel?.text = setting
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(100)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.row) {
        case 1:
            performSegue(withIdentifier: "ShowUserSettings", sender: nil)
        case 3:

            guard let restaurantVC = UIStoryboard(name: "Restaurant", bundle: nil).instantiateViewController(withIdentifier: "RestaurantVC") as? RestaurantTabBarController else {
                    print("restaurantVC was not found!")
                    return
                }
            self.dismiss(animated: true) { () -> Void in
                //Perform segue or push some view with your code
                UIApplication.shared.keyWindow?.rootViewController = restaurantVC
            }

                
                
                view.window?.rootViewController = restaurantVC
                view.window?.makeKeyAndVisible()
//        case 2:
//            performSegue(withIdentifier: "ShowRestaurant", sender: nil)
        default:
            print("nothing")
        }

    }



    let settings: [String] = ["Logo", "User Info", "Theme Settings", "Restaurant Mode"]

}
