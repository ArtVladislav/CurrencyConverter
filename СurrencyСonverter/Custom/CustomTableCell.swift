//
//  CustomTableCell.swift
//  СurrencyСonverter
//
//  Created by Владислав Артюхов on 19.03.2025.
//
import UIKit

class CustomTableCell: UITableViewCell {
    
    var leftLabel: CustomUILabel
    var rightLabel: CustomUILabel
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        leftLabel = CustomUILabel()
        rightLabel = CustomUILabel()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        contentView.backgroundColor = selected ? UIColor.lightGray : UIColor.white
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        contentView.backgroundColor = highlighted ? UIColor.lightGray : UIColor.white
    }
    
    private func commonInit() {
        backgroundColor = .white
        rightLabel.textColor = .gray
        setupSubviews()
        setupConstraint()
    }
    
    private func setupSubviews() {
        contentView.addSubview(leftLabel)
        contentView.addSubview(rightLabel)
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            leftLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            leftLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            rightLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            rightLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }
}
