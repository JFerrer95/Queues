//
//  QRGeneratorViewController.swift
//  Queues
//
//  Created by Jonathan Ferrer on 7/30/19.
//  Copyright © 2019 Jonathan Ferrer. All rights reserved.
//

import UIKit

class QRGeneratorViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    @IBAction func buttonPressed(_ sender: Any) {

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        updateViews()
        generateQRCode()

    }

    func generateQRCode() {

        guard let restaurant = RestaurantController.shared.currentRestaurant else { return }
            let data = restaurant.id.data(using: .ascii, allowLossyConversion: false)
            let filter = CIFilter(name: "CIQRCodeGenerator")
            filter?.setValue(data, forKey: "inputMessage")

            let transform = CGAffineTransform(scaleX: 10, y: 10)
            let scaledQrImage = filter?.outputImage?.transformed(by: transform)

            let img = UIImage(ciImage: scaledQrImage!)

            myImageView.image = img
        
    }

    func updateViews() {
        if RestaurantController.shared.currentRestaurant != nil {
            guard let restaurent = RestaurantController.shared.currentRestaurant else { return }
            restaurantNameLabel.text = restaurent.name
            restaurantAddressLabel.text = restaurent.address
            restaurantPhoneLabel.text = restaurent.phone
            scanLabel.isHidden = false
        } else {
            restaurantNameLabel.text = ""
            restaurantAddressLabel.text = ""
            restaurantPhoneLabel.text = ""
            scanLabel.isHidden = true
        }
    }





    @IBOutlet weak var restaurantPhoneLabel: UILabel!
    @IBOutlet weak var restaurantAddressLabel: UILabel!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var scanLabel: UILabel!
}
