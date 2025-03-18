//
//  ProductsCell.swift
//  СurrencyСonverter
//
//  Created by Владислав Артюхов on 17.03.2025.
//

import UIKit

class ProductsCell: UITableViewCell {
    
    static let cellId = "ProductsCell"
    
    private lazy var skuLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "A0000"
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.backgroundColor = .clear
        return label
    }()
    
    private lazy var transactionsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.attributedText = .none
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
        
        let bgColor = selected ? UIColor.lightGray : UIColor.white
        contentView.backgroundColor = bgColor
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        
        let bgColor = highlighted ? UIColor.lightGray : UIColor.white
        contentView.backgroundColor = bgColor
    }
    
    func configure(with model: ProductsModel) {
        transactionsLabel.attributedText = getMaskText(with: model)
        skuLabel.text = model.sku
    }
    
    private func getMaskText(with model: ProductsModel) -> NSAttributedString {
        let arrow = UIImage(systemName: "chevron.right")?.withTintColor(.gray, renderingMode: .alwaysOriginal)
        let attachment = NSTextAttachment()
        attachment.image = arrow
        attachment.bounds = CGRect(x: 0, y: -2, width: 10, height: 15)
        let attributedText = NSMutableAttributedString(string: String(model.arrayTransactions.count) + " transactions  ")
        attributedText.append(NSAttributedString(attachment: attachment))
        return attributedText
    }
    
    private func commonInit() {
        backgroundColor = .white
        contentView.backgroundColor = .white
        tintColor = .white
        
        setupSubviews()
        setupConstraint()
    }
    
    private func setupSubviews() {
        contentView.addSubview(skuLabel)
        contentView.addSubview(transactionsLabel)
    }
    
    private func setupConstraint() {
        skuLabel.translatesAutoresizingMaskIntoConstraints = false
        transactionsLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            skuLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            skuLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            transactionsLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            transactionsLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }
    
}
