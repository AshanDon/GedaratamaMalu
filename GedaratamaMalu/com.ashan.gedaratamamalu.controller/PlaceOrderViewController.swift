//
//  PlaceOrdxerViewController.swift
//  GedaratamaMalu
//
//  Created by Ashan Don on 5/26/21.
//

import UIKit
import MapKit
import CreditCardValidator
import NVActivityIndicatorView
import CoreLocation

class PlaceOrderViewController: UIViewController {

    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var customerInfoView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var mapView : MKMapView!
    @IBOutlet weak var deliveryInfoView: UIView!
    @IBOutlet weak var payMethodTable : UITableView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var mobileLabel: UILabel!
    @IBOutlet weak var placeOrderButton: UIButton!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var basketTotal: UILabel!
    @IBOutlet weak var serviceCharge: UILabel!
    @IBOutlet weak var totalAmount: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var payMethodtableHeight: NSLayoutConstraint!
    @IBOutlet weak var bottomViewHeight: NSLayoutConstraint!
    @IBOutlet weak var bottomViewSafeArea: NSLayoutConstraint! // default value = 0
    
    
    fileprivate var creditCardList : [String:CreditCard] = [String:CreditCard]()
    fileprivate var cardTableList : [CreditCard] = [CreditCard]()
    fileprivate var paymentInfoList : [PaymentDetails] = [PaymentDetails]()
    fileprivate var dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("TemparyCardList.plist")
    fileprivate var basketAmount : Double? = Double()
    fileprivate var myAnnotation : MKPointAnnotation = MKPointAnnotation()
    fileprivate let locationManager = CLLocationManager()
    fileprivate var addressMV : AddressModelView!
    fileprivate var registerMV : RegisterModelView!
    fileprivate var orderMV : OrderModelView!
    fileprivate var paymentMV : PaymentModelView!
    fileprivate var profileInfo : Profile!
    fileprivate var addressInfo : AddressDetail!
    fileprivate let showAlertMessage = ShowCustomAlertMessage()
    fileprivate var payCard : CreditCard = CreditCard(cardNumber: "", cardTypeImage: "", expiryDate: "", securityCode: "")
    fileprivate var payType : Payment = Payment(id: 1, type: "Cash", status: true, date: "2021-03-27 03:00:00")
    fileprivate var payStatus : Bool = false
    
    static var buttonArray : [UIButton] = [UIButton]()
    
    var orderList : [Product]!{
        didSet{
            guard let list = orderList else { return }
            
            for product in list {
                basketAmount? += product.unitprice! * Double(product.qty!)
            }
        }
    }
    
    
    
