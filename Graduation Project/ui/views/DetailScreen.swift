//
//  DetailScreen.swift
//  Graduation Project
//
//  Created by Gulyaz Huseynova on 20.12.22.
//

import UIKit
import Kingfisher

class DetailScreen: UIViewController {
    
    @IBOutlet weak var successView: UIView!{
        didSet{
            
            successView.layer.borderWidth = 2
            successView.layer.borderColor = UIColor(named: "brown")?.withAlphaComponent(0.2).cgColor
        }
    }
    
    @IBOutlet weak var lblSuccess: UILabel!
    
    @IBOutlet weak var additivesView: UIStackView!
    

 
    
    var timer = Timer()

    var counter = 1
    var viewModel = DetailViewModel()
    var menuFood: Foods?
    var cartFood: CartModel?
    var foodCategory: String?
    var count = 1
    var currPrice = 0
    var firstPrice = 0
    var additive1Selected = false
    var additive2Selected = false
    var additive3Selected = false
    
    @IBOutlet weak var viewAdditive1: UIView!
    @IBOutlet weak var viewAdditive2: UIView!
    @IBOutlet weak var viewAdditive3: UIView!
    
    @IBOutlet weak var btnAddToCart: UIButton!
    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var btnAdditive1: UIButton!
    @IBOutlet weak var btnAdditive2: UIButton!
    @IBOutlet weak var btnAdditive3: UIButton!
    @IBOutlet weak var lblAdditive1: UILabel!
    @IBOutlet weak var lblAdditive2: UILabel!
    @IBOutlet weak var lblAdditive3: UILabel!
    
    
    
    @IBOutlet weak var foodImage: UIImageView!
    
    @IBOutlet weak var foodPriceLabel: UILabel!
    @IBOutlet weak var foodNameLabel: UILabel!
    
    @IBOutlet weak var countLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        checkPresence()
 
        loadData()
        
        setUpDesign()
    }
    
