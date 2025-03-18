//
//  ProductsRouter.swift
//  СurrencyСonverter
//
//  Created by Владислав Артюхов on 16.03.2025.
//

import UIKit

protocol ProductsRouterProtocol: AnyObject {
    func openTransactions(with model: ProductsModel)
}

final class ProductsRouter: ProductsRouterProtocol {
    
    private weak var root: UIViewController?
    private let factory: TransactionsFactory
    
    init(factory: TransactionsFactory) {
        self.factory = factory
    }
    
    func setRootViewController(root: UIViewController){
        self.root = root
    }
    
    func openTransactions(with model: ProductsModel) {
        let vc = factory.make(with: model)
        root?.navigationController?.pushViewController(vc, animated: true)
    }
}
