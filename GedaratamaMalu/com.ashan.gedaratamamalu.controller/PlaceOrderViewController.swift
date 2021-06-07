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

class PlaceOrderViewController: UIViewController {

    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var customerInfoView: UIView!
    @IBOutlet weak var mapView : MKMapView!
    @IBOutlet weak var deliveryInfoView: UIView!
    @IBOutlet weak var payMethodTable : UITableView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var mobileLabel: UILabel!
    @IBOutlet weak var placeOrderButton: UIButton!
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var payMethodtableHeight: NSLayoutConstraint!
    
    fileprivate var creditCardList : [String:CreditCard] = [String:CreditCard]()
    
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
        view.addSubview(cancelViewButton)
        view.addSubview(payViewButton)
        
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
        
        payMethodTable.delegate = self
        payMethodTable.dataSource = self
        
        payMethodtableHeight.constant = 62.0 + (32 * CGFloat(creditCardList.count))
        self.loadViewIfNeeded()
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
        
    }
    
    fileprivate func setupViewLayout(){
        
        let navigationItem = UINavigationItem(title: "Checkout")
        
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
        print("cash method")
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
            blackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            blackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
            
            //ContentView constraint
            contentView.heightAnchor.constraint(equalToConstant: 550),
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
            
            //Cancel View Button Constraint
            cancelViewButton.heightAnchor.constraint(equalToConstant: 45),
            cancelViewButton.widthAnchor.constraint(lessThanOrEqualToConstant: 167),
            cancelViewButton.topAnchor.constraint(equalTo: lineLabel2.bottomAnchor, constant: 20),
            cancelViewButton.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 13),
            cancelViewButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            //Pay View Button Constraint
            payViewButton.heightAnchor.constraint(equalToConstant: 45),
            payViewButton.widthAnchor.constraint(lessThanOrEqualToConstant: 167),
            payViewButton.topAnchor.constraint(equalTo: lineLabel2.bottomAnchor, constant: 20),
            payViewButton.leftAnchor.constraint(equalTo: cancelViewButton.rightAnchor, constant: 15),
            payViewButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            payViewButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -13)
            
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
        
        self.present(alertController, animated: true, completion: nil)
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
        var cardTypeImage = UIImage()
        guard let expiryDate = expireyTextField.text else { return }
        guard let securityCode = securityCodeTextField.text else { return }
        
        if let type = CreditCardValidator(cardNum).type {
            if type == CreditCardType.visa {
                cardTypeImage = UIImage(named: "ViewCard_Icon")!
            } else if type == CreditCardType.masterCard {
                cardTypeImage = UIImage(named: "ViewCard_Icon")!
            }
        }
        
        let cardInfo = CreditCard(cardNumber: cardNum, cardTypeImage: cardTypeImage, expiryDate: expiryDate, securityCode: securityCode)
        
        if creditCardList.count == 0 {
            creditCardList[cardNum] = cardInfo
        } else {
            let _ = creditCardList.filter { (value) -> Bool in
               
                if !value.key.elementsEqual(cardNum){
                    creditCardList[cardNum] = cardInfo
                    return true
                } else {
                    self.showErrorAlert(Message: "That credit card already added to the list.")
                    return false
                }
            }
        }
        
        DispatchQueue.main.async {
            self.payMethodTable.reloadData()
            self.payMethodtableHeight.constant = 62.0 + (32 * CGFloat(self.creditCardList.count))
            self.loadViewIfNeeded()
            
        }
    }
    
    fileprivate func clearCreditCardInfoField(){
        cardNumTextField.text = ""
        cardNumTextField.rightView = .none
        expireyTextField.text = ""
        securityCodeTextField.text = ""
    }
}

extension PlaceOrderViewController : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return CGFloat(32)
        } else {
            return CGFloat(62)
        }
    }
    
}

extension PlaceOrderViewController : UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return creditCardList.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let defaultCell = payMethodTable.dequeueReusableCell(withIdentifier: "CARD_DETAIL_CELL", for: indexPath) as! CardDetailViewCell
            
            return defaultCell
        } else {
            let defaultCell = payMethodTable.dequeueReusableCell(withIdentifier: "DEFAULT_PAY_CELL", for: indexPath) as! CheckoutPayViewCell
            defaultCell.cashPayButton.addTarget(self, action: #selector(cashButtonDidPressed(_:)), for: .touchUpInside)
            defaultCell.cardPayButton.addTarget(self, action: #selector(cardButtonDidPressed(_:)), for: .touchUpInside)
            return defaultCell
        }
    }
    
}

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
