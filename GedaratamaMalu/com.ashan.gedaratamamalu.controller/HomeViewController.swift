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
    fileprivate var pendingOrderList : [Order] = [Order]()
    
    fileprivate var notifiMoveUpAnimation : UIViewPropertyAnimator!
    fileprivate var productVM : ProductViewModel!
    fileprivate var refreshController : UIRefreshControl!
    fileprivate var activityIndicatorView : NVActivityIndicatorView!
    fileprivate var clickIndicatorView : NVActivityIndicatorView!
    fileprivate var willAppearIndicatorView : NVActivityIndicatorView!
    fileprivate let userDefaults : UserDefaults = UserDefaults.standard
    fileprivate var orderVM : OrderModelView!
    fileprivate var registerVM : RegisterModelView!
    fileprivate var profile_Id : Int = Int()
    
    
    
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
        self.productView.register(UINib(nibName: "OrderConfirmationViewCell", bundle: nil), forCellWithReuseIdentifier: "ORDER_SUMMERY")
        
        productView.delegate = self
        
        productView.dataSource = self
        
        let jwt_Key = userDefaults.object(forKey: "JWT_TOKEN") as! String
        
        productVM = ProductViewModel(jwt_Key)
        productVM.delegate = self
        
        orderVM = OrderModelView(JwtToken: jwt_Key)
        orderVM.delegate = self
        
        registerVM = RegisterModelView(jwt_Key)
        registerVM.delegate = self
        
        productSearchField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(clearCartList), name: Notification.Name("CLEAR_CART_LIST"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateOrderStatus), name: Notification.Name("RELOAD_PRODUCT_VIEW"), object: nil)
        
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
        
        registerForKeyboardEvent()
    
        getCurrentUserIdByUserName()
        
        setupWillAppearIndicatorView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.5) {
            
            self.loadProductList()
            self.loadPendingOrders()
            self.willAppearIndicatorView.stopAnimating()
            
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        disappearFromKeyboardEvent()
        
        setDataCartVC()
        
        productList.removeAll()
        pendingOrderList.removeAll()
        
        productView.reloadData()
        
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

    @objc fileprivate func clearCartList(){
        cartList.removeAll()
        cartProductCount.text = String(cartList.count)
    }
    
    fileprivate func calculateTimeDifferent(OrderDate date : String) -> Int{
    
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from:date)

        let diffs = Calendar.current.dateComponents([.minute], from: date!, to: Date())
        return diffs.minute!
    }
    
    fileprivate func presentOrderConfirmationVC(TimeRemaining time : Int,Progress count : Int,OrderId id : Int) {
        
        let orderSummeryVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "ORDER_CONFIRMATION") as! OrderConfirmationViewController
        
        orderSummeryVC.modalPresentationStyle = .fullScreen
        
        orderSummeryVC.orderId = id
        orderSummeryVC.timeRemaining = time
        orderSummeryVC.progressCount = count
        
        let transition = CATransition()
        transition.duration = 0.7
        transition.type = .fade
        transition.subtype = .fromLeft
        transition.timingFunction = CAMediaTimingFunction(name: .easeIn)
        self.view.window!.layer.add(transition, forKey: kCATransition)
        
        self.dismiss(animated: true) {
            self.present(orderSummeryVC, animated: false) {
                
                orderSummeryVC.setupNavigationBar()
                orderSummeryVC.orderButton.isHidden = true
                
                orderSummeryVC.changeLayoutHeight()

            }
        }
    }
    
    fileprivate func setupActivityIndicator() {
        
        clickIndicatorView = NVActivityIndicatorView(frame: .zero, type: .lineSpinFadeLoader, color: UIColor(named: "Button_Background_Color"), padding: 0)
        
        clickIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(clickIndicatorView)
        
        NSLayoutConstraint.activate([
            clickIndicatorView.widthAnchor.constraint(equalToConstant: 50),
            clickIndicatorView.heightAnchor.constraint(equalToConstant: 50),
            clickIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            clickIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        clickIndicatorView.startAnimating()
    }
    
    @objc fileprivate func updateOrderStatus(_ notification : Notification){
        let ord_id = notification.object as! Int
        orderVM.updateActivityStatusByOID(Order_Id: ord_id)
    }
    
    fileprivate func getCurrentUserIdByUserName(){
        let userName = userDefaults.object(forKey: "USER_NAME") as! String
        registerVM.getProfileInfoByUserName(UserName: userName)
    }
    
    fileprivate func loadPendingOrders(){
        orderVM.getAllPendingOrderByProfileId(ProfileId: profile_Id)
    }
    
    fileprivate func setupWillAppearIndicatorView(){
        willAppearIndicatorView = NVActivityIndicatorView(frame: .zero, type: .lineSpinFadeLoader, color: UIColor(named: "LightBlack_Color"), padding: 2)
        
        willAppearIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(willAppearIndicatorView)
        
        NSLayoutConstraint.activate([
            willAppearIndicatorView.widthAnchor.constraint(equalToConstant: 50),
            willAppearIndicatorView.heightAnchor.constraint(equalToConstant: 50),
            willAppearIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            willAppearIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        willAppearIndicatorView.startAnimating()
        
    }
}

extension HomeViewController : UICollectionViewDelegate,UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == 0{
            return pendingOrderList.count
        } else {
            return productList.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0{
            let orderSummeryCell = productView.dequeueReusableCell(withReuseIdentifier: "ORDER_SUMMERY", for: indexPath) as! OrderConfirmationViewCell
            let details = pendingOrderList[indexPath.row] as Order
            
            let timeDifferent = calculateTimeDifferent(OrderDate: details.date)
            
            orderSummeryCell.progressCount = timeDifferent
            orderSummeryCell.timeRemaining = (45 - timeDifferent)
            orderSummeryCell.orderId = details.id
            
            return orderSummeryCell
        } else {
            let productCell = productView.dequeueReusableCell(withReuseIdentifier: "PRODUCT_CELL", for: indexPath) as! ProductViewCell
            productCell.product = productList[indexPath.row] as Product
            productCell.addCartButton.tag = indexPath.row
            productCell.addCartButton.addTarget(self, action: #selector(addToCartButtonDidPressed), for: .touchUpInside)
            
            
            return productCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            
            let oCV_Cell = productView.cellForItem(at: indexPath) as! OrderConfirmationViewCell
            let details = pendingOrderList[indexPath.row] as Order
            
            setupActivityIndicator()
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
                self.clickIndicatorView.stopAnimating()
                self.presentOrderConfirmationVC(TimeRemaining: oCV_Cell.timeRemaining, Progress: oCV_Cell.progressCount, OrderId: details.id)
            }
            
            
        } else {
            let productVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "VIEW_PRODUCT") as! ProductViewController
            productVC.modalTransitionStyle = .crossDissolve
            productVC.modalPresentationStyle = .formSheet
            productVC.getProductDetails = productList[indexPath.row] as Product
            productVC.cartDelegate = self
            present(productVC, animated: true, completion: nil)
        }
    }
}

extension HomeViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: (productView.frame.width - 20) , height: 110)
        } else {
            return CGSize(width: (productView.frame.width - 15) / 2, height: 290)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        } else {
            return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if section == 0 {
            return CGFloat(10)
        } else {
            return CGFloat(10)
        }
        
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

extension HomeViewController : RegistrationDelegate {
    func getResponse(_ response: ApiResponse) { }
    
    func getUniqueFieldResult(_ field: String, _ result: Bool) { }
    
    func getProfileInfo(_ profile: Profile?) {
        
        guard let details = profile else { return }
        
        if let pro_Id = details.id {
            self.profile_Id = pro_Id
        }
    }
}

extension HomeViewController : OrderDelegate {
    func updateActiveStatus(Updated result: Bool) {
        DispatchQueue.main.async {
            if result {
                self.loadPendingOrders()
                self.productView.reloadData()
            }
        }
    }
    
    func showResponseCode(HttpCode code: Int) {
        
    }
    
    func getOrderInfo(Order info: Order) { }
    
    func getOrderDetailInfo(OrderDetails list: [OrderDetails]) { }
    
    func getAllPendingOrders(List list: [Order]) {
        self.pendingOrderList = list
        
        DispatchQueue.main.async {
            self.productView.reloadData()
        }
    }
    
    
}
