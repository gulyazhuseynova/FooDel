//
//  DetailViewModel.swift
//  Graduation Project
//
//  Created by Gulyaz Huseynova on 22.12.22.
//

import Foundation
import RxSwift

class DetailViewModel{
    
    var foodRepo = FoodRepo()

    
    func addToCart(cartItem: FoodCart){
        foodRepo.addToCart(cartItem: cartItem)
    }
    
    func update(cartFood: CartModel, orderAmount: Int){
        foodRepo.update(cartFood: cartFood, orderAmount: orderAmount)
    }
    
//    func check(menuFood: Foods) -> (Bool, CartModel?) {
//        foodRepo.check(menuFood: menuFood)
//        
//    }
}

