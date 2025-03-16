//
//  ProductsViewController.swift
//  СurrencyСonverter
//
//  Created by Владислав Артюхов on 16.03.2025.
//

import UIKit

protocol ProductsViewProtocol: AnyObject {
    func setItems(_ items: ProductsModel)
}

final class ProductsViewController: UIViewController {
    
    var presenter: ProductsPresenterProtocol?
    
    lazy var productsLabel: UILabel = {
        let label = UILabel()
        label.text = "..."
        label.font.withSize(20)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commonInit()
    }
    
    init() {
        //self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ProductsViewController: ProductsViewProtocol {
    
    func setItems(_ items: ProductsModel) {
        productsLabel.text = items.name
    }
    
    func commonInit() {
        setupSubviews()
        setupConstraints()
    }
    
    func setupSubviews() {
        view.addSubview(productsLabel)
    }
    
    func setupConstraints() {
        productsLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            productsLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            productsLabel.leftAnchor.constraint(equalTo: view.leadingAnchor, constant: 30)
        ])
    }
}
