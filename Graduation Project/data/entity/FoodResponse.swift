//
//  FoodResponse.swift
//  Graduation Project
//
//  Created by Gulyaz Huseynova on 20.12.22.
//

import Foundation

class FoodResponse: Codable{
    var foods: [Foods]?
}

class FoodResponse2: Codable{
    var foods_cart: [FoodCart]?
}

class Foods: Codable{
    
    var id: Int?
    var name: String?
    var image: String?
    var price: Int?
    var category: String?
    
    internal init(id: Int, name: String, image: String, price: Int, category: String) {
        self.id = id
        self.name = name
        self.image = image
        self.price = price
        self.category = category
    }
    
}



class FoodCart: Codable{
    var id: Int?
    var cartId: Int?
    var name: String?
    var image: String?
    var price: Int?
    var category: String?
    var orderAmount: Int?
    var userName: String?
    
    internal init(id: Int, name: String, image: String, price: Int, category: String, orderAmount: Int, userName: String) {
        
        self.id = id 
        self.name = name
        self.image = image
        self.price = price
        self.category = category
        self.orderAmount = orderAmount
        self.userName = userName
    
    }
}
