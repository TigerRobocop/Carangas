//
//  Car.swift
//  Carangas
//
//  Created by Aluno on 03/08/18.
//  Copyright © 2018 Liv Souza. All rights reserved.
//

class Car: Codable {
    
//    {
//        "_id":"400dd15a760f0e145b255233",
//        "brand":"Ford",
//        "gasType":2,
//        "name":"Fusion",
//        "price":110000.0
//    }
    
    
    var _id: String?
    var brand: String = "" // marca
    var gasType: Int = 0
    var name: String = ""
    var price: Double = 0.0
    
    var gas: String {
        switch gasType {
        case 0:
            return "Flex"
        case 1:
            return "Álcool"
        default:
            return "Gasolina"
        }
    }
}

struct Brand: Codable {
    let fipe_name: String
}
