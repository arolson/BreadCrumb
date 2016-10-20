//
//  ViewController Extension.swift
//  VirtualTourist
//
//  Created by Andrew Olson on 9/28/16.
//  Copyright © 2016 Andrew Olson. All rights reserved.
//

import UIKit

extension UIViewController
{
    func displayActionSheet(title: String,message: String,actions: [UIAlertAction])
    {
        let alert = UIAlertController(title: title, message: message,preferredStyle: .actionSheet)
        for action in actions
        {
            alert.addAction(action)
        }
        alert.popoverPresentationController?.sourceView = self.view
        self.present(alert, animated: true, completion: nil)
    }
    
    func displayErrorAlert(message: String)
    {
        let alert = UIAlertController(title: "Alert",message: message,preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK",style: .cancel,handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
