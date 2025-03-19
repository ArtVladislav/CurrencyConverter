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
    func tapCell(with model: ProductsDomainLayer)
}

final class ProductsPresenter: ProductsPresenterProtocol {
    
    var title: String { "Products" }
    
    weak var view: ProductsViewProtocol?
    private let service: RestService
    private let router: ProductsRouterProtocol
    private var rates: [RatesDataLayer]?
    
    init(service: RestService, router: ProductsRouterProtocol) {
        self.service = service
        self.router = router
    }
    
    func viewDidLoad() {
        view?.startLoader()
        service.getDomainLayerProducts { [weak self] result in
            guard let self else { return }
            self.view?.stopLoader()
            
            switch result {
            case .success(let model):
                self.view?.update(model: model)
            case .failure(let error):
                self.router.showError(message: error.localizedDescription)
            }
        }
        service.getDataLayerRates { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let model):
                self.rates = model
            case .failure(let error):
                self.router.showError(message: error.localizedDescription)
            }
        }
    }
    
    func tapCell(with model: ProductsDomainLayer) {
        guard let rates = rates else { return }
        router.openTransactions(with: model, rates: rates)
    }
}
