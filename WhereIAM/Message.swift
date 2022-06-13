//
//  Message.swift
//  WhereIAM
//
//  Created by Guilherme Costa on 12/06/22.
//
import UIKit

class Message {
    static func alert(title: String, message: String, actions: [UIAlertAction]) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        actions.forEach({(alertAction) in
                        alertController.addAction(alertAction)
        })
        
        return alertController
    }
}
