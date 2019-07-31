//
//  FormsTableViewController.swift
//  Queues
//
//  Created by Jonathan Ferrer on 7/31/19.
//  Copyright © 2019 Jonathan Ferrer. All rights reserved.
//

import UIKit

class FormsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        guard let restaurantID = RestaurantController.shared.restaurantID else { return }

        networkController.getForms(restaurantID: restaurantID) { (forms, error) in
            if let error = error {
                NSLog("Error fetching forms: \(error)")
                return
            }

            guard let forms = forms else { return }

            RestaurantController.shared.forms = forms
            print(RestaurantController.shared.forms.count)

            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return RestaurantController.shared.forms.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomerCell", for: indexPath)
        let form = RestaurantController.shared.forms[indexPath.row]

        cell.textLabel?.text = form.name
        cell.detailTextLabel?.text = "Party of \(form.partySize)"

        return cell
    }


    let networkController = NetworkController()
    

}
