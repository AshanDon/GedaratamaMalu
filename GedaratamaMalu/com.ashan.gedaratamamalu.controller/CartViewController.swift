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

enum CartViewAlertType {
    case EmptyCart
    case NotEnoughQty
    case ApplicationError
    case NotEnoughQtyForCheckout
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
    
    
    fileprivate var cartList : [Product] = [Product]()
    fileprivate var dataFilePath = FileManager.default.urls(for: .documentDirectory, in:.userDomainMask).first?.appendingPathComponent("TemparyCartList.plist")
    fileprivate var productVM : ProductViewModel!
    fileprivate var getAvailableStock : Int = 0
    
    public weak var delegate : CartListDelegate?
    public var setCartList : [Product]!{
        didSet{
            guard let list = setCartList else { return }
            self.cartList = list
        }
    }
    
    fileprivate lazy var backgroundBlackView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        view.addSubview(errorAletView)
        return view
    }()
    
    fileprivate lazy var errorAletView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "White_Color")
        view.layer.cornerRadius = CGFloat(20)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(errorImageView)
        view.addSubview(errorMessageLabel)
        view.addSubview(errorButton)
        return view
    }()
    
    fileprivate lazy var errorImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    fileprivate lazy var errorMessageLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor(named: "Black_Color")
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate lazy var errorButton : UIButton = {
        let button = UIButton()
        button.titleLabel?.textAlignment = .center
        button.setTitle("", for: .normal)
        button.titleLabel?.attributedText = NSAttributedString(string: "", attributes: [
                                                                NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 21)])
        button.titleLabel?.tintColor = UIColor(named: "White_Color")
        button.backgroundColor = UIColor(named: "Intraduction_Background")
        button.layer.cornerRadius = 18
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(errorButtonDidPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cartTableView.register(UINib(nibName: "CartRowViewCell", bundle: nil), forCellReuseIdentifier: "CART_ROW_CELL")
        
        cartTableView.delegate = self
        cartTableView.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(temporyAddCartList), name: UIApplication.willResignActiveNotification, object: nil)
        
        let jwt_Token = UserDefaults.standard.object(forKey: "JWT_TOKEN") as! String
        
        productVM = ProductViewModel(jwt_Token)
        productVM.delegate = self
        cartTableView.allowsSelection = true
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
            let qty = product.qty ?? 0
            if let price = product.unitprice{
                totalPrice += (price * Double(qty))
            }
            
        }
        
        self.totalAmountLabel.text = String(totalPrice).convertDoubleToCurrency()
    }
    
    @objc fileprivate func temporyAddCartList(){
        
        let encode = PropertyListEncoder()
        do {
            let encodeList = try encode.encode(cartList)
            try encodeList.write(to: dataFilePath!)
        } catch {
            setupBlackView(AlertType: .ApplicationError)
        }
    }
    
    @objc private func updateProductRow(_ sender : UIButton){
        
        var currentQty = (cartList[sender.tag] as Product).qty ?? 0
        
        if let identifier = sender.restorationIdentifier, identifier.elementsEqual("PLUS") {
            if currentQty < getAvailableStock{
                currentQty += 1
            } else {
                setupBlackView(AlertType: .NotEnoughQty)
            }
            
        } else {
            if 0 < currentQty {
                currentQty -= 1
            }
        }
       
        (self.cartList[sender.tag]).qty = currentQty
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
    
    fileprivate func showQtyErrorAlert(_ message : String){
        
        let alertController = UIAlertController(title: "Warning", message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .cancel) { _ in
            alertController.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func checkoutDidPressed(_ sender: Any) {
        if cartList.isEmpty {
            setupBlackView(AlertType: .EmptyCart)
        } else {
            var index = 0
            
            for cartItem in cartList {
                if (cartItem.qty ?? 0) == 0{
                    setupBlackView(AlertType: .NotEnoughQtyForCheckout)
                    index += 1
                }
            }
            
            if index == 0 {
                presentBasketView()
            }
        }
    }
    
    fileprivate func setupBlackView(AlertType : CartViewAlertType){
       
        guard let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else { return }
        
        backgroundBlackView.frame = window.frame
        
        view.addSubview(backgroundBlackView)
        
        switch AlertType{
        
        case .EmptyCart:
            errorImageView.image = UIImage(named: "Warning_Icon")
        
            errorMessageLabel.attributedText = NSAttributedString(string: "You'r cart is Empty", attributes: [
                                                    NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 24)])
        
            errorButton.setTitle("Add Product", for: .normal)
        
        case .NotEnoughQty:
            errorImageView.image = UIImage(named: "Warning_Icon")
        
            errorMessageLabel.attributedText = NSAttributedString(string: "Not enough qty in selected product", attributes: [
                                                    NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18)])
        
            errorButton.setTitle("Ok", for: .normal)
            
        case .ApplicationError:
            errorImageView.image = UIImage(named: "Warning_Icon")
        
            errorMessageLabel.attributedText = NSAttributedString(string: "System Error", attributes: [
                                                    NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 24)])
        
            errorButton.setTitle("Relaunch Application", for: .normal)
            
        
        case .NotEnoughQtyForCheckout:
            errorImageView.image = UIImage(named: "Warning_Icon")
        
            errorMessageLabel.attributedText = NSAttributedString(string: "Can't process your order because order qty is 0", attributes: [
                                                    NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18)])
        
            errorButton.setTitle("Change Qty", for: .normal)
        }
        
        
        addedConstraintToBlackView()
        
        
    }
    
    fileprivate func addedConstraintToBlackView(){
        NSLayoutConstraint.activate([
            //errorAletView layout constraint
            errorAletView.widthAnchor.constraint(equalToConstant: 260),
            errorAletView.heightAnchor.constraint(greaterThanOrEqualToConstant: 283),
            errorAletView.centerXAnchor.constraint(equalTo: backgroundBlackView.centerXAnchor),
            errorAletView.centerYAnchor.constraint(equalTo: backgroundBlackView.centerYAnchor),
            
            //errorImageView layout constraint
            errorImageView.widthAnchor.constraint(equalToConstant: 200),
            errorImageView.heightAnchor.constraint(equalToConstant: 163),
            errorImageView.topAnchor.constraint(equalTo: errorAletView.topAnchor, constant: 20),
            errorImageView.centerXAnchor.constraint(equalTo: errorAletView.centerXAnchor),
            
            //errorMessageLabel layout constraint
            errorMessageLabel.widthAnchor.constraint(equalToConstant: 236),
            errorMessageLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 33),
            errorMessageLabel.topAnchor.constraint(equalTo: errorImageView.bottomAnchor, constant: 5),
            errorMessageLabel.centerXAnchor.constraint(equalTo: errorAletView.centerXAnchor),
            
            //errorButton layout constraint
            errorButton.widthAnchor.constraint(lessThanOrEqualToConstant: 192),
            errorButton.heightAnchor.constraint(equalToConstant: 36),
            errorButton.topAnchor.constraint(equalTo: errorMessageLabel.bottomAnchor, constant: 13),
            errorButton.leftAnchor.constraint(equalTo: errorAletView.leftAnchor, constant: 34),
            errorButton.bottomAnchor.constraint(equalTo: errorAletView.bottomAnchor, constant: -13),
            errorButton.rightAnchor.constraint(equalTo: errorAletView.rightAnchor, constant: -34)
        ])
    }
    
    @objc fileprivate func errorButtonDidPressed(_ button : UIButton){
        
        guard let currentTitle = button.currentTitle else { return }
        
        backgroundBlackView.removeFromSuperview()
        
        switch currentTitle {
        case "Add Product":
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                let tabbar: UITabBarController? = (UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TAB_BAR_SCREEN") as? UITabBarController)
                
                let transition = CATransition()
                transition.duration = 0.7
                transition.type = .push
                transition.subtype = .fromRight
                transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
                self.view.window!.layer.add(transition, forKey: kCATransition)
                
                self.navigationController?.pushViewController(tabbar!, animated: false)
            }
            break
            
        case "Ok": break
        
        case "Relaunch Application": break
            
        case "Change Qty": break
    
        default:
            break
        }
    }
    
    fileprivate func presentBasketView(){
        
        let basketView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "Basket_View") as! BasketViewController
        
        basketView.cartList = cartList
        basketView.modalPresentationStyle = .fullScreen
        
        let transition = CATransition()
        transition.duration = 0.7
        transition.type = .moveIn
        transition.subtype = .fromTop
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        self.view.window!.layer.add(transition, forKey: kCATransition)
        
        self.present(basketView, animated: true, completion: nil)
        
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
        productVM.getStockByProductId((cartList[indexPath.row] as Product).id!)
        cartRowCell.pulsButton.tag = indexPath.row
        cartRowCell.minusButton.tag = indexPath.row
        cartRowCell.pulsButton.addTarget(self, action: #selector(updateProductRow), for: .touchUpInside)
        cartRowCell.minusButton.addTarget(self, action: #selector(updateProductRow), for: .touchUpInside)
        return cartRowCell
    }
    
}

extension CartViewController : ProductDelegate {
    func getAvailableProductStock(_ qty: Int) {
        self.getAvailableStock = qty
    }
}
