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
    private var model: [ProductsModel]?
    private var activityIndicator: UIActivityIndicatorView!
    
    init(presenter: ProductsPresenterProtocol) {
        self.presenter = presenter
        self.tableView = UITableView()
        super.init(frame: .zero)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        activityIndicator.center = CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let model = self.model else { return }
        presenter.tapCell(with: model[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let model = self.model else { return 0 }
        return model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductsCell.cellId, for: indexPath) as? ProductsCell else { return UITableViewCell() }
        guard let model = self.model else { return cell }
        cell.configure(with: model[indexPath.row])
        return cell
    }
    
    func startLoader() {
        activityIndicator.startAnimating()
    }
    
    func stopLoader() {
        activityIndicator.stopAnimating()
    }
    
    func update(model: [ProductsModel]) {
        self.model = model
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension ProductsView {
    
    private func commonInit() {
        backgroundColor = .white
        setupTableView()
        setupConstraints()
        setupIndicator()
    }
    
    private func setupIndicator(){
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .gray
        activityIndicator.hidesWhenStopped = true
        addSubview(activityIndicator)
    }
    
    private func setupTableView() {
        tableView.backgroundColor = .white
        tableView.rowHeight = 50
        addSubview(tableView)
        tableView.register(ProductsCell.self, forCellReuseIdentifier: ProductsCell.cellId)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
}
