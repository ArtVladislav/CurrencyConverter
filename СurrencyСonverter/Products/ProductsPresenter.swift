//
//  ProductsPresenter.swift
//  СurrencyСonverter
//
//  Created by Владислав Артюхов on 16.03.2025.
//

protocol ProductsPresenterProtocol: AnyObject {
    var title: String { get }
    init(service: RestService, router: ProductsRouterProtocol)
    func viewDidLoad()
    func tapCell(with model: ProductsModel)
}

final class ProductsPresenter: ProductsPresenterProtocol {
    
    var title: String { "Products" }
    weak var view: ProductsViewProtocol?
    
    private let service: RestService
    private let router: ProductsRouterProtocol
    
    init(service: RestService, router: ProductsRouterProtocol) {
        self.service = service
        self.router = router
    }
    
    func viewDidLoad() {
        service.loadProductsFromPlist { [weak self] model in
            guard let self else { return }
            guard let model = model else { return }
            self.view?.update(model: model)
        }
    }
    
    func tapCell(with model: ProductsModel) {
        router.openTransactions(with: model)
    }
}
