//
//  CustomElement.swift
//  СurrencyСonverter
//
//  Created by Владислав Артюхов on 19.03.2025.
//
import UIKit

final class CustomUILabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        textColor = .black
        text = ""
        font = .systemFont(ofSize: 17, weight: .medium)
        backgroundColor = .clear
    }
}

