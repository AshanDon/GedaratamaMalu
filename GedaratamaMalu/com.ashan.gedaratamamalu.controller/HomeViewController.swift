//
//  HomeViewController.swift
//  GedaratamaMalu
//
//  Created by Ashan Don on 1/13/21.
//

import UIKit
import NVActivityIndicatorView

class HomeViewController: UIViewController {

    @IBOutlet weak var backgroundView: UIImageView!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var separetorView: UIView!
    @IBOutlet weak var cartProductCount: UILabel!
    @IBOutlet weak var productSearchField: UISearchBar!
    @IBOutlet weak var productView: UICollectionView!
    @IBOutlet weak var notifiBackgroundView: UIView!
    
    @IBOutlet weak var navigationViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var separetorTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var middleViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var notifiViewTopConstraint: NSLayoutConstraint!
    
    fileprivate var productList : [Product] = [Product]()
    fileprivate var cartList : [Int:Product] = [Int:Product]()
    
    fileprivate var notifiMoveUpAnimation : UIViewPropertyAnimator!
    fileprivate var dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("TemparyCartList.plist")
    
    fileprivate var productVM : ProductViewModel!
    fileprivate var refreshController : UIRefreshControl!
    fileprivate var activityIndicatorView : NVActivityIndicatorView!
    
    
    fileprivate lazy var touchView : UIView = {
       
        let tView = UIView()
        
        tView.isUserInteractionEnabled = true
        tView.frame = view.bounds
        let viewTGR = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tView.addGestureRecognizer(viewTGR)
        
        return tView
        
    }()
    
