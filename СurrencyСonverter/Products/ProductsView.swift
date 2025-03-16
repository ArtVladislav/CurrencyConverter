//
//  ProductsView.swift
//  СurrencyСonverter
//
//  Created by Владислав Артюхов on 16.03.2025.
//
import UIKit

final class ProductsView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    private var tableView: UITableView
    private let presenter: ProductsPresenterProtocol
    
    init(presenter: ProductsPresenterProtocol) {
        self.presenter = presenter
        self.tableView = UITableView()
        super.init(frame: .zero)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductsCell.cellId, for: indexPath) as? ProductsCell else { return UITableViewCell() }
        return cell
    }
    
    func update(model: ProductsModel) {
        
    }
}

extension ProductsView {
    
    func commonInit() {
        backgroundColor = .systemCyan
        setupTableView()
        setupConstraints()
    }
    
    func setupTableView() {
        tableView.backgroundColor = .systemCyan
        addSubview(tableView)
        tableView.register(ProductsCell.self, forCellReuseIdentifier: ProductsCell.cellId)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor, constant: 60),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30)
        ])
    }
    
}
