//
//  CustomError.swift.swift
//  СurrencyСonverter
//
//  Created by Владислав Артюхов on 18.03.2025.
//
import Foundation

enum CustomError: Error, LocalizedError {
    case failedToLoadDataFromFile
    case calculationError
    case customError(message: String)
    
    var errorDescription: String? {
        switch self {
        case .failedToLoadDataFromFile:
            return NSLocalizedString("Ошибка чтения", comment: "Не удалось получить данные из файла")
        case .calculationError:
            return NSLocalizedString("Ошибка вычисления", comment: "Не удалось вычислить значения")
        case .customError(message: let message):
            return NSLocalizedString(message, comment: "Custom error")
        }
    }
}
