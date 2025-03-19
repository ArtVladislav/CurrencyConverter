//
//  ProductsCell.swift
//  СurrencyСonverter
//
//  Created by Владислав Артюхов on 19.03.2025.
//

import UIKit

final class ProductsCell: CustomTableCell {
    
    static let cellId = "ProductsCell"
    
    func configure(with model: ProductsModel) {
        leftLabel.text = model.sku
        rightLabel.attributedText = getMaskText(with: model)
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
}
