//
//  ProductsFactory.swift
//  СurrencyСonverter
//
//  Created by Владислав Артюхов on 16.03.2025.
//
import UIKit

protocol Factory: AnyObject {
    func make() -> UIViewController
}

final class ProductsFactory: Factory {
    
    func make() -> UIViewController {
        
        let service = RestService()
        
        let router = ProductsRouter(factory: TransactionsFactory())
        
        let presenter = ProductsPresenter(service: service, router: router)
        
        let vc = ProductsViewController(presenter: presenter)
        
        presenter.view = vc
        router.setRootViewController(root: vc)
        
        return vc
    }
}
