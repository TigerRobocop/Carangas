//
//  REST.swift
//  Carangas
//
//  Created by Aluno on 03/08/18.
//  Copyright © 2018 Liv Souza. All rights reserved.
//

import Foundation
import Alamofire



enum CarError {
    case url
    case taskError(error: Error)
    case noResponse
    case noData
    case responseStatusCode(code: Int)
    case invalidJSON
}

enum RESTOperation {
    case save
    case update
    case delete
}


class REST {
    private static let basePath = "https://carangas.herokuapp.com/cars"
    
    class func loadBrands(onComplete: @escaping ([Brand]?) -> Void, onError: @escaping (CarError) -> Void) {
        
        let urlFipe = "https://fipeapi.appspot.com/api/1/carros/marcas.json"
        guard let url = URL(string: urlFipe) else {
            onError(.url)
            return
        }
        
        Alamofire.request(url)
            .validate()
            .responseJSON { response in
                guard response.result.isSuccess else {
                    onComplete(nil)
                    return
                }
                
                do {
                    let brands = try JSONDecoder().decode([Brand].self, from: response.data!)
                    onComplete(brands)
                } catch {
                    print(error.localizedDescription)
                    onComplete(nil)
                }
        }
    }
    
    class func loadCars(onComplete: @escaping ([Car]) -> Void, onError: @escaping (CarError) -> Void) {
        
        guard let url = URL(string: basePath) else {
            onError(.url)
            return
        }
        
        Alamofire.request(url)
            .validate()
            .responseJSON { response in
                guard response.result.isSuccess else {
                    onError(.url)
                    return
                }
                
                do {
                    let cars = try JSONDecoder().decode([Car].self, from: response.data!)
                    onComplete(cars)
                } catch {
                    onError(.invalidJSON)
                }
        }
    }

    class func delete(car: Car, onComplete: @escaping (Bool) -> Void, onError: @escaping (CarError) -> Void) {
        applyOperation(car: car, operation: .delete, onComplete: onComplete, onError: onError)
    }
    
    
    class func save(car: Car, onComplete: @escaping (Bool) -> Void, onError: @escaping (CarError) -> Void) {
        applyOperation(car: car, operation: .save, onComplete: onComplete, onError: onError)
    }
    
    class func update(car: Car, onComplete: @escaping (Bool) -> Void, onError: @escaping (CarError) -> Void ) {
        applyOperation(car: car, operation: .update, onComplete: onComplete, onError: onError)
    }
    
    
    private class func applyOperation(car: Car, operation: RESTOperation , onComplete: @escaping (Bool) -> Void, onError: @escaping (CarError) -> Void ) {

        let urlString = basePath + "/" + (car._id ?? "")
        
        guard let url = URL(string: urlString) else {
            onError(.url)
            return
        }
        
        // 2
        var request = URLRequest(url: url)
        var httpMethod: String = ""
        
        switch operation {
        case .delete:
            httpMethod = "DELETE"
        case .save:
            httpMethod = "POST"
        case .update:
            httpMethod = "PUT"
        }
        request.httpMethod = httpMethod
        
        guard let json = try? JSONEncoder().encode(car) else {
            onError(.invalidJSON)
            return
        }
        request.httpBody = json
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        
        Alamofire.request(request)
            .responseJSON { response in
                
                if let status = response.response?.statusCode {
                    switch(status){
                    case 200:
                        onComplete(true)
                    default:
                        onError(.responseStatusCode(code: status))
                    }
                }
        }
    }
}



