//
//  CartViewModel.swift
//  Graduation Project
//
//  Created by Gulyaz Huseynova on 22.12.22.
//

import Foundation
import RxSwift

class CartViewModel{
    
    var foodRepo = FoodRepo()
    var cartList = BehaviorSubject<[CartModel]>(value: [CartModel]())
    var orderList = BehaviorSubject<[FoodCart]>(value: [FoodCart]())
    
    init(){
        loadCart()
        loadOrders(userName: foodRepo.userName)
        cartList = foodRepo.cartList
        orderList = foodRepo.orderList
    }
    
    func loadCart(){
        foodRepo.loadCart()
    }
    
    
    func loadOrders(userName: String){
        foodRepo.loadOrders(userName: userName)
    }
    
    func deleteCart(food: CartModel) {
        foodRepo.deleteCart(food: food)
    }
    
    func confirmOrder(cartList: [CartModel]){
        foodRepo.confirmOrder(cartList: cartList)
    }
    
    func deleteOrder(orderId:Int, userName: String){
        foodRepo.deleteOrder(orderId: orderId, userName: userName)

    }
}

