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

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return settings.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserSettingsCell", for: indexPath)

        let setting = settings[indexPath.row]

        cell.textLabel?.text = setting

        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(100)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.row) {
        case 0:
            performSegue(withIdentifier: "ShowUserSettings", sender: nil)
        case 2:
            performSegue(withIdentifier: "ShowRestaurant", sender: nil)
        default:
            print("nothing")
        }
    }



    let settings: [String] = [ "User Info", "Theme Settings", "Switch to Restaurant"]

}
