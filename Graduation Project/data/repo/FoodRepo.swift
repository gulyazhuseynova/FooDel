//
//  FoodRepo.swift
//  Graduation Project
//
//  Created by Gulyaz Huseynova on 20.12.22.
//

import Foundation
import RxSwift
import Alamofire

class FoodRepo{
    
    var userName = "Gulyaz"
    
    var foodList = BehaviorSubject<[Foods]>(value: [Foods]())
    var cartList = BehaviorSubject<[CartModel]>(value: [CartModel]())
    var orderList = BehaviorSubject<[FoodCart]>(value: [FoodCart]())

    
    
    var allCart = [CartModel]()
    
    let context = ad.persistentContainer.viewContext
    

    
    let defaults = UserDefaults.standard
    
    
    
    func loadFoods(){
        AF.request("http://kasimadalan.pe.hu/foods/getAllFoods.php", method: .get).response {response in
            if let data = response.data{
                do{
                    let result = try JSONDecoder().decode(FoodResponse.self, from: data)
                    if let list = result.foods{
                        
                        self.foodList.onNext(list)
                    }
                }catch{
                    print(error.localizedDescription)
                }
            }
            
        }
    }
    
    func update(cartFood: CartModel, orderAmount: Int){
        cartFood.orderAmount = Int32(orderAmount)
        ad.saveContext()
    }
    
    func search(searchText:String, categoryList: [Foods]){
        
        if (searchText == "") {
            loadFoods()
        }
        else{
            foodList.onNext([]) //empty list
             
            var list = [Foods]() //empty list for adding matched elements
            
            for food in categoryList{

                if let string = food.name{
                
                    if string.contains(searchText){
                        list.append(food)
                    }
                    self.foodList.onNext(list)
                }
           
            }
        }
    }
    
    func addToCart(cartItem: FoodCart) {
        

        
        let newFood = CartModel(context: context)
        
        print("old cart addtocart",newFood.cartId )
        print("menu addtocart",cartItem.id! )
        newFood.cartId = Int32(cartItem.id!)
        print("new cart addtocart",newFood.cartId )
        newFood.name = cartItem.name
        newFood.image = cartItem.image
        newFood.price = Int32(cartItem.price ?? 0)
        newFood.orderAmount = Int32(cartItem.orderAmount ?? 0)
        newFood.category = cartItem.category
        newFood.userName = cartItem.userName
      
        ad.saveContext()
        
    }
    
    
    func confirmOrder(cartList: [CartModel]){
        
        
        for item in cartList{
            
            
            let params: Parameters = ["name": item.name!, "image": item.image!, "price" : item.price,  "category": item.category!, "orderAmount": item.orderAmount, "userName": item.userName!]
            AF.request("http://kasimadalan.pe.hu/foods/insertFood.php", method: .post, parameters: params).response { response in
                if let data = response.data{
                    do{
                        let result = try JSONDecoder().decode(CRUDResponse.self, from: data)
                        print("Success: \(result.success!)")
                        print("Message: \(result.message!)")
                        
                        for food in cartList{
                            self.deleteCart(food: food)
                        }
                    }
                    catch{
                        print(error.localizedDescription)
                    }
                }
            }
            
            
            
        }
        
        
        
        
    }
   
    func loadCart(){
        do{
            let cartList = try context.fetch(CartModel.fetchRequest())
            self.allCart = cartList
            self.cartList.onNext(cartList)
        }catch{
            print("error load cart:",error.localizedDescription    )
        }
    }
    
    func loadOrders(userName: String){
        let params: Parameters = ["userName": userName]
        AF.request("http://kasimadalan.pe.hu/foods/getFoodsCart.php", method: .post, parameters: params).response { response in
            
            if let data = response.data{
           
                do{
                   
                    self.orderList.onNext([]) //in case result cannot be decoded, orderlist will be empty
                    
                    let result = try JSONDecoder().decode(FoodResponse2.self, from: data)

                    if let list = result.foods_cart{
                        
                        self.orderList.onNext(list)
                    }
                    
                }catch{
                    print("error load orders:", error.localizedDescription)
                }
            }
        }
    }
    
    func deleteCart(food: CartModel){
        context.delete(food)
        ad.saveContext()
        loadCart()
    }
    
    func deleteOrder(orderId:Int, userName: String){
        let params: Parameters = ["cartId": orderId, "userName": userName]
        AF.request("http://kasimadalan.pe.hu/foods/deleteFood.php", method: .post, parameters: params).response { response in
            if let data = response.data{
                do{
                    let result = try JSONDecoder().decode(CRUDResponse.self, from: data)
                    print("Success: \(result.success!)")
                    print("Message: \(result.message!)")
                    self.loadOrders(userName: userName)
                }catch{
                    print(error.localizedDescription)
                }
            }
        }
    }
//    
//    func check(menuFood: Foods) -> (Bool, CartModel?){
//        
//        loadCart()
//        print(allCart.count)
//        for item in allCart{
//                
//            if menuFood.id! == item.cartId {
//             //menu item is present in cartList
//
//                return (true, item)
//            }
//        }
//
//        return (false, nil)
//    }

}
