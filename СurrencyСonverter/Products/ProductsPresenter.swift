//
//  ProductsPresenter.swift
//  СurrencyСonverter
//
//  Created by Владислав Артюхов on 16.03.2025.
//

protocol ProductsPresenterProtocol: AnyObject {
    init(model: ProductsModel, router: ProductsRouterProtocol)
    func viewDidLoad()
}

final class ProductsPresenter: ProductsPresenterProtocol {
    
    weak var view: ProductsViewProtocol?
    
    private let model: ProductsModel
    private let router: ProductsRouterProtocol
    
    init(model: ProductsModel, router: ProductsRouterProtocol) {
        self.model = model
        self.router = router
    }
    
    func viewDidLoad() {
        view?.update(model: model)
    }
}
