//
//  BasketViewController.swift
//  GedaratamaMalu
//
//  Created by Ashan Don on 5/23/21.
//

import UIKit

class BasketViewController: UIViewController {

    @IBOutlet weak var navigationBar : UINavigationBar!
    @IBOutlet weak var cartTableView : UITableView!
    @IBOutlet weak var addItemButton : UIButton!
    @IBOutlet weak var checkoutButton : UIButton!
    @IBOutlet weak var bottomView : UIView!
    
    @IBOutlet weak var cartTableHeightConstraint: NSLayoutConstraint!
    
    fileprivate let basketCellHeight : CGFloat = 96.0
    
    public var cartList : [Product] = [Product]()
    
    fileprivate lazy var backButton : UIButton = {
       let button = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 44))
        button.setTitle(" Back", for: .normal)
        button.setImage(UIImage(named: "Arrow_Icon"), for: .normal)
        button.setTitleColor(UIColor(named: "Black_Color"), for: .normal)
        button.addTarget(self, action: #selector(backButtonDidPressed), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        cartTableView.register(UINib(nibName: "BasketCell", bundle: nil), forCellReuseIdentifier: "BASKET_CELL")
        
        cartTableView.delegate = self
        cartTableView.dataSource = self
        
        cartTableHeightConstraint.constant = (basketCellHeight * CGFloat(cartList.count))
        self.loadViewIfNeeded()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupBasketScreen()
    }

    fileprivate func setupBasketScreen(){
        
        let navigationItem = UINavigationItem(title: "Checkout")
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        navigationBar.setItems([navigationItem], animated: false)
        
        UINavigationBar.appearance().barTintColor = UIColor(named: "White_Color")
        UINavigationBar.appearance().titleTextAttributes = [
            NSAttributedString.Key.foregroundColor : UIColor(named: "TabBar_Tint_Color")!,
            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 21)
        ]
        
        //New Item Button
        addItemButton.backgroundColor = UIColor(named: "White_Color")
        //addItemButton.setTitle("Add Item", for: .normal)
        addItemButton.setAttributedTitle(NSAttributedString(string: "Add Item", attributes: [
                                                                NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 21),
                                                                NSAttributedString.Key.foregroundColor : UIColor(named: "TabBar_Tint_Color")!
        ]), for: .normal)
        addItemButton.layer.cornerRadius = CGFloat(12)
        addItemButton.layer.borderWidth = 1
        addItemButton.layer.borderColor = UIColor(named: "TabBar_Tint_Color")!.cgColor
        
        //New Item Button
        checkoutButton.backgroundColor = UIColor(named: "TabBar_Tint_Color")
        //checkoutButton.setTitle("Add Item", for: .normal)
        checkoutButton.setAttributedTitle(NSAttributedString(string: "Checkout", attributes: [
                                                                NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 21),
                                                                NSAttributedString.Key.foregroundColor : UIColor(named: "White_Color")!
        ]), for: .normal)
        checkoutButton.layer.cornerRadius = CGFloat(12)
        
        //setup shadow in bottom View
        bottomView.applyViewShadow(color: UIColor(named: "Custom_Black_Color")!, alpha: 1, x: 0, y: -5, blur: 0, spread: 2)
    }
    
    @objc fileprivate func backButtonDidPressed(){
        
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = .moveIn
        transition.subtype = .fromRight
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        self.view.window!.layer.add(transition, forKey: kCATransition)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addItemDidPresse() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            let tabbar: UITabBarController? = (UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TAB_BAR_SCREEN") as? UITabBarController)
            
            let transition = CATransition()
            transition.duration = 0.7
            transition.type = .push
            transition.subtype = .fromRight
            transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            self.view.window!.layer.add(transition, forKey: kCATransition)
            
            guard let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else { return }
            
            window.rootViewController = tabbar
        }
    }
    
}

extension BasketViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return basketCellHeight
    }
}

extension BasketViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = cartTableView.dequeueReusableCell(withIdentifier: "BASKET_CELL") as! BasketCell
        cell.getProduct = cartList[indexPath.row]
        return cell
    }
    
    
    
}
