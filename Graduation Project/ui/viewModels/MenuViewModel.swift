//
//  MenuViewModel.swift
//  Graduation Project
//
//  Created by Gulyaz Huseynova on 20.12.22.
//

import Foundation
import RxSwift

class MenuViewModel{
    
    var foodList = BehaviorSubject<[Foods]>(value: [Foods]())
  
    var foodRepo = FoodRepo()
    
    init(){
        loadFoods()
        
        foodList = foodRepo.foodList
       
    }
    
    func loadFoods() {
        foodRepo.loadFoods()
    }
    
    func search(searchText:String, categoryList: [Foods]){
        foodRepo.search(searchText: searchText, categoryList: categoryList)
        
        
    }
}
