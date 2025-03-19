//
//  RestService.swift
//  СurrencyСonverter
//
//  Created by Владислав Артюхов on 17.03.2025.
//

import UIKit

protocol RestServiceProtocol {
    func getDomainLayerProducts(completion: @escaping (Result<[ProductsDomainLayer], CustomError>) -> ())
    func getDataLayerRates(completion: @escaping (Result<[RatesDataLayer], CustomError>) -> ())
}

final class RestService: RestServiceProtocol {
    
    func getDomainLayerProducts(completion: @escaping (Result<[ProductsDomainLayer], CustomError>) -> ()) {
        DispatchQueue.global(qos: .userInitiated).async {
            guard let model = self.getProducts(with: Constants.fileNameTransactions, extensionFile: Constants.fileExtension) else {
                DispatchQueue.main.async {
                    completion(.failure(.failedToLoadDataFromFile))
                }
                return
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                completion(.success(model))
            }
        }
    }
    
    func getDataLayerRates(completion: @escaping (Result<[RatesDataLayer], CustomError>) -> ()) {
        DispatchQueue.global(qos: .userInitiated).async {
            guard let model: [RatesDataLayer] = self.getPlistModel(with: Constants.fileNameRates, extensionFile: Constants.fileExtension) else {
                DispatchQueue.main.async {
                    completion(.failure(.failedToLoadDataFromFile))
                }
                return
            }
            DispatchQueue.main.async {
                completion(.success(model))
            }
        }
    }
}

extension RestService {
    
    private func getData(with fileName: String, extensionFile: String) -> Data? {
        guard let path = Bundle.main.path(forResource: fileName, ofType: extensionFile) else { return nil }
        return FileManager.default.contents(atPath: path)
    }
    
    private func getPlistModel<T: Decodable>(with fileName: String, extensionFile: String) -> [T]? {
        guard let data = getData(with: fileName, extensionFile: extensionFile) else { return nil }
        do {
            return try PropertyListDecoder().decode([T].self, from: data)
        } catch {
            print("Error decodable")
            return nil
        }
    }
  
    private func getProducts(with fileName: String, extensionFile: String) -> [ProductsDomainLayer]? {
        guard let model: [ProductsDataLayer] = getPlistModel(with: fileName, extensionFile: extensionFile) else { return nil }
        let groupedDict = Dictionary(grouping: model, by: { $0.sku })
        return groupedDict.map { sku, plistModels in
            let transactions = plistModels.compactMap { plistModel -> TransactionsProduct? in
                return TransactionsProduct(currency: plistModel.currency, amount: Double(plistModel.amount) ?? 0)
            }
            return ProductsDomainLayer(sku: sku, arrayTransactions: transactions)
        }.sorted { $0.sku < $1.sku }
    }
}

private extension RestService {
     enum Constants {
         static let fileNameTransactions: String = "transactions"
         static let fileNameRates: String = "rates"
         static let fileExtension: String = "plist"
    }
}
