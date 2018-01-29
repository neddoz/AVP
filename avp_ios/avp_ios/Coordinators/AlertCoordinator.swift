//
//  AlertCoordinator.swift
//  avp_ios
//
//  Created by kayeli dennis on 07/12/2017.
//  Copyright © 2017 kayeli dennis. All rights reserved.
//

import Foundation

/// Base class to handle all alerts in
class AlertCoordinator {
    static func alert(with message: String, title: String, actions: [UIAlertAction]?)-> UIAlertController{
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if let actions = actions {
            actions.forEach({ (action) in
                alertController.addAction(action)
            })
        }else {
            // default action
            let Ok = UIAlertAction(title: "Ok", style: .destructive) { (action) in }
            alertController.addAction(Ok)
        }
        return alertController
    }
}
