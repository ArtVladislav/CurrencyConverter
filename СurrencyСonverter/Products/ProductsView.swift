//
//  ProductsView.swift
//  СurrencyСonverter
//
//  Created by Владислав Артюхов on 16.03.2025.
//
import UIKit

final class ProductsView: UIView {
    
    private lazy var productsLabel: UILabel = {
        let label = UILabel()
        label.text = "..."
        label.font.withSize(20)
        return label
    }()
    
    private let presenter: ProductsPresenterProtocol
    
    init(presenter: ProductsPresenterProtocol) {
        self.presenter = presenter
        super.init(frame: .zero)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(model: ProductsModel) {
        productsLabel.text = model.name
    }
}

private extension ProductsView {
    
    func commonInit() {
        backgroundColor = .systemCyan
        setupSubviews()
        setupConstraints()
    }
    
    func setupSubviews() {
        addSubview(productsLabel)
    }
    
    func setupConstraints() {
        productsLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            productsLabel.topAnchor.constraint(equalTo: topAnchor, constant: 150),
            productsLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30)
        ])
    }
}
