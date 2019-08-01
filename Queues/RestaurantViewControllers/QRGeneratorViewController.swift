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
        if RestaurantController.shared.restaurantID != nil {
            let data = RestaurantController.shared.restaurantID?.data(using: .ascii, allowLossyConversion: false)
            let filter = CIFilter(name: "CIQRCodeGenerator")
            filter?.setValue(data, forKey: "inputMessage")

            let transform = CGAffineTransform(scaleX: 10, y: 10)
            let scaledQrImage = filter?.outputImage?.transformed(by: transform)

            let img = UIImage(ciImage: scaledQrImage!)

            myImageView.image = img

        }
    }



    @IBOutlet weak var myImageView: UIImageView!
}
