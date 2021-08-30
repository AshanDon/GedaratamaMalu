//
//  OrderConfirmationViewController.swift
//  GedaratamaMalu
//
//  Created by Ashan Don on 8/14/21.
//

import UIKit
import MapKit

class OrderConfirmationViewController: UIViewController {

    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var progressBackgroundView: UIView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var companyBackgroundView: UIView!
    @IBOutlet weak var userBackgroundView: UIView!
    @IBOutlet weak var userAddressLabel: UILabel!
    @IBOutlet weak var userContactLabel: UILabel!
    @IBOutlet weak var orderInfoBackgroundView: UIView!
    @IBOutlet weak var myCartTable: UITableView!
    @IBOutlet weak var orderButton: UIButton!
    @IBOutlet weak var gifImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var orderNumberLabel: UILabel!
    @IBOutlet weak var orderAmountLabel: UILabel!
    @IBOutlet weak var paymentTypeLabel: UILabel!
    @IBOutlet weak var timeRemainingLabel: UILabel!
    @IBOutlet weak var orderRemainingLabel: UILabel!
    
    @IBOutlet weak var myCartTableHeight: NSLayoutConstraint!
    @IBOutlet weak var viewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var homeButtonHeightConstraint: NSLayoutConstraint!
    
    fileprivate var orderMV : OrderModelView!
    fileprivate var paymentMV : PaymentModelView!
    fileprivate var orderDetailsList : [OrderDetails] = [OrderDetails]()
    fileprivate var timer = Timer()
    var progressCount : Int = 0
    fileprivate let orderConformTime : Int = 5
    fileprivate let orderPreparationTime : Int = 15
    
    var timeRemaining : Int = 45
    var orderId : Int?
    
    
    // Left Button in navigation bar
    fileprivate lazy var leftButton : UIButton = {
        let button = UIButton()
        button.setTitle(" Back", for: .normal)
        button.setImage(UIImage(named: "Arrow_Icon"), for: .normal)
        button.setTitleColor(UIColor(named: "Black_Color"), for: .normal)
        button.addTarget(self, action: #selector(backButtonDidPressed), for: .touchUpInside)
        return button
    }()
    
    // Right Button in navigation bar
    fileprivate lazy var helpButton : UIButton = {
        let button = UIButton()
        button.setTitle("Help", for: .normal)
        button.setTitleColor(UIColor(named: "Black_Color"), for: .normal)
        button.addTarget(self, action: #selector(helpButtonDidPressed), for: .touchUpInside)
        return button
    }()
    
    //MARK:- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MyCartViewCell added to myCartTable
        myCartTable.register(UINib(nibName: "MyCartViewCell", bundle: nil), forCellReuseIdentifier: "MyCartCell")
        
        myCartTable.dataSource = self
        myCartTable.delegate = self
        
        //get jwt token
        let jwtToken : String = UserDefaults.standard.object(forKey: "JWT_TOKEN") as! String
        
        orderMV = OrderModelView(JwtToken: jwtToken)
        paymentMV = PaymentModelView(JwtToken: jwtToken)
        
        //Delegate
        orderMV.delegate = self
        paymentMV.paymentDelegate = self
        
        if let orderID = orderId {
            orderMV.getOrderInfoById(orderID)
            orderMV.getOrderDetailsByOID(OrderID: orderID)
            paymentMV.getPaymentTypeByOrderId(OrderId: orderID)
        }
        
        //setup progressTimer
        timer = Timer.scheduledTimer(timeInterval: 60, target: self,selector: #selector(timerRunning), userInfo: nil, repeats: true)
    }
    
    //MARK:- viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupLayout()
        
        progressView.progress =  Float(progressCount) / Float(45)
        timeRemainingLabel.text = "within \(timeRemaining) mins"
        
        if progressCount < orderConformTime {
            gifImageView.image = UIImage.gifImageWithName("guidelines")
            orderRemainingLabel.text = "Your order has been received."
        } else if orderConformTime < progressCount && progressCount <= orderPreparationTime { // 15
            gifImageView.image = UIImage.gifImageWithName("fish3")
            orderRemainingLabel.text = "Preparing your order"
        } else if (orderConformTime + orderPreparationTime) < progressCount{
            gifImageView.image = UIImage.gifImageWithName("scooter-courier")
            orderRemainingLabel.text = "Get ready! Your order is on its way!!!"
        }
    }
    
    deinit {
        timer.invalidate()
    }
    
    fileprivate func setupLayout(){
        
        //Navigation Bar
        let navigationItem = UINavigationItem(title: "Order Confirmation")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: helpButton)
        
        navigationBar.setItems([navigationItem], animated: false)
        
        UINavigationBar.appearance().barTintColor = UIColor(named: "White_Color")
        UINavigationBar.appearance().titleTextAttributes = [
            NSAttributedString.Key.foregroundColor : UIColor(named: "TabBar_Tint_Color")!,
            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 21)
        ]
        
