//
//  ProductsRouter.swift
//  СurrencyСonverter
//
//  Created by Владислав Артюхов on 16.03.2025.
//

import UIKit

protocol ProductsRouterProtocol: AnyObject {
    func openTransactions(with model: ProductsDomainLayer, rates: [RatesDataLayer])
    func showError(message: String)
}

final class ProductsRouter: ProductsRouterProtocol {
    
    private weak var root: UIViewController?
    private let factory: TransactionsFactory
    private let alertFactory: AlertFactory
    
    init(factory: TransactionsFactory) {
        self.factory = factory
        self.alertFactory = AlertFactory()
    }
    
    func setRootViewController(root: UIViewController){
        self.root = root
    }
    
    func openTransactions(with model: ProductsDomainLayer, rates: [RatesDataLayer]) {
        let vc = factory.make(with: model, rates: rates)
        root?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showError(message: String) {
        let alert = alertFactory.make(title: "Ошибка", message: message)
        root?.present(alert, animated: true)
    }
}
