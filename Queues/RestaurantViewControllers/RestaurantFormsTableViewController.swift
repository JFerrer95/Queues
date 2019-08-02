//
//  RestaurantFormsTableViewController.swift
//  Queues
//
//  Created by Jonathan Ferrer on 7/31/19.
//  Copyright © 2019 Jonathan Ferrer. All rights reserved.
//

import UIKit
import MessageUI

class RestaurantFormsTableViewController: UITableViewController, MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        networkTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(updateForms), userInfo: nil, repeats: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.separatorStyle = .none
        updateForms()
    }

    @objc func updateForms() {
        guard let restaurantID = RestaurantController.shared.currentRestaurant?.id else { return }

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

    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        view.tintColor = .black
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.white
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

        let filteredForms = RestaurantController.shared.forms.filter { $0.isReady == false }
        let forms = filteredForms.sorted { $0.timestamp < $1.timestamp }
        if indexPath.section == 0 {
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

        let contactAction = UITableViewRowAction(style: .default, title: "Contact" , handler: { (action:UITableViewRowAction, indexPath:IndexPath) -> Void in
            let contactMenu = UIAlertController(title: nil, message: "Contact  \(form.name)?", preferredStyle: .alert)
            let callAction = UIAlertAction(title: "Call", style: .default, handler: { (nil) in
                
                guard let number = URL(string: "tel://" + form.phone) else { return }
                UIApplication.shared.open(number)
            })

            let textAction = UIAlertAction(title: "Text", style: .default, handler: { (nil) in
                if (MFMessageComposeViewController.canSendText()) {
                    let controller = MFMessageComposeViewController()
                    controller.body = "Hi \(form.name), \nThis is \(form.restaurantName).  Your table for \(form.partySize) is now ready!"
                    controller.recipients = [form.phone]
                    controller.messageComposeDelegate = self
                    self.present(controller, animated: true, completion: nil)
                }
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)

            contactMenu.addAction(cancelAction)
            contactMenu.addAction(callAction)
            contactMenu.addAction(textAction)
           

            self.present(contactMenu, animated: true, completion: nil)
        })

        return [tableReadyAction, contactAction]
        } else {
           return nil
        }
    }




    let networkController = NetworkController()
    var networkTimer: Timer?

    

}
