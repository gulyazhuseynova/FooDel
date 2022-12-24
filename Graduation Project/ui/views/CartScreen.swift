//
//  CartScreen.swift
//  Graduation Project
//
//  Created by Gulyaz Huseynova on 22.12.22.
//

import UIKit

class CartScreen: UIViewController {

    @IBOutlet weak var payButton: UIButton!
    var userName = "Gulyaz"
    var viewModel = CartViewModel()
    
    var cartList = [CartModel]()
    var orderList = [FoodCart]()
    var whichListSelect = [CartModel]()
    
    var screenType: String?
    
    var timer = Timer()
    var count = 1
    
    @IBOutlet weak var backView: UIView!

    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        switch screenType{
            
        case "My Orders":
            viewModel.loadOrders(userName: self.userName)
        default:
            viewModel.loadCart()
            calculatePrice()
        }
        
        setUpDesign()

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let screenType{
            title = screenType
        }
        
        
        switch screenType{
            
        case "My Orders":
            _ = viewModel.orderList.subscribe(onNext: { [self] list in
                
                self.orderList = list
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            })
        default:
            _ = viewModel.cartList.subscribe(onNext: { [self] list in
                
                self.cartList = list
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            })
        }
    }
 
    func calculatePrice(){
        var totalPrice = 0
        
        for item in cartList{
            totalPrice += Int(item.price * item.orderAmount)
        }
        lblPrice.text = "$\(totalPrice)"
        
    }
    
    func setUpDesign(){
        
        if screenType == "My Orders"{
            backView.isHidden = true
        }else{
            backView.isHidden = false
        }

        
        //BackView
        backView.clipsToBounds = true
        backView.layer.cornerRadius = 30
        backView.layer.borderWidth = 2
        backView.layer.borderColor = UIColor(named: "brown")?.withAlphaComponent(0.2).cgColor
        backView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "fromCartToDetail" {
            if let food = sender as? CartModel{
                let detailScreen = segue.destination as! DetailScreen
                detailScreen.cartFood = food

            }
        }
    }
    
    
    @IBAction func payPressed(_ sender: Any) {

        if self.cartList.count > 0 {
            
            print("order is confirmed")
            
            timer.invalidate()
            // For some time, button appears green
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
            payButton.backgroundColor = UIColor(named: "green")
            payButton.setTitleColor(.darkGray, for: .normal)
            payButton.setTitle("Payment Successful", for: .normal)
            payButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
            payButton.tintColor = .darkGray
            
            
        }else{
            payButton.isUserInteractionEnabled = false
        }
    }
    @objc func updateCounter() {
                
        if count > 0 {
            count -= 1
            
        }else {
            timer.invalidate()
            
            viewModel.confirmOrder(cartList: cartList)
            payButton.backgroundColor = UIColor(named: "black")
            payButton.setTitleColor(.white, for: .normal)
            payButton.setTitle("Pay", for: .normal)
            payButton.setImage(UIImage(systemName: "apple.logo"), for: .normal)
            payButton.tintColor = .white
        }
            
        
    }
    
  

}
extension CartScreen: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch screenType{
        case "My Cart":
            return self.cartList.count
        case "My Orders":
            return self.orderList.count
        default:
            fatalError()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! CartTableViewCell
        
        switch screenType{
        case "My Cart":
            let item = cartList[indexPath.row]
            
            cell.foodNameLabel.text = item.name
            cell.categoryLabel.text = "Category: \(item.category ?? "")"
            cell.priceLabel.text = "Price: $\(item.price ) x \(item.orderAmount ) = $\(item.price * item.orderAmount)"
            cell.orderAmountLabel.text = "Order Amount: \(item.orderAmount )"
            cell.foodImage.kf.setImage(with: URL(string: "http://kasimadalan.pe.hu/foods/images/\(item.image ?? "")" ))
            cell.orderIdLabel.text = ""
            
            return cell
        case "My Orders":
            let item = orderList[indexPath.row]
            cell.foodNameLabel.text = item.name
            cell.categoryLabel.text = "Category: \(item.category ?? "")"
            cell.priceLabel.text = "Total Price: $\(item.price ?? 0) x \(item.orderAmount ?? 1) = $\(item.price! * item.orderAmount!)"
            cell.orderAmountLabel.text = "Order Amount: \(item.orderAmount ?? 1 )"
            cell.foodImage.kf.setImage(with: URL(string: "http://kasimadalan.pe.hu/foods/images/\(item.image ?? "")" ))
            cell.orderIdLabel.text = "Order ID: \(item.cartId!)"

            
            return cell
        default:
            fatalError()
        }
        

        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        
        
        switch screenType{
        case "My Cart":
            
            let deleteAction = UIContextualAction(style: .destructive, title: "Remove from Cart"){
                (action,view,bool) in
                let item = self.cartList[indexPath.row]
                
                let alert = UIAlertController(title: "Remove from Cart", message: "Do you want to remove \(item.name!) ?", preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
                alert.addAction(cancelAction)
                
                let yesAction = UIAlertAction(title: "Yes", style: .destructive){ action in
                    print("\(item.name!) deleted")
                    
                    self.viewModel.deleteCart(food: item)
                    self.calculatePrice()
                    
                }
                alert.addAction(yesAction)
                self.present(alert, animated: true)
                
            }
            
            return UISwipeActionsConfiguration(actions: [deleteAction])
            
        case "My Orders":
            
            let deleteAction = UIContextualAction(style: .destructive, title: "Cancel Order"){
                (action,view,bool) in
                let item = self.orderList[indexPath.row]
                
                let alert = UIAlertController(title: "Cancel the Order", message: "Do you want to cancel \(item.name!) order?", preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title: "No", style: .cancel)
                alert.addAction(cancelAction)
                
                let yesAction = UIAlertAction(title: "Yes", style: .destructive){ action in
                    print("\(item.name!) deleted")

                    self.viewModel.deleteOrder(orderId: item.cartId!, userName: self.userName)
                    
                }
                alert.addAction(yesAction)
                self.present(alert, animated: true)
                
            }
            
            return UISwipeActionsConfiguration(actions: [deleteAction])
            
        
        default:
            fatalError()
        }
        
    }
    

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if screenType == "My Cart"{
            let food = cartList[indexPath.row]
            performSegue(withIdentifier: "fromCartToDetail", sender: food)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
