//
//  TransactionsView.swift
//  СurrencyСonverter
//
//  Created by Владислав Артюхов on 17.03.2025.
//
import UIKit

final class TransactionsView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    private let tableView: UITableView
    private let presenter: TransactionsPresenterProtocol
    private var model: [TransactionsModel]?
    private var activityIndicator: UIActivityIndicatorView!

    init(presenter: TransactionsPresenterProtocol){
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
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let model = model else { return nil }
        let sum = presenter.getSum(model: model)
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        formatter.decimalSeparator = "."
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
    
        if let formattedString = formatter.string(from: NSNumber(value: sum)) {
            return "Total: £" + formattedString
        }
        return "Total: £0.00"
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
            if let header = view as? UITableViewHeaderFooterView {
                header.textLabel?.textColor = .black
            }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let model = self.model else { return 0 }
        return model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TransactionsCell.cellId, for: indexPath) as? TransactionsCell else { return UITableViewCell() }
        guard let model = self.model else { return cell }
        cell.configure(with: model[indexPath.row])
        return cell
    }
    
    func update(with model: [TransactionsModel]) {
        self.model = model
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func startLoader() {
        activityIndicator.startAnimating()
    }
    
    func stopLoader() {
        activityIndicator.stopAnimating()
    }
}

extension TransactionsView {
    
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
        tableView.allowsSelection = false
        addSubview(tableView)
        tableView.register(TransactionsCell.self, forCellReuseIdentifier: TransactionsCell.cellId)
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
