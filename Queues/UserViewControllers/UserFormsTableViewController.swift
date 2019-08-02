//
//  UserFormsTableViewController.swift
//  Queues
//
//  Created by Jonathan Ferrer on 7/31/19.
//  Copyright © 2019 Jonathan Ferrer. All rights reserved.
//

import UIKit

class UserFormsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        networkTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(updateCurrentForm), userInfo: nil, repeats: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateCurrentForm()
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return UserController.shared.forms.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantCell", for: indexPath) as! RestaurantCell
        let form = UserController.shared.forms[indexPath.row]

        cell.textLabel?.text = form.restaurantName
        cell.detailTextLabel?.text = form.restaurantPhone
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return CGFloat(0)
        }
        return CGFloat(100)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Previous Check-Ins"
        }
        return ""
    }
 
    @objc func updateCurrentForm() {
        guard let restaurantID = UserController.shared.currentForm?.restaurantID,
            let formID = UserController.shared.currentForm?.id else { return }
        networkController.getForm(restaurantID: restaurantID, formID: formID) { (form, error) in
            if let error = error {
                NSLog("Error fetching form: \(error)")
            }
            guard let form = form else { return }
            UserController.shared.currentForm = form

            DispatchQueue.main.async {
                self.updateViews()
            }
        }
    }

    func updateViews() {
        guard let form = UserController.shared.currentForm,
            let isReady = form.isReady else { return }

        restaurantNameLabel.text = form.restaurantName
        restaurantPhoneLabel.text = form.restaurantPhone
        partySizeLabel.text = "Party of \(form.partySize)"
        let date = Date(timeIntervalSince1970: form.timestamp)
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "MMM d, h:mm a"
        let strDate = dateFormatter.string(from: date)
        timestampLabel.text = strDate
        if isReady {
            isReadyLabel.text = "Table is ready"
        } else {
            isReadyLabel.text = "Table is not ready"
        }

    }


    @IBOutlet weak var isReadyLabel: UILabel!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var restaurantPhoneLabel: UILabel!
    @IBOutlet weak var partySizeLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    var networkController = NetworkController()
    var networkTimer: Timer?





}
