//
//  ViewController.swift
//  Graduation Project
//
//  Created by Gulyaz Huseynova on 19.12.22.
//

import UIKit
import Kingfisher
import SideMenu


class MenuScreen: UIViewController {
    

    var foodCategory = "All"
    var whichListSelect = [Foods]()
 
    
    var viewModel = MenuViewModel()
    var allFoodList = [Foods]()
    
    
    var mealsList = [Foods]()
    var dessertsList = [Foods]()
    var drinksList = [Foods]()
    
    var lblItems = ["All", "Meals", "Desserts", "Drinks"]
    
    @IBOutlet weak var searchBar: UISearchBar!{
        didSet{
            searchBar.searchTextField.leftView?.tintColor = UIColor(named: "black")
            searchBar.delegate = self
        }
    }
    @IBOutlet weak var collectionView: UICollectionView!{
        didSet{
            collectionView.dataSource = self
            collectionView.delegate = self
        
        }
    }
    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    
    @IBOutlet weak var lblLocation: UIButton!
    @IBOutlet weak var menuBarItem: UIBarButtonItem!
    @IBOutlet weak var profileBarItem: UIBarButtonItem!
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.loadFoods()
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        loadData()
        
    }
    
    func loadData(){
        _ = viewModel.foodList.subscribe(onNext: { [self] list in
            self.allFoodList = list
             //for the first time; before selection of collectionview cell (All)

        
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
            //Seperating list - based on food categories
            
            mealsList = [Foods]()
            dessertsList = [Foods]()
            drinksList = [Foods]()
            
            
            for food in allFoodList{
                
                if food.category == "Meals"{
                    self.mealsList.append(food)

                }
                if food.category == "Desserts"{
                    self.dessertsList.append(food)
                 
                }
                if food.category == "Drinks"{
                    self.drinksList.append(food)
                   
                }
            }
         
            
            switch foodCategory{
            
            case "Meals":
                self.whichListSelect = mealsList
               
            case "Desserts":
                self.whichListSelect = dessertsList
                
            case "Drinks":
                self.whichListSelect = drinksList
                
            default:
                self.whichListSelect = list
            }
            
        })
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetail" {
            if let food = sender as? Foods {
                let detailScreen = segue.destination as! DetailScreen
                detailScreen.menuFood = food
            }
        }
    }
    
 
    
    func setUpView(){
        
        
        
        
        
        //SET leftBarButtonItem
//        let menuBtn = UIButton(type: .custom)
//        menuBtn.setImage(UIImage(named:"menu"), for: .normal)
//        menuBarItem.customView = menuBtn
//        menuBarItem.customView?.widthAnchor.constraint(equalToConstant: 20).isActive = true
//        menuBarItem.customView?.heightAnchor.constraint(equalToConstant: 20).isActive = true
//        self.navigationItem.leftBarButtonItem = menuBarItem
        
//      SET rightBarButtonItem
        let profileBtn = UIButton(type: .custom)
        profileBtn.setImage(UIImage(named:"profile"), for: .normal)
        profileBarItem.customView = profileBtn
        profileBarItem.customView?.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileBarItem.customView?.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.navigationItem.rightBarButtonItem = profileBarItem
        
        //Curve TopRight and TopLeft of TableView
        
        tableView.clipsToBounds = true
        tableView.layer.cornerRadius = 30
        tableView.layer.borderWidth = 2
        tableView.layer.borderColor = UIColor(named: "brown")?.withAlphaComponent(0.2).cgColor
        tableView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        
    }
    
    
    @IBAction func profileBarItemPressed(_ sender: UIBarButtonItem) {
    }
    

    
}

extension MenuScreen : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.search(searchText: searchText, categoryList: whichListSelect)
    }
    
   
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
   
        self.searchBar.endEditing(true)
        
    }
}

extension MenuScreen: UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        lblItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! CategoriesCollectionViewCell
        
        if indexPath.row == 0 {
            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .left)
            cell.isSelected = true
            
        }
        
        let item = lblItems[indexPath.row]
        cell.categoriesImage.image = UIImage(named: item)
        cell.categoriesLabel.text = item

        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let foodCategory = lblItems[indexPath.row]
//        foodCategory = item
        
        
        
        switch foodCategory{
        case "All":
            self.whichListSelect = allFoodList
            tableView.reloadData()
        case "Meals":
            self.whichListSelect = mealsList
            tableView.reloadData()
        case "Desserts":
            self.whichListSelect = dessertsList
            tableView.reloadData()
        case "Drinks":
            self.whichListSelect = drinksList
            tableView.reloadData()
        default:
            fatalError()
            
            
        }
        
    }
}

extension MenuScreen: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return whichListSelect.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! FoodTableViewCell
        
        let item = whichListSelect[indexPath.row]
        
        cell.foodNameLabel.text = item.name
        cell.priceLabel.text = "$\(item.price ?? 0)"
        cell.foodImage.kf.setImage(with: URL(string: "http://kasimadalan.pe.hu/foods/images/\(item.image ?? "")" ))
        
        
        return cell
    }
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let food = whichListSelect[indexPath.row]
        performSegue(withIdentifier: "toDetail", sender: food)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}


