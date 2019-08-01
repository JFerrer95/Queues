//
//  readerViewController.swift
//  QRGenerator
//
//  Created by Jonathan Ferrer on 7/7/19.
//  Copyright © 2019 Jonathan Ferrer. All rights reserved.
//

import UIKit
import AVFoundation

class QRScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {


    override func viewDidLoad() {
        super.viewDidLoad()

        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)

        do {
            let input = try AVCaptureDeviceInput(device: captureDevice!)
            session.addInput(input)
        } catch {
            NSLog("Error")
        }

        let output = AVCaptureMetadataOutput()
        session.addOutput(output)

        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)

        output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]

        video = AVCaptureVideoPreviewLayer(session: session)
        video.frame = view.layer.bounds
        cameraView.layer.addSublayer(video)
        session.startRunning()

        view.bringSubviewToFront(square)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        session.startRunning()
    }

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count != 0 {
            if let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject {
                if object.type == AVMetadataObject.ObjectType.qr {
                    formID = object.stringValue

                    

                    self.session.stopRunning()
                    self.performSegue(withIdentifier: "ShowForm", sender: nil)
                }
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowForm" {
            let destinationVC = segue.destination as? UserFormViewController
            destinationVC?.restaurantID = formID
        }
    }


    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var square: UIImageView!
    var video = AVCaptureVideoPreviewLayer()
    let session = AVCaptureSession()
    var formID: String?

}
