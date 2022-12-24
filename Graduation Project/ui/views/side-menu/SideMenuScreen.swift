//
//  SideMenuScreen.swift
//  Graduation Project
//
//  Created by Gulyaz Huseynova on 23.12.22.
//

import UIKit

class SideMenuScreen: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toCart" {
            let cartScreen = segue.destination as! CartScreen
            cartScreen.screenType = "My Cart"
        }
        
        if segue.identifier == "toOrders" {
            let cartScreen = segue.destination as! CartScreen
            cartScreen.screenType = "My Orders"
        }
    
    }
    

}
