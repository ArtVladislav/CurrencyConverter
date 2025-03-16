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
        
        var service = RestService().loadProductsFromPlist()
        print(service ?? "")
        
        let model = ProductsModel(amount: "", currency: "", sku: "")
        
        let router = ProductsRouter()
        
        let presenter = ProductsPresenter(model: model, router: router)
        
        let vc = ProductsViewController(presenter: presenter)
        
        presenter.view = vc
        router.setRootViewController(root: vc)
        
        return vc
    }
}