        //Map View
        mapView.layer.opacity = Float(0.5)
        
        //Progress Background View
        progressBackgroundView.layer.cornerRadius = CGFloat(18)
        progressBackgroundView.layer.borderWidth = 2
        progressBackgroundView.layer.borderColor = UIColor(named: "LightBlack_Color-1")!.cgColor
        
        //Progress View
        progressView.layer.cornerRadius = CGFloat(18)
        progressView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        progressView.clipsToBounds = true
        
        let gradientImage = UIImage.gradientImage(with: progressView.frame,
                                                  colors: [UIColor(named: "ProgressGreadiantColor-1")!.cgColor,
                                                           UIColor(named: "ProgressGreadiantColor-2")!.cgColor],
                                                locations: nil)
        progressView.progressImage = gradientImage!
        progressView.progress = 0
        
        //companyBackgroundView
        companyBackgroundView.layer.cornerRadius = CGFloat(18)
        companyBackgroundView.layer.borderWidth = 2
        companyBackgroundView.layer.borderColor = UIColor(named: "LightBlack_Color-1")!.cgColor
        
        //userBackgroundView
        userBackgroundView.layer.cornerRadius = CGFloat(18)
        userBackgroundView.layer.borderWidth = 2
        userBackgroundView.layer.borderColor = UIColor(named: "LightBlack_Color-1")!.cgColor
        userAddressLabel.layer.opacity = Float(0.6)
        userContactLabel.layer.opacity = Float(0.6)
        
        //orderInfoBackgroundView
        orderInfoBackgroundView.layer.cornerRadius = CGFloat(18)
        orderInfoBackgroundView.layer.borderWidth = 2
        orderInfoBackgroundView.layer.borderColor = UIColor(named: "LightBlack_Color-1")!.cgColor
        
