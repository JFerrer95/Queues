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
        if restaurantController.restaurantID != nil {
            let data = restaurantController.restaurantID?.data(using: .ascii, allowLossyConversion: false)
            let filter = CIFilter(name: "CIQRCodeGenerator")
            filter?.setValue(data, forKey: "inputMessage")

            let transform = CGAffineTransform(scaleX: 10, y: 10)



            let scaledQrImage = filter?.outputImage?.transformed(by: transform)

            let img = UIImage(ciImage: scaledQrImage!)

            myImageView.image = img
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowEditRestaurant" {
            let destinationVC = segue.destination as? RestaurantDetailViewController
            destinationVC?.restaurantController = restaurantController
        }
    }


    @IBOutlet weak var myImageView: UIImageView!
    let restaurantController = RestaurantController()
}
