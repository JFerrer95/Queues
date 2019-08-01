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
        return RestaurantController.shared.forms.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomerCell", for: indexPath) as! RestaurantFormTableViewCell
        let form = RestaurantController.shared.forms[indexPath.row]

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
    }

    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?
    {
    
        let form = RestaurantController.shared.forms[indexPath.row]

        let tableReadyAction = UITableViewRowAction(style: .normal, title: "Table Ready" , handler: { (action:UITableViewRowAction, indexPath: IndexPath) -> Void in

            let confirmReadyMenu = UIAlertController(title: "Table for \(form.name)", message: "Confirm the table is ready", preferredStyle: .alert)


            let confirmAction = UIAlertAction(title: "Confirm", style: .default, handler: { (nil) in

                form.isReady = true

                self.networkController.fillForm(restaurantID: form.restaurantID, form: form, completion: { (error) in
                    if let error = error {
                        NSLog("Error confirming table is ready \(error)")
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
    }


    let networkController = NetworkController()

    

}