        //orderButton
        orderButton.layer.cornerRadius = CGFloat(12)
        
    }
    
    @objc fileprivate func helpButtonDidPressed(){
        print("present help view...")
    }
    
    @objc fileprivate func backButtonDidPressed(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func homeButtonDidPresse(_ sender: Any) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            let tabbar: UITabBarController? = (UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TAB_BAR_SCREEN") as? UITabBarController)
            
            let transition = CATransition()
            transition.duration = 0.7
            transition.type = .push
            transition.subtype = .fromRight
            transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            
            self.view.window!.layer.add(transition, forKey: kCATransition)
            
            guard let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else { return }
            
            self.dismiss(animated: true) {
                window.rootViewController = tabbar
            }
            
        }
    }
    
    @objc fileprivate func timerRunning() {
        if timeRemaining != 0 {
            timeRemaining -= 1
            progressCount += 1
            progressView.progress =  Float(progressCount) / Float(45)
            timeRemainingLabel.text = "within \(timeRemaining) mins"
            
               
            if progressCount < orderConformTime {
                gifImageView.image = UIImage.gifImageWithName("guidelines")
                orderRemainingLabel.text = "Your order has been received."
            } else if orderConformTime < progressCount && progressCount <= orderPreparationTime { // 15
                gifImageView.image = UIImage.gifImageWithName("fish3")
                orderRemainingLabel.text = "Preparing your order"
            } else if (orderConformTime + orderPreparationTime) < progressCount{
                gifImageView.image = UIImage.gifImageWithName("scooter-courier")
                orderRemainingLabel.text = "Get ready! Your order is on its way!!!"
            }
        } else {
            timer.invalidate()
            gifImageView.image = UIImage(named: "Pickup_Order_Image")
            timeRemainingLabel.text = "TAKE YOUR ORDER!"
            orderRemainingLabel.text = "Thank you for your order!"
            orderMV.updateActivityStatusByOID(Order_Id: orderId!)
        }
      }
    
    @IBAction func shopPhoneButtonPressed(_ sender: Any) {
        if let url = URL(string: "tel://33766848"),
           UIApplication.shared.canOpenURL(url) {
              if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler:nil)
               } else {
                   UIApplication.shared.openURL(url)
               }
           } else {
                    print("call error..!")
           }
    }

    func setupNavigationBar(){
        let navigationItem = UINavigationItem(title: "Order Confirmation")
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: helpButton)
        
        navigationBar.setItems([navigationItem], animated: false)
    }
    
    func changeLayoutHeight() {
        self.homeButtonHeightConstraint.constant = 0
        self.viewBottomConstraint.constant = 45
        view.layoutIfNeeded()
    }
}

//MARK:- UITableViewDelegate
extension OrderConfirmationViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 34.0
    }
    
    
}

//MARK:- UITableViewDataSource
extension OrderConfirmationViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderDetailsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCartCell = myCartTable.dequeueReusableCell(withIdentifier: "MyCartCell", for: indexPath) as! MyCartViewCell
        let details = orderDetailsList[indexPath.row] as OrderDetails
        myCartCell.cellDetails = details
        return myCartCell
    }
    
    
}

//MARK:- OrderDelegate
extension OrderConfirmationViewController : OrderDelegate {
    func updateActiveStatus(Updated result: Bool) {
        print("Order Activity Status :- \(result)")
    }
    
    func getAllPendingOrders(List list: [Order]) { }
    
    func getOrderDetailInfo(OrderDetails list: [OrderDetails]) {
        
        self.orderDetailsList = list
        
        DispatchQueue.main.async {
            self.myCartTable.reloadData()
            self.myCartTableHeight.constant = CGFloat(34 * list.count)
            self.loadViewIfNeeded()
        }
    }
    
    func showResponseCode(HttpCode code: Int) { }
    
    func getOrderInfo(Order info: Order) {
        //Set user info
        guard let firstName = info.profile.firstName else { return }
        guard let lastName = info.profile.lastName else { return }
        guard let apartmentNo = info.addressDetails.apartmentNo else { return }
        guard let houseNo = info.addressDetails.houseNo else { return }
        guard let city = info.addressDetails.city else { return }
        guard let postalCode = info.addressDetails.postalCode else { return }
        guard let userMobile = info.profile.mobile else { return }
        
        var address : String = ""
        if !apartmentNo.isEmpty{
            address = "\(apartmentNo) \n"
        }
        address += "\(houseNo) \n"
        address += "\(city) \n"
        address += postalCode
        
        userNameLabel.text = "\(firstName) \(lastName)"
        userAddressLabel.text = address
        userContactLabel.text = "Mobile No :- \(userMobile)"
        
        //set my cart info
        orderNumberLabel.text = String(info.id)
    }
}

//MARK:- PaymentDelegate
extension OrderConfirmationViewController : PaymentDelegate {
    
    func getPaymentDetails(_ info: [PaymentDetails]) {
        for details in info {
            let data = details as PaymentDetails
            orderAmountLabel.text = String(data.pay_Amount ?? 0).convertDoubleToCurrency()
            paymentTypeLabel.text = data.payment.paymentType
        }
    }
    
    
}

