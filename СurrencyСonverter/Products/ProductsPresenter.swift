//
//  ProductsPresenter.swift
//  СurrencyСonverter
//
//  Created by Владислав Артюхов on 16.03.2025.
//

protocol ProductsPresenterProtocol: AnyObject {
    init(view: ProductsViewProtocol, productsModel: ProductsModel)
    func showProducts()
}

final class ProductsPresenter: ProductsPresenterProtocol {
    
    let view: ProductsViewProtocol
    let productsModel: ProductsModel
    
    init(view: ProductsViewProtocol, productsModel: ProductsModel) {
        self.productsModel = productsModel
        self.view = view
    }
    
    func showProducts() {
        self.view.setItems(productsModel)
    }
}
