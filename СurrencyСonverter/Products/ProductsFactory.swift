//
//  ProductsFactory.swift
//  СurrencyСonverter
//
//  Created by Владислав Артюхов on 16.03.2025.
//
import UIKit

protocol Factory: AnyObject {
    static func make() -> UIViewController
}

final class ProductsFactory: Factory {
    
    static func make() -> UIViewController {
        
        let model = ProductsModel(name: "Hello", countTransaction: 10)
        
        let router = ProductsRouter()
        
        let presenter = ProductsPresenter(model: model, router: router)
        
        let vc = ProductsViewController(presenter: presenter)
        
        presenter.view = vc
        router.setRootViewController(root: vc)
        
        return vc
    }
}
