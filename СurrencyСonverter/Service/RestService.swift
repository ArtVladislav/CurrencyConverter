//
//  RestService.swift
//  СurrencyСonverter
//
//  Created by Владислав Артюхов on 17.03.2025.
//
import UIKit

protocol RestServiceProtocol {
    func requestData(completion: @escaping (Result<String, Error>) -> ())
}

final class RestService: RestServiceProtocol {
    func requestData(completion: @escaping (Result<String, Error>) -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            completion(.success("Hello world"))
        }
    }
}

extension RestService {
    func loadProductsFromPlist() -> [ProductsModel]? {
        guard let path = Bundle.main.path(forResource: "transactions", ofType: "plist"),
              let plistData = FileManager.default.contents(atPath: path),
              let plistArray = try? PropertyListSerialization.propertyList(from: plistData, options: [], format: nil) as? [[String: String]] else {
            return nil
        }
        
        // Преобразуем массив словарей в массив моделей Product
        let products = plistArray.compactMap { dict -> ProductsModel? in
            guard let amount = dict["amount"],
                  let currency = dict["currency"],
                  let sku = dict["sku"] else {
                return nil
            }
            return ProductsModel(amount: amount, currency: currency, sku: sku)
        }
        
        return products
    }
}
