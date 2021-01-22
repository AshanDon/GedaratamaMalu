//
//  CartViewController.swift
//  GedaratamaMalu
//
//  Created by Ashan Don on 1/21/21.
//

import UIKit

protocol CartListDelegate : class {
    func updateCartList(_ list : [Product])
}
class CartViewController: UIViewController {

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var cartCountLabel: UILabel!
    @IBOutlet weak var separetarView: UIView!
    @IBOutlet weak var cartTableView: UITableView!
    @IBOutlet weak var priceBackgroundView: UIView!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var proceedButton: UIButton!
    
    @IBOutlet weak var navigationViewTopConstraint: NSLayoutConstraint!
    
    
    private var cartList : [Product] = [Product]()
    private var dataFilePath = FileManager.default.urls(for: .documentDirectory, in:.userDomainMask).first?.appendingPathComponent("TemparyCartList.plist")
    
    weak var delegate : CartListDelegate?
    
    var setCartList : [Product]!{
        didSet{
            guard let list = setCartList else { return }
            self.cartList = list
        }
    }
    
    private lazy var emptyCartView : UIImageView = {
       
        let imageView = UIImageView(image: UIImage(named: "Empty_Cart"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .none
        imageView.contentMode = .scaleToFill
        imageView.addSubview(emptyCartTitle)
        return imageView
    }()
    
    private lazy var emptyCartTitle : UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Your Cart Is Empty"
        label.textAlignment = .center
        label.textColor = UIColor(named: "Black_Color")
        label.font = UIFont(name: "Helvetica-Bold", size: 22)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cartTableView.register(UINib(nibName: "CartRowViewCell", bundle: nil), forCellReuseIdentifier: "CART_ROW_CELL")
        
        cartTableView.delegate = self
        cartTableView.dataSource = self
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        changeViewComponent()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        refreshAllComponent()
        cartTableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        temporyAddCartList()
        //Updated Cart list in the home view controller using Protocol(CartListDelegate)
        delegate?.updateCartList(cartList)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let y = targetContentOffset.pointee.y
        print(y)
        if (cartTableView.frame.height < (CGFloat(cartList.count) * 65.0)) && y > 0.0 {
            navigationViewMovedUp()
        } else {
            navigationViewMovedDown()
        }
    }
    private func changeViewComponent(){
        backgroundImageView.layer.opacity = Float(72)
        backgroundImageView.alpha = 0.7
        navigationView.layer.masksToBounds = true
        navigationView.layer.cornerRadius = 30.0
        navigationView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        separetarView.layer.cornerRadius = separetarView.frame.height / 2
        separetarView.layer.borderWidth = 1
        separetarView.layer.borderColor = UIColor(named: "SeparetorBorder_Color")!.cgColor
        cartTableView.layer.opacity = Float(70)
        cartTableView.alpha = 0.7
        priceBackgroundView.layer.cornerRadius = priceBackgroundView.frame.height / 2
        proceedButton.layer.cornerRadius = proceedButton.frame.height / 2
    }
    
    private func refreshAllComponent(){
        //set cart count to label
        cartCountLabel.text = "\(cartList.count)"
        
        var totalPrice : Double = 0.0
        
        for product in cartList {
            totalPrice += (product.productPrice * Double(product.productQty))
        }
        
        self.totalAmountLabel.text = String(totalPrice).convertDoubleToCurrency()
        
        if cartList.isEmpty {
            setEmptyCartImage()
            cartTableView.layer.opacity = Float(100)
        } else {
            emptyCartView.removeFromSuperview()
        }
    }
    
    private func temporyAddCartList(){
        
        let encode = PropertyListEncoder()
        do {
            let encodeList = try encode.encode(cartList)
            try encodeList.write(to: dataFilePath!)
        } catch {
            print("Error encoding cart list \(error)")
        }
    }
    
    @objc private func updateProductRow(_ sender : UIButton){
        
        var product = cartList[sender.tag] as Product
        var currentQty : Int = product.productQty
        
        if let identifier = sender.restorationIdentifier, identifier.elementsEqual("PLUS") {
            currentQty += 1
        } else {
            if 1 < currentQty {
                currentQty -= 1
            }
        }
       
        product.productQty = currentQty
        self.cartList[sender.tag] = product
        cartTableView.reloadData()
        refreshAllComponent()
    }
    
    private func navigationViewMovedUp(){
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: { [weak self] in
            guard let strongeSelf = self else { return }
            strongeSelf.navigationViewTopConstraint.constant = -83
            strongeSelf.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    private func navigationViewMovedDown(){
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: { [weak self] in
            guard let strongeSelf = self else { return }
            strongeSelf.navigationViewTopConstraint.constant = 0
            strongeSelf.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    private func setEmptyCartImage(){
        
        cartTableView.addSubview(emptyCartView)
        
        let emptyCartViewConstraint : [NSLayoutConstraint] = [
            //Image View Constrraint
            emptyCartView.widthAnchor.constraint(equalToConstant: 250.0),
            emptyCartView.heightAnchor.constraint(equalToConstant: 250.0),
            emptyCartView.centerYAnchor.constraint(equalTo: cartTableView.centerYAnchor),
            emptyCartView.centerXAnchor.constraint(equalTo: cartTableView.centerXAnchor),
            //Label Constraint
            emptyCartTitle.widthAnchor.constraint(greaterThanOrEqualToConstant: 100.0),
            emptyCartTitle.heightAnchor.constraint(greaterThanOrEqualToConstant: 15.0),
            emptyCartTitle.topAnchor.constraint(equalTo: emptyCartView.bottomAnchor, constant: 0.0),
            emptyCartTitle.centerXAnchor.constraint(equalTo: emptyCartView.centerXAnchor)
        ]
        
        cartTableView.addConstraints(emptyCartViewConstraint)
        
    }
}

extension CartViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if cartList.count == 0{
            return 0.0
        } else {
            return 2.5
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if cartList.count == 0{
            return 0.0
        } else {
            return 2.5
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            cartList.remove(at: indexPath.row)
            refreshAllComponent()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

extension CartViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cartRowCell = cartTableView.dequeueReusableCell(withIdentifier: "CART_ROW_CELL") as! CartRowViewCell
        cartRowCell.getRowDetail = cartList[indexPath.row] as Product
        cartRowCell.pulsButton.tag = indexPath.row
        cartRowCell.minusButton.tag = indexPath.row
        cartRowCell.pulsButton.addTarget(self, action: #selector(updateProductRow), for: .touchUpInside)
        cartRowCell.minusButton.addTarget(self, action: #selector(updateProductRow), for: .touchUpInside)
        return cartRowCell
    }
    
}