//    func checkPresence(){
//
//        if let cartFood{
//            setUpCartData(data: cartFood)
//        }
//
//
//
//        if let menuFood{
//            if viewModel.check(menuFood: menuFood).0 == true {
//                if let item = viewModel.check(menuFood: menuFood).1{
//                    self.cartFood = item
//                    setUpCartData(data: item)
//                }
//            }else{
//                setUpMenuData(data: menuFood)
//            }
//        }
//
//    }
    
    func loadData(){
        if let cartFood{
            setUpCartData(data: cartFood)
        }
        
        if let menuFood{
            
            setUpMenuData(data: menuFood)
            
        }
    }
    
    
    func setUpMenuData(data: Foods){
        
        foodCategory = data.category
        foodNameLabel.text = data.name
        foodPriceLabel.text = "$\(data.price ?? 0)"
        foodImage.kf.setImage(with:
                                URL(string: "http://kasimadalan.pe.hu/foods/images/\(data.image ?? "")" ))
        firstPrice = Int(data.price ?? 0)
        currPrice = Int(data.price ?? 0)
        lblSuccess.text = "Successfully Added"
    }
    func setUpCartData(data: CartModel){
        firstPrice = Int(data.price)
        currPrice = Int(data.price * data.orderAmount)
        
        
        foodCategory = data.category
        foodNameLabel.text = data.name

        count = Int(data.orderAmount)
        
        countLabel.text = "\(count)" //count label
        foodPriceLabel.text = "$\(currPrice)" //price label
        
        
        foodImage.kf.setImage(with:
                                URL(string: "http://kasimadalan.pe.hu/foods/images/\(data.image ?? "")" ))
        
        btnAddToCart.setTitle("Update Order", for: .normal)
        btnAddToCart.titleLabel!.font =  UIFont(name: "Trebuchet MS", size: 20)
   
        
        lblSuccess.text = "Successfully Updated"
    }
    
    
    @IBAction func addToCartPressed(_ sender: Any) {
        
        print("food added to cart")
        timer.invalidate() //timer stop
        successView.isHidden = false
        
        if let cartFood{
            viewModel.update(cartFood: cartFood, orderAmount: count)
            btnAddToCart.isHidden = true
        }
        
        if let menuFood{
            
            let cartItem = FoodCart(id: menuFood.id!, name: menuFood.name!, image: menuFood.image!, price: menuFood.price!, category: menuFood.category!, orderAmount: count, userName: "Gulyaz")
            
            viewModel.addToCart(cartItem: cartItem)
            btnAddToCart.isHidden = true
            
            
        }
//        if let menuFood{
//            if let cartFood{
//                viewModel.update(cartFood: cartFood, orderAmount: count)
//                btnAddToCart.isHidden = true
//            }
//
//            else{
//                let cartItem = FoodCart(id: menuFood.id!, name: menuFood.name!, image: menuFood.image!, price: menuFood.price!, category: menuFood.category!, orderAmount: count, userName: "Gulyaz")
//
//                viewModel.addToCart(cartItem: cartItem)
//                btnAddToCart.isHidden = true
//
//            }
//        }
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
        
    }
    
    @objc func updateCounter() {
                
        if counter > 0 {
            counter -= 1
        }else {
            timer.invalidate()
            successView.isHidden = true
            successView.alpha = 1
            btnAddToCart.isHidden = false
//            checkPresence()
            
        }
    }
    
    
    
    @IBAction func minusButton(_ sender: Any) {
        if count > 1 {
            count -= 1
            countLabel.text = "\(count)"

            currPrice -= firstPrice
            foodPriceLabel.text = "$\(currPrice)"
        }
    }
    
    @IBAction func plusButton(_ sender: Any) {
        count += 1
        countLabel.text = "\(count)"
        currPrice += firstPrice
        foodPriceLabel.text = "$\(currPrice)"
    }
    

    @IBAction func additive1Pressed(_ sender: Any) {
        if additive1Selected == false{
            viewAdditive1.backgroundColor = UIColor(named: "beige")
            viewAdditive1.layer.borderWidth = 2
            viewAdditive1.layer.borderColor = UIColor(named: "brown")?.withAlphaComponent(0.2).cgColor
            additive1Selected = true
        }else{
            viewAdditive1.backgroundColor = .white
            viewAdditive1.layer.borderWidth = 0
        }
    }
    
    @IBAction func additive2Pressed(_ sender: Any) {
        if additive2Selected == false{
            viewAdditive2.backgroundColor = UIColor(named: "beige")
            viewAdditive2.layer.borderWidth = 2
            viewAdditive2.layer.borderColor = UIColor(named: "brown")?.withAlphaComponent(0.2).cgColor
            additive2Selected = true
        }else{
            viewAdditive2.backgroundColor = .white
            viewAdditive2.layer.borderWidth = 0
        }
       
    }
    @IBAction func additive3Pressed(_ sender: Any) {
        if additive3Selected == false{
            viewAdditive3.backgroundColor = UIColor(named: "beige")
            viewAdditive3.layer.borderWidth = 2
            viewAdditive3.layer.borderColor = UIColor(named: "brown")?.withAlphaComponent(0.2).cgColor
            additive3Selected = true
        }else{
            viewAdditive3.backgroundColor = .white
            viewAdditive3.layer.borderWidth = 0
        }
       
    }

    func setUpDesign(){
        
        successView.isHidden = true
        //BackView
        backView.clipsToBounds = true
        backView.layer.cornerRadius = 30
        backView.layer.borderWidth = 2
        backView.layer.borderColor = UIColor(named: "brown")?.withAlphaComponent(0.2).cgColor
        backView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        switch foodCategory{
        case "Meals":
            btnAdditive1.setImage(UIImage(named: "m1"), for: .normal)
            btnAdditive2.setImage(UIImage(named: "m2"), for: .normal)
            btnAdditive3.setImage(UIImage(named: "m3"), for: .normal)
            
            lblAdditive1.text = "Sauces"
            lblAdditive2.text = "Pickles"
            lblAdditive3.text = "Seasoning"
        case "Desserts":
            btnAdditive1.setImage(UIImage(named: "ds1"), for: .normal)
            btnAdditive2.setImage(UIImage(named: "ds2"), for: .normal)
            btnAdditive3.setImage(UIImage(named: "ds3"), for: .normal)
            lblAdditive1.text = "Caramel"
            lblAdditive2.text = "Cream"
            lblAdditive3.text = "Hazelnut"
        case "Drinks":
            btnAdditive1.setImage(UIImage(named: "dr1"), for: .normal)
            btnAdditive2.setImage(UIImage(named: "dr2"), for: .normal)
            //                btnAdditive3.setImage(UIImage(named: "dr3"), for: .normal)
            lblAdditive1.text = "Ice cubes"
            lblAdditive2.text = "Straw"
            lblAdditive3.text = ""
        default:
            fatalError()
        }
    }
}
