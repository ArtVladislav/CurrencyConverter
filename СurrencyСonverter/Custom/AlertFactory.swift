//
//  AlertFactory.swift.swift
//  СurrencyСonverter
//
//  Created by Владислав Артюхов on 18.03.2025.
//
import UIKit

final class AlertFactory {
    
    func make(title: String, message: String) -> UIViewController {
        let alertViewController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        let action = UIAlertAction(
            title: "Ok",
            style: .default,
            handler: nil
        )
        
        alertViewController.addAction(action)
        
        return alertViewController
    }
}
