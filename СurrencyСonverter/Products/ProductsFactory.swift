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
        let view = ProductsViewController()
        let presenter = ProductsPresenter(view: view, productsModel: model)
        view.presenter = presenter
        return view
    }
}
