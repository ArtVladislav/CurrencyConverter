//
//  ProductsCell.swift
//  СurrencyСonverter
//
//  Created by Владислав Артюхов on 17.03.2025.
//

import UIKit

class TransactionsCell: UITableViewCell {
    static let cellId = "TransactionsCell"
    
    private let dictionary: [String: String] = [
        "AUD": "A$",
        "GBP": "£",
        "USD": "$",
        "CAD": "CA$"
    ]
    private lazy var leftLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "$"
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.backgroundColor = .clear
        return label
    }()
    
    private lazy var rightLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.text = "*"
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.backgroundColor = .clear
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
        
        let bgColor = selected ? UIColor.white : UIColor.white
        contentView.backgroundColor = bgColor
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        
        let bgColor = highlighted ? UIColor.white : UIColor.white
        contentView.backgroundColor = bgColor
    }
    
    func configure(with model: TransactionsModel) {
        rightLabel.text = "£" + String(format:"%.2f", model.convertedGBP)
        leftLabel.text = (dictionary[model.currency] ?? model.currency) + String(format: "%.2f", model.amount)
    }
    
    private func commonInit() {
        backgroundColor = .white
        contentView.backgroundColor = .white
        tintColor = .white
        
        setupSubviews()
        setupConstraint()
    }
    
    private func setupSubviews() {
        contentView.addSubview(leftLabel)
        contentView.addSubview(rightLabel)
    }
    
    private func setupConstraint() {
        leftLabel.translatesAutoresizingMaskIntoConstraints = false
        rightLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leftLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            leftLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            rightLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            rightLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }
    
}
