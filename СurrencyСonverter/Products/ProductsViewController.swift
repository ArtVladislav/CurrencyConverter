//
//  ProductsViewController.swift
//  СurrencyСonverter
//
//  Created by Владислав Артюхов on 16.03.2025.
//

import UIKit

protocol ProductsViewProtocol: AnyObject {
    func update(model: [ProductsModel])
    func startLoader()
    func stopLoader()
}

final class ProductsViewController: UIViewController {
    
    private let presenter: ProductsPresenterProtocol
    private lazy var prodactView = ProductsView(presenter: presenter)
    
    init(presenter: ProductsPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = prodactView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = presenter.title
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        navigationController?.navigationBar.barTintColor = .white
        presenter.viewDidLoad()
    }
}

extension ProductsViewController: ProductsViewProtocol {
    
    func startLoader() {
        prodactView.startLoader()
    }
    
    func stopLoader() {
        prodactView.stopLoader()
    }
    
    func update(model: [ProductsModel]) {
        prodactView.update(model: model)
    }
}