    fileprivate lazy var backButton : UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 44))
        button.setTitle(" Back", for: .normal)
        button.setImage(UIImage(named: "Arrow_Icon"), for: .normal)
        button.setTitleColor(UIColor(named: "Black_Color"), for: .normal)
        button.addTarget(self, action: #selector(backButtonDidPressed), for: .touchUpInside)
        return button
    }()
    
    fileprivate lazy var blackView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        view.isUserInteractionEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dissmissKeyboard)))
        view.addSubview(contentView)
        return view
    }()
    
    fileprivate lazy var contentView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "White_Color")!
        view.layer.masksToBounds = false
        view.layer.cornerRadius = 50
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.isUserInteractionEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(cancelButton)
        view.addSubview(titleLabel)
        view.addSubview(cardNumTextField)
        view.addSubview(expireyTextField)
        view.addSubview(securityCodeTextField)
        view.addSubview(saveInfoLabel)
        view.addSubview(saveCardSwitch)
        view.addSubview(lineLabel1)
        view.addSubview(basketTotalLabel)
        view.addSubview(basketAmountLabel)
        view.addSubview(serviceChargeLabel)
        view.addSubview(serviceChargeAmountLabel)
        view.addSubview(totalAmountLabel)
        view.addSubview(totalPriceLabel)
        view.addSubview(infoLabel)
        view.addSubview(lineLabel2)
        view.addSubview(buttonStackView)

        return view
    }()
    
    fileprivate lazy var cancelButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Close_Icon"), for: .normal)
        button.addTarget(self, action: #selector(dismissContentView), for: .touchUpInside)
        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    fileprivate lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString(string: "Enter Card Details", attributes: [
            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 21),
            NSAttributedString.Key.foregroundColor : UIColor(named: "Black_Color")!
        ])
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate lazy var cardNumTextField : UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "Card number", attributes: [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17),
            NSAttributedString.Key.foregroundColor : UIColor(named: "SeparetorBorder_Color")!
        ])
        textField.textAlignment = .left
        textField.keyboardType = .numberPad
        textField.addDoneButtonOnKeyboard()
        textField.addTarget(self, action: #selector(cardNumFieldValueChanged(_:)), for: .editingChanged)
        
        textField.tag = 0
        
        textField.isUserInteractionEnabled = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        textField.delegate = self
        
        return textField
    }()
    
    fileprivate lazy var expireyTextField : UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "Expiry Date (mm/yy)", attributes: [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17),
            NSAttributedString.Key.foregroundColor : UIColor(named: "SeparetorBorder_Color")!
        ])
        textField.textAlignment = .left
        
        textField.isUserInteractionEnabled = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    fileprivate lazy var securityCodeTextField : UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "Security code", attributes: [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17),
            NSAttributedString.Key.foregroundColor : UIColor(named: "SeparetorBorder_Color")!
        ])
        textField.textAlignment = .left
        textField.keyboardType = .numberPad
          
        textField.addDoneButtonOnKeyboard()
        
        textField.isUserInteractionEnabled = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    fileprivate lazy var  saveInfoLabel : UILabel = {
       let label = UILabel()
        label.textAlignment = .left
        label.attributedText = NSAttributedString(string: "For faster and more secure checkout,save your card details", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16),
             NSAttributedString.Key.foregroundColor : UIColor(named: "Black_Color")!
        ])
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
       return label
    }()
    
    fileprivate lazy var saveCardSwitch : UISwitch = {
        let cardSwitch = UISwitch()
        cardSwitch.onTintColor = UIColor(named: "TabBar_Tint_Color")
        cardSwitch.translatesAutoresizingMaskIntoConstraints = false
        return cardSwitch
    }()
    
    fileprivate lazy var lineLabel1 : UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(named: "CartTableView_Background_Color")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate lazy var basketTotalLabel : UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString(string: "Basket total", attributes: [
            NSAttributedString.Key.foregroundColor : UIColor(named: "Black_Color")!,
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18)
        ])
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate lazy var basketAmountLabel : UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString(string: "රු 4,550.00", attributes: [
            NSAttributedString.Key.foregroundColor : UIColor(named: "Black_Color")!,
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18)
        ])
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate lazy var serviceChargeLabel : UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString(string: "Service Charge", attributes: [
            NSAttributedString.Key.foregroundColor : UIColor(named: "Black_Color")!,
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18)
        ])
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate lazy var serviceChargeAmountLabel : UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString(string: "රු 200.00", attributes: [
            NSAttributedString.Key.foregroundColor : UIColor(named: "Black_Color")!,
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18)
        ])
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate lazy var totalAmountLabel : UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString(string: "Total Amount", attributes: [
            NSAttributedString.Key.foregroundColor : UIColor(named: "Black_Color")!,
            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 21)
        ])
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate lazy var totalPriceLabel : UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString(string: "රු 4,750.00", attributes: [
            NSAttributedString.Key.foregroundColor : UIColor(named: "Black_Color")!,
            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 21)
        ])
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate lazy var  infoLabel : UILabel = {
       let label = UILabel()
        label.textAlignment = .left
        label.attributedText = NSAttributedString(string: "By placing this order you agree to the Creadit Card payment terms & conditions.", attributes: [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16),
            NSAttributedString.Key.foregroundColor : UIColor(named: "Black_Color")!,
        ])
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
       return label
    }()
    
    fileprivate lazy var lineLabel2 : UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(named: "CartTableView_Background_Color")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate lazy var buttonStackView : UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = CGFloat(15)
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.backgroundColor = .clear
        
        stackView.addSubview(cancelViewButton)
        stackView.addSubview(payViewButton)
        return stackView
    }()
    
    fileprivate lazy var cancelViewButton : UIButton = {
        let button = UIButton()
        button.setAttributedTitle(NSAttributedString(string: "Cancel", attributes: [
            NSAttributedString.Key.foregroundColor : UIColor(named: "TabBar_Tint_Color")!,
            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 21)
        ]), for: .normal)
        button.backgroundColor = UIColor(named: "White_Color")
        button.layer.cornerRadius = CGFloat(12)
        button.layer.borderWidth = CGFloat(2)
        button.layer.borderColor = UIColor(named: "TabBar_Tint_Color")!.cgColor
        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(dismissContentView), for: .touchUpInside)
        return button
    }()
    
    fileprivate lazy var payViewButton : UIButton = {
        let button = UIButton()
        button.setAttributedTitle(NSAttributedString(string: "Pay", attributes: [
            NSAttributedString.Key.foregroundColor : UIColor(named: "White_Color")!,
            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 21)
        ]), for: .normal)
        button.backgroundColor = UIColor(named: "TabBar_Tint_Color")
        button.layer.cornerRadius = CGFloat(12)
        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(payButtonDidPressed), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        payMethodTable.register(UINib(nibName: "CheckoutPayViewCell", bundle: nil), forCellReuseIdentifier: "DEFAULT_PAY_CELL")
        payMethodTable.register(UINib(nibName: "CardDetailViewCell", bundle: nil), forCellReuseIdentifier: "CARD_DETAIL_CELL")
        
        
        
        loadTemporyCard()
        
        setPayTableHeight()
        
        setPaymentSummary()
        
        //MARK:- get jwt token from User Defaults
        let jwtToken = UserDefaults.standard.object(forKey: "JWT_TOKEN") as! String
        
        //MARK:- get userName from User Defaults
        let userName = UserDefaults.standard.object(forKey: "USER_NAME") as! String
        
        addressMV = AddressModelView(jwtToken)
        registerMV = RegisterModelView(jwtToken)
        orderMV = OrderModelView(JwtToken: jwtToken)
        paymentMV = PaymentModelView(JwtToken: jwtToken)
        
        //MARK:- delegate
        payMethodTable.delegate = self
        payMethodTable.dataSource = self
        mapView.delegate = self
        registerMV.delegate = self
        addressMV.delegate = self
        orderMV.delegate = self
        paymentMV.delegate = self
        scrollView.delegate = self
        
        registerMV.getProfileInfoByUserName(UserName: userName)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupViewLayout()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        cardNumTextField.setupBottomLine(lineHeight: 1.93, lineColor: UIColor(named: "Line_Color")!)
        expireyTextField.setupBottomLine(lineHeight: 1.93, lineColor: UIColor(named: "Line_Color")!)
        securityCodeTextField.setupBottomLine(lineHeight: 1.93, lineColor: UIColor(named: "Line_Color")!)
    
        securityCodeTextField.setupRightCustomImage(imageName: "CCV_Code_Icon", color: UIColor.clear, width: 50, height: 35)
        
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        expireyTextField.addTarget(self, action: #selector(presentDatePickerView), for: .allTouchEvents)
        
        basketAmountLabel.text = basketTotal.text
        serviceChargeAmountLabel.text = serviceCharge.text
        totalPriceLabel.text = totalAmount.text
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    fileprivate func setupViewLayout(){
        
        let navigationItem = UINavigationItem(title: "Place Order")
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        navigationBar.setItems([navigationItem], animated: false)
        
        UINavigationBar.appearance().barTintColor = UIColor(named: "White_Color")
        UINavigationBar.appearance().titleTextAttributes = [
            NSAttributedString.Key.foregroundColor : UIColor(named: "TabBar_Tint_Color")!,
            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 21)
        ]
        
        //customerInfoView
        customerInfoView.layer.cornerRadius = CGFloat(28)
        customerInfoView.layer.borderWidth = CGFloat(2)
        customerInfoView.layer.borderColor = UIColor(named: "LightBlack_Color-1")!.cgColor
        
        //mapView
        mapView.layer.cornerRadius = CGFloat(28)
        mapView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        //deliveryInfoView
        
        deliveryInfoView.layer.cornerRadius = CGFloat(16)
        deliveryInfoView.layer.borderWidth = CGFloat(2)
        deliveryInfoView.layer.borderColor = UIColor(named: "LightBlack_Color-1")!.cgColor
        
        //address label
        addressLabel.layer.opacity = Float(0.6)
        
        //mobile label
        mobileLabel.layer.opacity = Float(0.6)
        
        //placeOrderButton
        placeOrderButton.layer.cornerRadius = 12
        
        //bottomView
        bottomView.applyViewShadow(color: UIColor(named: "Custom_Black_Color")!, alpha: 1, x: 0, y: -5, blur: 0, spread: 2)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        determineCurrentLocation()
    }
    
    @objc fileprivate func backButtonDidPressed(){
        
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = .push
        transition.subtype = .fromLeft
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        if let window = view.window {
            window.layer.add(transition, forKey: kCATransition)
        }
        
        self.dismiss(animated: false, completion: nil)
    }
    
    @objc fileprivate func cashButtonDidPressed(_ : UIButton){
        payCard = CreditCard(cardNumber: "", cardTypeImage: "", expiryDate: "", securityCode: "")
        payType = Payment(id: 1, type: "Cash", status: true, date: "2021-03-27 03:00:00")
        payStatus = false
    }
    
    @objc fileprivate func cardButtonDidPressed(_ : UIButton){
        guard let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else {return }
        
        blackView.frame = window.frame
        
        window.addSubview(blackView)

        movedUpToNewCreditCardView()
        
        NSLayoutConstraint.activate([
            
            //BlackView Constraint
            blackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            blackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            blackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,constant: 0),
            blackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
            
            //ContentView constraint
            contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 550),
            contentView.widthAnchor.constraint(equalToConstant: blackView.frame.width),
            contentView.leftAnchor.constraint(equalTo: blackView.leftAnchor, constant: 0),
            contentView.bottomAnchor.constraint(equalTo: blackView.bottomAnchor, constant: 0),
            contentView.rightAnchor.constraint(equalTo: blackView.rightAnchor, constant: 0),
            
            //CancelButton Constraint
            cancelButton.widthAnchor.constraint(equalToConstant: 24),
            cancelButton.heightAnchor.constraint(equalToConstant: 24),
            cancelButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 26),
            cancelButton.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 23),
            cancelButton.rightAnchor.constraint(lessThanOrEqualTo: contentView.rightAnchor, constant: 328),
            
            //TitleLabel constraint
            titleLabel.heightAnchor.constraint(equalToConstant: 29),
            titleLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 169),
            titleLabel.topAnchor.constraint(equalTo: cancelButton.bottomAnchor, constant: 19),
            titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 13),
            titleLabel.rightAnchor.constraint(lessThanOrEqualTo: contentView.rightAnchor, constant: 193),
            
            //Card Number Text Field Constraint
            cardNumTextField.heightAnchor.constraint(equalToConstant: 39),
            cardNumTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 9),
            cardNumTextField.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 13),
            cardNumTextField.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -13),
            
            //Expiry Date Text Field Constraint
            expireyTextField.heightAnchor.constraint(equalToConstant: 39),
            expireyTextField.topAnchor.constraint(equalTo: cardNumTextField.bottomAnchor, constant: 10),
            expireyTextField.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 13),
            
            //Security Code Text Field constraint
            securityCodeTextField.heightAnchor.constraint(equalToConstant: 39),
            securityCodeTextField.widthAnchor.constraint(equalToConstant: 180),
            securityCodeTextField.topAnchor.constraint(equalTo: cardNumTextField.bottomAnchor, constant: 10),
            securityCodeTextField.leftAnchor.constraint(equalTo: expireyTextField.rightAnchor, constant: 8),
            securityCodeTextField.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -13),
            
            //saveInfoLabel constraint
            saveInfoLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 24),
            saveInfoLabel.topAnchor.constraint(equalTo: expireyTextField.bottomAnchor, constant: 15),
            saveInfoLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 13),
            
            //saveCardSwitch constraint
            saveCardSwitch.widthAnchor.constraint(equalToConstant: 49),
            saveCardSwitch.heightAnchor.constraint(equalToConstant: 50),
            saveCardSwitch.topAnchor.constraint(equalTo: securityCodeTextField.bottomAnchor, constant: 15),
            saveCardSwitch.leftAnchor.constraint(equalTo: saveInfoLabel.rightAnchor, constant: 10),
            saveCardSwitch.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -13),
            
            //Line label 1 constraint
            lineLabel1.heightAnchor.constraint(equalToConstant: 2),
            lineLabel1.topAnchor.constraint(lessThanOrEqualTo: saveInfoLabel.bottomAnchor, constant: 27),
            lineLabel1.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 13),
            lineLabel1.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -13),
            
            //BasketTotal Label constraint
            basketTotalLabel.heightAnchor.constraint(equalToConstant: 24),
            basketTotalLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 90),
            basketTotalLabel.topAnchor.constraint(equalTo: lineLabel1.bottomAnchor, constant: 19),
            basketTotalLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 13),
            
            //BasketAmount Label constraint
            basketAmountLabel.heightAnchor.constraint(equalToConstant: 24),
            basketAmountLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 85),
            basketAmountLabel.topAnchor.constraint(equalTo: lineLabel1.bottomAnchor, constant: 19),
            basketAmountLabel.leftAnchor.constraint(lessThanOrEqualTo: basketTotalLabel.rightAnchor, constant: 174),
            basketAmountLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -13),
            
            //Service Charge Label constraint
            serviceChargeLabel.heightAnchor.constraint(equalToConstant: 24),
            serviceChargeLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 118),
            serviceChargeLabel.topAnchor.constraint(equalTo: basketTotalLabel.bottomAnchor, constant: 10),
            serviceChargeLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 13),
            
            //Service Charge Amount Label constraint
            serviceChargeAmountLabel.heightAnchor.constraint(equalToConstant: 24),
            serviceChargeAmountLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 72),
            serviceChargeAmountLabel.topAnchor.constraint(equalTo: basketAmountLabel.bottomAnchor, constant: 10),
            serviceChargeAmountLabel.leftAnchor.constraint(lessThanOrEqualTo: serviceChargeLabel.rightAnchor, constant: 159),
            serviceChargeAmountLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -13),
            
            //Total Amount Label constraint
            totalAmountLabel.heightAnchor.constraint(equalToConstant: 29),
            totalAmountLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 124),
            totalAmountLabel.topAnchor.constraint(equalTo: serviceChargeLabel.bottomAnchor, constant: 10),
            totalAmountLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 13),
            
            //Service Charge Amount Label constraint
            totalPriceLabel.heightAnchor.constraint(equalToConstant: 29),
            totalPriceLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 99),
            totalPriceLabel.topAnchor.constraint(equalTo: serviceChargeAmountLabel.bottomAnchor, constant: 10),
            totalPriceLabel.leftAnchor.constraint(lessThanOrEqualTo: totalAmountLabel.rightAnchor, constant: 126),
            totalPriceLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -13),
            
            //InfoLabel constraint
            infoLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 24),
            infoLabel.topAnchor.constraint(equalTo: totalAmountLabel.bottomAnchor, constant: 13),
            infoLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 13),
            infoLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -13),
            
            //Line2 label constraint
            lineLabel2.heightAnchor.constraint(equalToConstant: 2),
            lineLabel2.topAnchor.constraint(lessThanOrEqualTo: infoLabel.bottomAnchor, constant: 9),
            lineLabel2.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 13),
            lineLabel2.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -13),
            
            //Button Stack View Constraint
            buttonStackView.heightAnchor.constraint(equalToConstant: 84),
            buttonStackView.topAnchor.constraint(equalTo: lineLabel2.bottomAnchor, constant: 0),
            buttonStackView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 0),
            buttonStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            buttonStackView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 0),
            
            //Cancel View Button Constraint
            cancelViewButton.heightAnchor.constraint(equalToConstant: 44),
            cancelViewButton.widthAnchor.constraint(equalToConstant: 167),
            cancelViewButton.leftAnchor.constraint(equalTo: buttonStackView.leftAnchor, constant: 13),
            cancelViewButton.centerYAnchor.constraint(equalTo: buttonStackView.centerYAnchor),
            

            //Pay View Button Constraint
            payViewButton.heightAnchor.constraint(equalToConstant: 44),
            payViewButton.widthAnchor.constraint(equalToConstant: 167),
            payViewButton.rightAnchor.constraint(equalTo: buttonStackView.rightAnchor, constant: -13),
            payViewButton.centerYAnchor.constraint(equalTo: buttonStackView.centerYAnchor)
            
        ])
    }
    
    fileprivate func movedUpToNewCreditCardView(){
        
        let y : CGFloat = view.frame.height - contentView.frame.height
        
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: { [weak self] in
            guard let strongeSelf = self else { return }
            
            strongeSelf.contentView.frame = CGRect(x: 0.0, y: -y, width: strongeSelf.contentView.frame.width, height: strongeSelf.contentView.frame.height)
        }, completion: nil)
        
    }
    
    @objc fileprivate func dismissContentView(){
        
        UIView.animate(withDuration: 1.0) { [weak self] in
            
            guard let strongeSelf = self else { return }
            
            strongeSelf.contentView.frame = CGRect(x: 0.0, y: strongeSelf.blackView.frame.height, width: strongeSelf.contentView.frame.width, height: strongeSelf.contentView.frame.height)
            
        } completion: { _ in
            self.clearCreditCardInfoField()
            self.blackView.removeFromSuperview()
            
        }

    }
    
    @objc fileprivate func dissmissKeyboard(){
        blackView.endEditing(true)
    }
    
    @objc fileprivate func cardNumFieldValueChanged(_ sender : UITextField){
        if let number = sender.text {
            
            if sender.text!.count > 0 && sender.text!.count % 5 == 0 && sender.text!.last! != " " {
                sender.text!.insert(" ", at:sender.text!.index(sender.text!.startIndex, offsetBy: sender.text!.count-1) )
            }
            
            if let type = CreditCardValidator(number).type {
                if type == CreditCardType.visa{
                    sender.setupRightCustomImage(imageName: "ViewCard_Icon", color: .clear, width: 50, height: 35)
                }
            } else {
                sender.rightView = nil
            }
        }
    }
    
    @objc func presentDatePickerView() {
        
        let expiryDatePicker = MonthYearPickerView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 240))
        
        expireyTextField.addDoneButtonOnKeyboard()
        expireyTextField.inputView = expiryDatePicker
        
        expiryDatePicker.onDateSelected = { (month: Int, year: Int) in
            let string = String(format: "%02d/%d", month, year)
            self.expireyTextField.text = string
        }
        
    }
    
    @objc fileprivate func payButtonDidPressed(){
        if !CreditCardValidator(cardNumTextField.text!).isValid {
            showErrorAlert(Message: "Invalid creadit card number")
        } else if expireyTextField.text!.isEmpty {
            showErrorAlert(Message: "Expiry field was empty")
        } else if securityCodeTextField.text!.isEmpty {
            showErrorAlert(Message: "CVV code field was empty")
        } else {
            loadAnimationView()
        }
    }
    
    fileprivate func showErrorAlert(Message message : String){
        
        let alertController = UIAlertController(title: "Warning", message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Ok", style: .cancel) { _ in
            alertController.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: false, completion: nil)
    }
    
    fileprivate func loadAnimationView(){
        let activityIndicatorView = NVActivityIndicatorView(frame: .zero, type: .orbit, color: UIColor(named: "Intraduction_Background"), padding: 0)
        
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        
        blackView.addSubview(activityIndicatorView)
        
        NSLayoutConstraint.activate([
            activityIndicatorView.widthAnchor.constraint(equalToConstant: 200),
            activityIndicatorView.heightAnchor.constraint(equalToConstant: 200),
            activityIndicatorView.centerXAnchor.constraint(equalTo: blackView.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: blackView.centerYAnchor)
        ])
        
        activityIndicatorView.startAnimating()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2){
    
            self.addCreditCardInfo()
            activityIndicatorView.stopAnimating()
            self.clearCreditCardInfoField()
            self.blackView.removeFromSuperview()
            
        }
    }
    
    fileprivate func addCreditCardInfo(){

        guard let cardNum = cardNumTextField.text else { return }
        var cardTypeImage = String()
        guard let expiryDate = expireyTextField.text else { return }
        guard let securityCode = securityCodeTextField.text else { return }
        
        if let type = CreditCardValidator(cardNum).type {
            if type == CreditCardType.visa {
                cardTypeImage = "ViewCard_Icon"
            } else if type == CreditCardType.masterCard {
                cardTypeImage = "ViewCard_Icon"
            }
        }
        
        let cardInfo = CreditCard(cardNumber: cardNum, cardTypeImage: cardTypeImage, expiryDate: expiryDate, securityCode: securityCode)
        
        if creditCardList.count == 0 {
            creditCardList[cardNum] = cardInfo
            cardDetailData()
        } else {
            let _ = creditCardList.filter { (value) -> Bool in
               
                if !value.key.elementsEqual(cardNum){
                    creditCardList[cardNum] = cardInfo
                    cardDetailData()
                    return true
                } else {
                    self.showErrorAlert(Message: "That credit card already added to the list.")
                    return false
                }
            }
        }

        DispatchQueue.main.async {
            self.payMethodTable.reloadData()
            self.setPayTableHeight()
        }
    }
    
    fileprivate func clearCreditCardInfoField(){
        cardNumTextField.text = ""
        cardNumTextField.rightView = .none
        expireyTextField.text = ""
        securityCodeTextField.text = ""
    }
    
    fileprivate func cardDetailData(){
        
        cardTableList.removeAll()
        
        for details in creditCardList {
            cardTableList.append(details.value)
        }
        
        if saveCardSwitch.isOn {
            let encoder = PropertyListEncoder()

            do {
                let data = try encoder.encode(creditCardList)
                try data.write(to: dataFilePath!)
            } catch {
                print("Error encoding cart list \(error)")
            }
        }
    }
    
    fileprivate func loadTemporyCard(){
        if let data = try? Data(contentsOf: dataFilePath!){
            let decode = PropertyListDecoder()
            
            do {
                let getCartList = try decode.decode([String:CreditCard].self, from: data)
                creditCardList = getCartList
                
                for detail in getCartList {
                    cardTableList.append(detail.value)
                }
               
                self.payMethodTable.reloadData()
                
            } catch {
                print("Error decoding cart list \(error)")
            }
        }
    }
    
    fileprivate func setPayTableHeight(){
        self.payMethodtableHeight.constant = 62.0 + (32 * CGFloat(self.cardTableList.count))
        self.loadViewIfNeeded()
    }
    
    @objc fileprivate func didSelectPayButton(_ sender : UIButton){
        
        PlaceOrderViewController.buttonArray.forEach {
            $0.isSelected = false
            $0.setBackgroundImage(UIImage(named: "PayType_Icon"), for: .normal)
        }
        
        sender.isSelected = true
        sender.setBackgroundImage(UIImage(named: "SelectedPayType_Icon"), for: .normal)
        
        let card = cardTableList[sender.tag] as CreditCard
        payCard = card
        payType = Payment(id: 2, type: "Creadit Card", status: true, date: "2021-03-27 03:00:00")
        payStatus = true
    }
    
    fileprivate func setPaymentSummary(){
        if let btAmount = basketAmount {
            basketTotal.text = String(btAmount).convertDoubleToCurrency()
            serviceCharge.text = String(200.00).convertDoubleToCurrency()
            totalAmount.text = String(btAmount + 200.00).convertDoubleToCurrency()
         }
    }
    
    fileprivate func determineCurrentLocation(){
        //locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            setupLocationManager()
            checkLocationAutherization()
        }
    }
    
    fileprivate func setupLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    fileprivate func checkLocationAutherization(){
        switch CLLocationManager.authorizationStatus(){
        
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            print("restricted")
            break
        case .denied:
            showLocationErrorAlert(Title: "Location Services Disabled", Message: "Please enable location services for this app.")
            break
        case .authorizedAlways:
            locationManager.requestAlwaysAuthorization()
            break
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            centerViewOnUserLocation()
            break
        default:
            break
        }
    }
    
    fileprivate func centerViewOnUserLocation(){
        if let location =  locationManager.location?.coordinate{
            let coordinateRegion = MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            mapView.setRegion(coordinateRegion, animated: true)
        }
    }
    
    @IBAction func changeButtonDidPressed(_ sender: Any) {
        
        let locationView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "LOCATION_SCREEN") as LocationViewController
        locationView.modalPresentationStyle = .fullScreen
        locationView.delegate = self
        
        let transition = CATransition()
        transition.duration = 0.5
        transition.subtype = .fromBottom
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        self.view.window!.layer.add(transition, forKey: kCATransition)
        
        self.present(locationView, animated: false, completion: nil)
    }
    
    fileprivate func showLocationErrorAlert(Title title : String,Message message : String){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let settingsButton = UIAlertAction(title: "Settings", style: .default) { (settingsAcction) in
            if let bundleId = Bundle.main.bundleIdentifier,
               let url = URL(string: "\(UIApplication.openSettingsURLString)&path=PRIVACY/LOCATION/\(bundleId)") {
                print(url)
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { _ in
            alertController.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(settingsButton)
        alertController.addAction(cancelAction)
        
        OperationQueue.main.addOperation {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func placeOrderDidPressed(_ sender: Any) {
        
        var orderInfo : Order!
        
        guard let profile = profileInfo else { return  }
        if let addressDetails = addressInfo,
           let basket_Amoiunt = basketAmount{
            //print("profile \(profile)")
            orderInfo = Order(id: 0, profile: profile, addressDetails: addressDetails, discount: 0, amount: Int(basket_Amoiunt), status: true, date: "")
        }
        
        if Connectivity.isConnectedToInternet() {
            orderMV.saveOrderInfo(Order: orderInfo,ProductList: orderList)
        } else {
            presentAlertMessage(AlertImage: "InternetConnection_Icon", AlertMessage: "No Internet Connection", ButtonTitle: .relaunch)
        }
        
    }
    
    fileprivate func presentAlertMessage(AlertImage image : String, AlertMessage message : String, ButtonTitle title : ButtonType){
        
        guard let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else { return }
        
        showAlertMessage.frame = window.frame
        
        showAlertMessage.errorImageView.image = UIImage(named: image)
        showAlertMessage.errorMessageLabel.text = message
        showAlertMessage.errorButton.setTitle(title.rawValue, for: .normal)
        showAlertMessage.errorButton.addTarget(self, action: #selector(alertButtonDidPressed(_:)), for: .touchUpInside)
        
        view.addSubview(showAlertMessage)
    }
    
    @objc fileprivate func alertButtonDidPressed(_ sender : UIButton){
        switch sender.currentTitle {
        case "Relaunch":
            UIApplication.shared.suspendApplication()
            break
        case "Retry":
            showAlertMessage.removeFromSuperview()
            
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
            break
        default:
            break
        }
    }
    
    fileprivate func presentDoneAnimation(){
        let activityIndicatorView = NVActivityIndicatorView(frame: .zero, type: .orbit, color: UIColor(named: "Intraduction_Background"), padding: 0)
        
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(activityIndicatorView)
        
        NSLayoutConstraint.activate([
            activityIndicatorView.widthAnchor.constraint(equalToConstant: 200),
            activityIndicatorView.heightAnchor.constraint(equalToConstant: 200),
            activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        activityIndicatorView.startAnimating()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2){
            activityIndicatorView.stopAnimating()
            activityIndicatorView.removeFromSuperview()
        }
    }
}

//MARK:- UITableViewDelegate
extension PlaceOrderViewController : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return CGFloat(32)
        } else {
            return CGFloat(62)
        }
    }
}

//MARK:- UITableViewDataSource
extension PlaceOrderViewController : UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return cardTableList.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            
            let defaultCell = payMethodTable.dequeueReusableCell(withIdentifier: "CARD_DETAIL_CELL", for: indexPath) as! CardDetailViewCell
            
            defaultCell.cardList = cardTableList[indexPath.row]
            defaultCell.selectButton.tag = indexPath.row
            PlaceOrderViewController.buttonArray.append(defaultCell.selectButton)
            defaultCell.selectButton.addTarget(self, action: #selector(didSelectPayButton), for: .touchUpInside)
            
            return defaultCell
        } else {
            let defaultCell = payMethodTable.dequeueReusableCell(withIdentifier: "DEFAULT_PAY_CELL", for: indexPath) as! CheckoutPayViewCell
            
            PlaceOrderViewController.buttonArray.append(contentsOf: [defaultCell.cardPayButton,defaultCell.cashPayButton])
            
            defaultCell.cashPayButton.addTarget(self, action: #selector(cashButtonDidPressed(_:)), for: .touchUpInside)
            defaultCell.cardPayButton.addTarget(self, action: #selector(cardButtonDidPressed(_:)), for: .touchUpInside)
        
            return defaultCell
        }
    }
}

//MARK:- UITextFieldDelegate
extension PlaceOrderViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 0 {
            if !CreditCardValidator(textField.text!).isValid{
                textField.textColor = UIColor.red
                textField.rightView = nil
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 0 {
            textField.clearsOnBeginEditing = true
            textField.textColor = UIColor(named: "Black_Color")!
        }
    }
    
}

//MARK:- CLLocationManagerDelegate
extension PlaceOrderViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation : CLLocation = locations[0] as CLLocation
        //stop updating location
        manager.stopUpdatingLocation()

        let center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(region, animated: true)

        myAnnotation.coordinate = CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude)
        mapView.addAnnotation(myAnnotation)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAutherization()
    }
}

