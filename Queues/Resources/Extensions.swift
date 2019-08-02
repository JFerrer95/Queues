//
//  Extensions.swift
//  Queues
//
//  Created by Jonathan Ferrer on 8/2/19.
//  Copyright © 2019 Jonathan Ferrer. All rights reserved.
//

import UIKit



extension UINavigationController {
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationBar.backIndicatorImage = UIImage(named: "Back")
        navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "Back")
        navigationBar.backItem?.title = ""
        navigationBar.tintColor = .black
    }
}
