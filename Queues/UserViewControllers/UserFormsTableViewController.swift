//
//  UserFormsTableViewController.swift
//  Queues
//
//  Created by Jonathan Ferrer on 7/31/19.
//  Copyright © 2019 Jonathan Ferrer. All rights reserved.
//

import UIKit
import AudioToolbox

class UserFormsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        networkTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(updateCurrentForm), userInfo: nil, repeats: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        blankLabels()
        updateCurrentForm()
        forms = UserController.shared.forms.sorted { $0.timestamp < $1.timestamp }
        self.tableView.separatorStyle = .none
        tableView.reloadData()

    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return forms.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantCell", for: indexPath) as! RestaurantCell
        let form = forms[indexPath.row]

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
            return "Previous Reservations"
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

                if !form.isReady! {
                    self.hasBeenAlerted = false
                }

                if !self.hasBeenAlerted {
                    self.isReady()
                }
            }
        }
    }

    func isReady() {
        guard let form = UserController.shared.currentForm else { return }

        if form.isReady! {

        let tableReadyAlert = UIAlertController(title: "Table for \(form.name)", message: "Your table for \(form.partySize) is ready!", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Okay", style: .destructive, handler: nil)
        AudioServicesPlayAlertSound(UInt32(1020))
        tableReadyAlert.addAction(confirmAction)

        self.present(tableReadyAlert, animated: true, completion: nil)
        self.hasBeenAlerted = true
        }
    }


    @IBAction func phoneButtonPressed(_ sender: Any) {
        guard let phoneNumber = UserController.shared.currentForm?.restaurantPhone else { return }
        let numberWithoutOpen = phoneNumber.replacingOccurrences(of: "(", with: "")
        let numberWithoutClose = numberWithoutOpen.replacingOccurrences(of: ")", with: "")
        let numberWithoutDash = numberWithoutClose.replacingOccurrences(of: "-", with: "")
        let numberWithoutSpace = numberWithoutDash.replacingOccurrences(of: " ", with: "")
        guard let number = URL(string: "tel://" + numberWithoutSpace) else { return }
        UIApplication.shared.open(number)
    }
    
    func updateViews() {
        guard let form = UserController.shared.currentForm,
            let isReady = form.isReady else { return }
        
        restaurantNameLabel.text = form.restaurantName


        restaurantPhoneButton.setTitle( form.restaurantPhone, for: .normal)


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

    func blankLabels() {
        if UserController.shared.currentForm == nil {

            isReadyLabel.text = ""
            restaurantNameLabel.text = ""
            restaurantPhoneButton.setTitle("", for: .normal)
            partySizeLabel.text = ""
            timestampLabel.text = ""
        }
    }



    @IBOutlet weak var isReadyLabel: UILabel!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var restaurantPhoneButton: UIButton!
    @IBOutlet weak var partySizeLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    var hasBeenAlerted = false
    var networkController = NetworkController()
    var networkTimer: Timer?
    var forms: [Form] = []




}