//MARK:- MKMapViewDelegate
extension PlaceOrderViewController : MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is MKPointAnnotation) {
            return nil
        }
        
        let annotationIdentifier = "AnnotationIdentifier"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView!.canShowCallout = true
            
        }
        else {
            annotationView!.annotation = annotation
        }
        
        let pinImage = UIImage(named: "Location_Icon")
        annotationView!.image = pinImage
        return annotationView
    }
}

//MARK:- CustomLocationDelegate
extension PlaceOrderViewController : CustomLocationDelegate {
    func setCustomLocation(_ coordinate: CLLocationCoordinate2D) {

        mapView.removeAnnotations(mapView.annotations)
        let center = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(region, animated: true)
        
        let pointAnnotation = MKPointAnnotation()
        pointAnnotation.coordinate = coordinate
        mapView.addAnnotation(pointAnnotation)
    }
}

//MARK:- RegistrationDelegate
extension PlaceOrderViewController : RegistrationDelegate {
    func getResponse(_ response: ApiResponse) { }
    
    func getUniqueFieldResult(_ field: String, _ result: Bool) { }
    
    func getProfileInfo(_ profile: Profile?) {
        if let details = profile,let id = details.id {
            self.profileInfo = details
            addressMV.getBillingAddressInfo(ProfileId: id)
        }
    }
}