    fileprivate lazy var backgroundBlackView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        return view
    }()
    
    fileprivate lazy var errorAletView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "White_Color")
        view.layer.cornerRadius = CGFloat(20)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    fileprivate lazy var errorImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Warning_Icon")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    fileprivate lazy var errorMessageLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor(named: "Black_Color")
        label.numberOfLines = 0
        label.attributedText = NSAttributedString(string: "Product not found!", attributes: [
                                                    NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 24)])
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate lazy var errorButton : UIButton = {
        let button = UIButton()
        button.titleLabel?.textAlignment = .center
        button.setTitle("Try again", for: .normal)
        button.titleLabel?.attributedText = NSAttributedString(string: "Try again", attributes: [
                                                                NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 21)])
        button.titleLabel?.tintColor = UIColor(named: "White_Color")
        button.backgroundColor = UIColor(named: "Intraduction_Background")
        button.layer.cornerRadius = 18
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(errorButtonDidPressed), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        modifiyViewComponent()
        
        self.productView.register(UINib(nibName: "ProductViewCell", bundle: nil), forCellWithReuseIdentifier: "PRODUCT_CELL")
        
        productView.delegate = self
        
        productView.dataSource = self
        
        let jwt_Key = UserDefaults.standard.object(forKey: "JWT_TOKEN") as! String
        
        productVM = ProductViewModel(jwt_Key)
        productVM.delegate = self
        
        loadProductList()
        
        productSearchField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(writeTemporyCartList), name: UIApplication.willResignActiveNotification, object: nil)
        
        setupRefreshController()
    }
    
    internal func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {

        let y = targetContentOffset.pointee.y

        if y > 0.0 {
            topViewMoveUP()
        } else {
            topViewMoveDown()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Pendding cart item count
        getPenddingCartItem()
        
        registerForKeyboardEvent()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        disappearFromKeyboardEvent()
        writeTemporyCartList()
        setDataCartVC()
    }
    
    fileprivate func modifiyViewComponent(){
        
        view.layer.opacity = Float(72)
        
        view.alpha = 0.7
        
        backgroundView.layer.opacity = Float(72)
        
        backgroundView.alpha = 0.7
        
        navigationView.layer.masksToBounds = true
        
        navigationView.layer.cornerRadius = 30.0
        
        navigationView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
        separetorView.layer.cornerRadius = separetorView.frame.height / 2
        
        separetorView.layer.borderWidth = 1
        
        separetorView.layer.borderColor = UIColor(named: "SeparetorBorder_Color")!.cgColor
        
        productSearchField.searchBarStyle = .minimal
        
        productSearchField.searchTextField.backgroundColor = UIColor(named: "NavigationView_Background_Color")!
        
        productView.backgroundColor = .none
        
        notifiBackgroundView.layer.cornerRadius = notifiBackgroundView.frame.height / 2
        notifiBackgroundView.layer.borderColor = UIColor(named: "White_Color")!.cgColor
        notifiBackgroundView.layer.borderWidth = 1
    }

    fileprivate func loadProductList(){
        productVM.getAllProductDetails()
    }
    
    
    fileprivate func topViewMoveUP(){
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: { [weak self] in
            
            guard let strongeSelf = self else { return }
            guard let statusBarHeight = strongeSelf.view.window?.windowScene?.statusBarManager?.statusBarFrame.height else { return }
            strongeSelf.navigationViewTopConstraint.constant = -(strongeSelf.navigationView.frame.height + statusBarHeight)
            strongeSelf.separetorTopConstraint.constant = statusBarHeight + 10
            strongeSelf.middleViewTopConstraint.constant = 5
            
            strongeSelf.view.layoutIfNeeded()
            
        }, completion: nil)
        
    }
    
    fileprivate func topViewMoveDown(){
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: { [weak self] in
            
            guard let strongeSelf = self else { return }
            strongeSelf.navigationViewTopConstraint.constant = 0
            strongeSelf.separetorTopConstraint.constant = 10
            strongeSelf.middleViewTopConstraint.constant = 0
            strongeSelf.view.layoutIfNeeded()
            
        }, completion: nil)
        
    }
    
    fileprivate func registerForKeyboardEvent(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    fileprivate func disappearFromKeyboardEvent(){
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    @objc fileprivate func keyboardWillShow(){
        view.addSubview(touchView)
    }
    
    @objc fileprivate func keyboardWillHide(){
        touchView.removeFromSuperview()
    }
    
    @objc fileprivate func dismissKeyboard(){
        view.endEditing(true)
    }
    
    @objc private func addToCartButtonDidPressed(sender : UIButton){
        
        let requestProduct = self.productList[sender.tag] as Product
        
        addedItemToCart(requestProduct)
       
    }
    
    fileprivate func moveDownNotification(){
        
        UIView.animate(withDuration: 1.5, delay: 0.5, options: .curveEaseInOut) { [weak self] in
            guard let strongeSelf = self else { return }
            strongeSelf.notifiViewTopConstraint.constant = 15.0
            strongeSelf.view.layoutIfNeeded()
        } completion: { (success) in
            
            self.moveUpNotification()
            self.notifiMoveUpAnimation.startAnimation()
            
        }
        
    }
    
    fileprivate func moveUpNotification(){
        
        notifiMoveUpAnimation = UIViewPropertyAnimator(duration: 1.5, curve: .easeInOut, animations: { [weak self] in
            guard let strongeSelf = self else { return }
            strongeSelf.notifiViewTopConstraint.constant = -30.0
            strongeSelf.view.layoutIfNeeded()
        })

    }
    
    fileprivate func getPenddingCartItem(){
        
        if let data = try? Data(contentsOf: dataFilePath!){
            let decode = PropertyListDecoder()
            
            do {
                let getCartList = try decode.decode([Product].self, from: data)
                for cartItem in getCartList {
                    cartList[cartItem.id!] = cartItem
                }
                cartProductCount.text = "\(cartList.count)"
            } catch {
                print("Error decoding cart list \(error)")
            }
        }
    }
    
    fileprivate func setDataCartVC(){
        guard let viewControllers = tabBarController?.viewControllers else { return }
        guard let cartVC = viewControllers[1] as? CartViewController else { return }
        
        var cartData = [Product]()
        
        for cartItem in cartList {
            cartData.append(cartItem.value)
        }
        
        cartVC.setCartList = cartData
        cartVC.delegate = self
    }
    
    @objc fileprivate func writeTemporyCartList(){
        let encoder = PropertyListEncoder()

        do {
            var temporyList = [Product]()
            
            for cartProduct in cartList {
                temporyList.append(cartProduct.value)
            }
            
            let data = try encoder.encode(temporyList)
            try data.write(to: dataFilePath!)


        } catch {
            print("Error encoding cart list \(error)")
        }
    }
    
    fileprivate func setupRefreshController(){
    
        refreshController = UIRefreshControl(frame: CGRect(x: 0, y: 0, width: productView.frame.width, height: 50));
        refreshController.tintColor = .clear
        refreshController.backgroundColor = .clear
        refreshController.addTarget(self, action: #selector(refreshContent), for: .valueChanged)
        
        activityIndicatorView = NVActivityIndicatorView(frame: .zero, type: .lineScaleParty, color: UIColor(named: "Button_Background_Color"), padding: 0)
        
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        
        refreshController.addSubview(activityIndicatorView)
        
        NSLayoutConstraint.activate([
            activityIndicatorView.widthAnchor.constraint(equalToConstant: 100),
            activityIndicatorView.heightAnchor.constraint(equalToConstant: 50),
            activityIndicatorView.centerXAnchor.constraint(equalTo: refreshController.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: refreshController.centerYAnchor)
        ])
        
        productView.refreshControl = refreshController
    }
    
    @objc fileprivate func refreshContent(){
        activityIndicatorView.startAnimating()
        self.perform(#selector(finishdRefreshing), with: nil, afterDelay: 3.0)
        loadProductList()
    }
    
    @objc fileprivate func finishdRefreshing(){
        refreshController.endRefreshing()
        activityIndicatorView.stopAnimating()
    }
    
    fileprivate func setupBlackView(warningImage : UIImage,messageTitle : String){
        
        guard let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else { return }
        
        backgroundBlackView.frame = window.frame
        
        window.addSubview(backgroundBlackView)
        
        errorImageView.image = warningImage
        errorMessageLabel.text = messageTitle
        
        backgroundBlackView.addSubview(errorAletView)
        errorAletView.addSubview(errorImageView)
        errorAletView.addSubview(errorMessageLabel)
        errorAletView.addSubview(errorButton)
        
        setupLayoutConstraint()
    }
    
    fileprivate func setupLayoutConstraint(){
        NSLayoutConstraint.activate([
            //errorAletView layout constraint
            errorAletView.widthAnchor.constraint(equalToConstant: 260),
            errorAletView.heightAnchor.constraint(equalToConstant: 283),
            errorAletView.centerXAnchor.constraint(equalTo: backgroundBlackView.centerXAnchor),
            errorAletView.centerYAnchor.constraint(equalTo: backgroundBlackView.centerYAnchor),
            
            //errorImageView layout constraint
            errorImageView.widthAnchor.constraint(equalToConstant: 200),
            errorImageView.heightAnchor.constraint(equalToConstant: 163),
            errorImageView.topAnchor.constraint(equalTo: errorAletView.topAnchor, constant: 20),
            errorImageView.centerXAnchor.constraint(equalTo: errorAletView.centerXAnchor),
            
            //errorMessageLabel layout constraint
            errorMessageLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 33),
            errorMessageLabel.widthAnchor.constraint(equalToConstant: 236),
            errorMessageLabel.topAnchor.constraint(equalTo: errorImageView.bottomAnchor, constant: 5),
            errorMessageLabel.centerXAnchor.constraint(equalTo: errorAletView.centerXAnchor),
            
            //errorButton layout constraint
            errorButton.widthAnchor.constraint(equalToConstant: 192),
            errorButton.heightAnchor.constraint(equalToConstant: 36),
            errorButton.topAnchor.constraint(equalTo: errorMessageLabel.bottomAnchor, constant: 13),
            errorButton.bottomAnchor.constraint(lessThanOrEqualTo: errorAletView.bottomAnchor, constant: 13),
            errorButton.centerXAnchor.constraint(equalTo: errorAletView.centerXAnchor)
        ])
    }
    
    @objc fileprivate func errorButtonDidPressed(){
        backgroundBlackView.removeFromSuperview()
        productSearchField.text = ""
    }
}

extension HomeViewController : UICollectionViewDelegate,UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let productCell = productView.dequeueReusableCell(withReuseIdentifier: "PRODUCT_CELL", for: indexPath) as! ProductViewCell
        productCell.product = productList[indexPath.row] as Product
        productCell.addCartButton.tag = indexPath.row
        productCell.addCartButton.addTarget(self, action: #selector(addToCartButtonDidPressed), for: .touchUpInside)
        
        
        return productCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let productVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "VIEW_PRODUCT") as! ProductViewController
        productVC.modalTransitionStyle = .crossDissolve
        productVC.modalPresentationStyle = .formSheet
        productVC.getProductDetails = productList[indexPath.row] as Product
        productVC.cartDelegate = self
        present(productVC, animated: true, completion: nil)
    }
}

