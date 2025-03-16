//
//  ProductsCell.swift
//  СurrencyСonverter
//
//  Created by Владислав Артюхов on 17.03.2025.
//

import UIKit

class ProductsCell: UITableViewCell {
    static let cellId = "ProductsCell"
//    private let model: ProductsModel?
    
    private lazy var skuLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "sku"
        label.font = .systemFont(ofSize: 21, weight: .medium)
        return label
    }()
    
    private lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.text = "amount " + "transactions  " + ">"
        label.font = .systemFont(ofSize: 20, weight: .medium)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            contentView.backgroundColor = .cyan
        } else {
            contentView.backgroundColor = .clear
        }
    }
    
    func commonInit() {
        backgroundColor = .clear
        setupSubviews()
        setupConstraint()
    }
    
    func setupSubviews() {
        contentView.addSubview(skuLabel)
        contentView.addSubview(amountLabel)
    }
    
    func setupConstraint() {
        skuLabel.translatesAutoresizingMaskIntoConstraints = false
        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            skuLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            skuLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            amountLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            amountLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }
    
}
