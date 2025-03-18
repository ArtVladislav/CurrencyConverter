//
//  TransactionsRouter.swift
//  СurrencyСonverter
//
//  Created by Владислав Артюхов on 17.03.2025.
//
import UIKit

protocol TransactionsRouterProtocol: AnyObject{
    func showError(message: String)
}

final class TransactionsRouter: TransactionsRouterProtocol {
    
    private weak var root: UIViewController?
    private let alertFactory: AlertFactory
    
    init() {
        self.alertFactory = AlertFactory()
    }
    
    func setRootViewController(root: UIViewController) {
        self.root = root
    }
    
    func showError(message: String) {
        let alert = alertFactory.make(title: "Ошибка", message: message)
        root?.present(alert, animated: true)
    }
}