extension HomeViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (productView.frame.width - 15) / 2, height: 290)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(5.0)
    }
}

extension HomeViewController : UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        if let name = searchBar.text {
            self.view.endEditing(true)
            productVM.productAdvanceSearch(name)
        }
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.clearsContextBeforeDrawing = true
        productVM.getAllProductDetails()
        return true
    }
    
}

extension HomeViewController : CartDelegete {
    
    func addedItemToCart(_ item: Product) {
        if cartList.count == 0 {
            self.cartList = [item.id!:item]
            moveDownNotification()
            self.cartProductCount.text = "\(Int(cartList.count))"
        } else {
            
            let _ = cartList.filter { (result) -> Bool in
                
                let key = result.key
                
                if let getId = item.id, key == getId {
                    self.setupBlackView(warningImage: UIImage(named: "Warning_Icon")!, messageTitle: "Alredy Added")
                    return false
                } else {
                    self.cartList[item.id!] = item
                    self.moveDownNotification()
                    self.cartProductCount.text = "\(Int(cartList.count))"
                    return true
                }
            }
        }
    }
    
}

extension HomeViewController : CartListDelegate {
    
    func updateCartList(_ list: [Product]) {
        if list.count > 0 {
            for product in list {
                self.cartList[product.id!] = product
            }
        } else {
            self.cartList.removeAll()
        }
        self.cartProductCount.text = "\(cartList.count)"
    }
}

extension HomeViewController : ProductDelegate {
    
    func getProductList(productList: [AnyObject]) {
        if !productList.isEmpty{
            self.productList = productList as! [Product]
        } else if productList.isEmpty && !productSearchField.text!.isEmpty {
            setupBlackView(warningImage: UIImage(named: "NotFound")!, messageTitle: "Product not found!")
        }
        productView.reloadData()
    }
}