//MARK:- AddressDelegate
extension PlaceOrderViewController : AddressDelegate {
    func showCustomAlertMessage(HttpCode code: Int) { }
    
    func getBillingAddressInfo(BillingAddress details: AddressDetail) {
        nameLabel.text = "\(details.firstName!) \(details.lastName!)"
        mobileLabel.text = "Mobile No :- \(details.mobile!)"
        var address : String = ""
        if !details.apartmentNo!.isEmpty{
            address = "\(details.apartmentNo!) \n"
        }
        address += "\(details.houseNo!) \n"
        address += "\(details.city!) \n"
        address += details.postalCode!
        addressLabel.text = address
        
        if let latitude = details.latitude,let longitude = details.longitude{
            
            mapView.removeAnnotations(mapView.annotations)
            
            let center = CLLocationCoordinate2D(latitude: Double(latitude)!, longitude: Double(longitude)!)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            mapView.setRegion(region, animated: true)
            
            let pointAnnotation = MKPointAnnotation()
            pointAnnotation.coordinate = center
            mapView.addAnnotation(pointAnnotation)
        }
        
        self.addressInfo = details
    }
}

//MARK:- OrderDelegate
extension PlaceOrderViewController : OrderDelegate{
    
    func getOrderInfo(Order info: Order) {

        paymentInfoList.removeAll()
        
        
        print(payCard)
        
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let formatDate = formatter.string(from: currentDate)
        
        let details = PaymentDetails(id: 0, order: info, payment: payType, payAmount: (info.amount + 200), date: formatDate, creaditCard: payCard, status: payStatus)
        paymentInfoList.append(details)
        
        paymentMV.saveOrderPayment(paymentDetails: paymentInfoList)
    }
    
    func showResponseCode(HttpCode code: Int) {
        switch HttpStatus(rawValue: code) {
        case .created:
            presentDoneAnimation()
            break
            
        case .internalServerError:
            presentAlertMessage(AlertImage: "ServerError_Image", AlertMessage: "Server Error..! \n You order was unsuccessfully saved.", ButtonTitle: .retry)
            break
        case .badRequest:
            presentAlertMessage(AlertImage: "ServerError_Image", AlertMessage: "Server Error..! \n You order was unsuccessfully saved.", ButtonTitle: .retry)
            break
        case .notFound:
            break
        case .none:
            break
        }
    }
}
