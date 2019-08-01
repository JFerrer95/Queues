//
//  RestaurantFormsTableViewController.swift
//  Queues
//
//  Created by Jonathan Ferrer on 7/31/19.
//  Copyright © 2019 Jonathan Ferrer. All rights reserved.
//

import UIKit

class RestaurantFormsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        networkTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(updateForms), userInfo: nil, repeats: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        updateForms()
    }

    @objc func updateForms() {
        guard let restaurantID = RestaurantController.shared.restaurantID else { return }

        networkController.getForms(restaurantID: restaurantID) { (forms, error) in
            if let error = error {
                NSLog("Error fetching forms: \(error)")
                return
            }
            guard let forms = forms else { return }
            if RestaurantController.shared.forms == forms {
                return
            } else {
                RestaurantController.shared.forms = forms
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }

            print(RestaurantController.shared.forms.count)

            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch (section) {
        case 0:
            return "Queue"

        case 1:
            return "Alerted"
        default:
            return ""
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {

            let notReadyForms = RestaurantController.shared.forms.filter { $0.isReady == false }
            return notReadyForms.count

        } else {
            let readyForms = RestaurantController.shared.forms.filter { $0.isReady == true }

            return readyForms.count
        }
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomerCell", for: indexPath) as! RestaurantFormTableViewCell

        switch (indexPath.section) {
        case 0:
            var forms = RestaurantController.shared.forms.filter { $0.isReady == false}

            forms.sort { $0.timestamp < $1.timestamp }

            let form = forms[indexPath.row]
            cell.namelabel.text = form.name
            cell.partySizeLabel.text = "Party of \(form.partySize)"
            cell.seatingOptionLabel.text = form.seating

            let date = Date(timeIntervalSince1970: form.timestamp)
            let dateFormatter = DateFormatter()
            dateFormatter.locale = NSLocale.current
            dateFormatter.dateFormat = "MMM d, h:mm a"
            let strDate = dateFormatter.string(from: date)
            cell.timestampLabel.text = strDate

            return cell
        case 1:
            var forms = RestaurantController.shared.forms.filter { $0.isReady == true}

            forms.sort { $0.timestamp < $1.timestamp }

            let form = forms[indexPath.row]
            cell.namelabel.text = form.name
            cell.partySizeLabel.text = "Party of \(form.partySize)"
            cell.seatingOptionLabel.text = form.seating

            let date = Date(timeIntervalSince1970: form.timestamp)
            let dateFormatter = DateFormatter()
            dateFormatter.locale = NSLocale.current
            dateFormatter.dateFormat = "MMM d, h:mm a"
            let strDate = dateFormatter.string(from: date)
            cell.timestampLabel.text = strDate
            return cell

        default:
            return cell
        }

    }

    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {

        if indexPath.section == 0 {
        let forms = RestaurantController.shared.forms.filter { $0.isReady == false }
        let form = forms[indexPath.row]
        let tableReadyAction = UITableViewRowAction(style: .normal, title: "Table Ready" , handler: { (action:UITableViewRowAction, indexPath: IndexPath) -> Void in
            let confirmReadyMenu = UIAlertController(title: "Table for \(form.name)", message: "Confirm the table is ready", preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: "Confirm", style: .default, handler: { (nil) in

                form.isReady = true

                self.networkController.fillForm(restaurantID: form.restaurantID, form: form, completion: { (error) in
                    if let error = error {
                        NSLog("Error confirming table is ready \(error)")
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                })
            })

            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

            confirmReadyMenu.addAction(confirmAction)
            confirmReadyMenu.addAction(cancelAction)

            self.present(confirmReadyMenu, animated: true, completion: nil)
        })

        let rateAction = UITableViewRowAction(style: .default, title: "Rate" , handler: { (action:UITableViewRowAction, indexPath:IndexPath) -> Void in

            let rateMenu = UIAlertController(title: nil, message: "Rate this App", preferredStyle: .actionSheet)

            let appRateAction = UIAlertAction(title: "Rate", style: .default, handler: nil)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

            rateMenu.addAction(appRateAction)
            rateMenu.addAction(cancelAction)

            self.present(rateMenu, animated: true, completion: nil)
        })

        return [tableReadyAction,rateAction]
        } else {
            return nil
        }
    }


    let networkController = NetworkController()
    var networkTimer: Timer?

    

}
