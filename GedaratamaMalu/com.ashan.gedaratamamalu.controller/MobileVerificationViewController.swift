//
//  MobileVerificationViewController.swift
//  GedaratamaMalu
//
//  Created by Ashan Don on 1/10/21.
//

import UIKit

class MobileVerificationViewController: UIViewController {
    
    
    @IBOutlet weak var mobileNoField: UILabel!
    
    @IBOutlet weak var digit1Field: UITextField!
    
    @IBOutlet weak var digit2Field: UITextField!
    
    @IBOutlet weak var digit3Field: UITextField!
    
    @IBOutlet weak var digit4Field: UITextField!
    
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var smsButton: UIButton!
    
    @IBOutlet weak var callButton: UIButton!
    
    private var bottomViewConstraint : NSLayoutConstraint!
    
    public var mobileNumber : String?
    
    //https://numverify.com/dashboard
    
    private lazy var blackView : UIView = {
       let bView = UIView()
        bView.isUserInteractionEnabled = true
        bView.frame = view.bounds
        bView.backgroundColor =  UIColor(white: 0, alpha: 0.7)
        bView.alpha = 0
        bView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(smsViewDismiss)))
        return bView
    }()
    
    private lazy var resendSMSView : UIView = {
       
        let backgroundView = UIView()
        
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        backgroundView.isUserInteractionEnabled = true
        
        backgroundView.backgroundColor = .clear
        
        backgroundView.addSubview(separetorTopView)
        
        backgroundView.addSubview(contentView)
        
        return backgroundView
        
    }()
    
    private lazy var separetorTopView : UIView = {
        
        let sTView = UIView()
        
        sTView.translatesAutoresizingMaskIntoConstraints = false
        
        sTView.backgroundColor = UIColor(named: "White_Color")!
        
        sTView.layer.cornerRadius = CGFloat(5)
        
        return sTView
        
    }()
    
    private lazy var contentView : UIView = {
       
        let cView = UIView()
        
        cView.translatesAutoresizingMaskIntoConstraints = false
        
        cView.isUserInteractionEnabled = true
        
        cView.backgroundColor = UIColor(named: "White_Color")!
        
        cView.layer.masksToBounds = true
        
        cView.layer.cornerRadius = 30.0
        
        cView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        cView.addSubview(heddingLabel)
        
        cView.addSubview(closeButton)
        
        cView.addSubview(messageLabel)
        
        cView.addSubview(mobileNoLabel)
        
        cView.addSubview(buttonStackView)
        
        return cView
        
    }()
    
    private lazy var heddingLabel : UILabel = {
        
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.textAlignment = .left
        
        label.textColor = UIColor(named: "SubView_Hedding_Color")!
        
        label.backgroundColor = .clear
        
        label.font = UIFont(name: "Helvetica-Bold", size: 18)
        
        return label
        
    }()
    
    private lazy var messageLabel : UILabel = {
        
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.textAlignment = .left
        
        label.textColor = UIColor(named: "SubView_Hedding_Color")!
        
        label.backgroundColor = .clear
        
        label.font = UIFont(name: "Helvetica-Bold", size: 12)
        
        label.numberOfLines = 0
        
        return label
        
    }()
    
    private lazy var mobileNoLabel : UILabel = {
        
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.textAlignment = .left
        
        label.textColor = UIColor(named: "Black_Color")!
        
        label.backgroundColor = .clear
        
        label.font = UIFont(name: "Helvetica-Bold", size: 16)
        
        return label
        
    }()
    
    private lazy var buttonStackView : UIStackView = {
       
        let stackView = UIStackView()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.axis = .horizontal
        
        stackView.alignment = .fill
        
        stackView.distribution = .fillEqually
        
        stackView.spacing = 10
        
        stackView.backgroundColor = .clear
        
        stackView.addArrangedSubview(changeButton)
        
        stackView.addArrangedSubview(yesButton)
        
        return stackView
    }()
    
    private lazy var changeButton : UIButton = {
       
        let button = UIButton()
        
        button.setTitle("Change", for: .normal)
        
        button.titleLabel!.font = UIFont(name: "Lucida Grande Bold", size: 14)
        
        button.titleLabel!.textAlignment = .center
        
        button.titleLabel!.textColor = UIColor(named: "SubView_Font_Color")!
        
        button.backgroundColor = UIColor(named: "ChangeButton_Background_Color")!
        
        button.layer.opacity = Float(88.0)
        
        button.layer.cornerRadius = 8
        
        button.alpha = CGFloat(0.8)
        
        button.addTarget(self, action: #selector(changeMobileNo), for: .touchUpInside)
        
        return button
        
    }()
    
    private lazy var yesButton : UIButton = {
       
        let button = UIButton()
        
        button.setTitle("Yes", for: .normal)
        
        button.titleLabel!.font = UIFont(name: "Lucida Grande Bold", size: 14)
        
        button.titleLabel!.textAlignment = .center
        
        button.titleLabel!.textColor = UIColor(named: "SubView_Font_Color")!
        
        button.backgroundColor = UIColor(named: "YesButton_Background_Color")!
        
        button.layer.opacity = Float(88.0)
        
        button.layer.cornerRadius = 8
        
        button.alpha = CGFloat(0.8)
        
        return button
        
    }()
    
    private lazy var closeButton : UIButton = {
       
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.isUserInteractionEnabled = true
        
        button.setImage(UIImage(named: "Close_Icon")!, for: .normal)
        
        button.backgroundColor = .clear
        
        button.isEnabled = true
        
        button.addTarget(self, action: #selector(smsViewDismiss(_:)), for: UIControl.Event.touchUpInside)
        
        return button
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextButton.isEnabled = false

        digit1Field.delegate = self
        
        digit2Field.delegate = self
        
        digit3Field.delegate = self
        
        digit4Field.delegate = self
        
//        view.addSubview(resendSMSView)
        
        view.addSubview(self.blackView)
        view.addSubview(self.resendSMSView)
        
        NSLayoutConstraint.activate([
            
            //SMS Main View Constraint
            resendSMSView.heightAnchor.constraint(equalToConstant: CGFloat(201)),
            NSLayoutConstraint(item: resendSMSView, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: resendSMSView, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: 0),
            
            //Separetor Top View Constraint
            separetorTopView.heightAnchor.constraint(equalToConstant: CGFloat(10)),
            separetorTopView.widthAnchor.constraint(equalToConstant: CGFloat(60)),
            separetorTopView.topAnchor.constraint(equalTo: resendSMSView.topAnchor, constant: 0),
            separetorTopView.centerXAnchor.constraint(equalTo: resendSMSView.centerXAnchor),
            
            //Content View Constraint
            contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: CGFloat(178)),
            contentView.topAnchor.constraint(equalTo: separetorTopView.bottomAnchor, constant: 10),
            contentView.leftAnchor.constraint(equalTo: resendSMSView.leftAnchor, constant: 0),
            contentView.bottomAnchor.constraint(equalTo: resendSMSView.bottomAnchor, constant: 0),
            contentView.rightAnchor.constraint(equalTo: resendSMSView.rightAnchor, constant: 0),
            
            //Hedding Label Constraint
            heddingLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 130),
            heddingLabel.heightAnchor.constraint(equalToConstant: 22),
            heddingLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            heddingLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
        
            //Message Label Constraint
            messageLabel.heightAnchor.constraint(equalToConstant: 30),
            messageLabel.topAnchor.constraint(equalTo: heddingLabel.bottomAnchor, constant: 10),
            messageLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            messageLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20),
            
            //Mobile No Label Constraint
            mobileNoLabel.heightAnchor.constraint(equalToConstant: 17),
            mobileNoLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 95),
            mobileNoLabel.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 8),
            mobileNoLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            
            //Button Stack View Constraint
            buttonStackView.widthAnchor.constraint(equalToConstant: 270),
            buttonStackView.heightAnchor.constraint(equalToConstant: 40),
            buttonStackView.topAnchor.constraint(equalTo: mobileNoLabel.bottomAnchor, constant: 15),
            buttonStackView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20),
            
            //Close Button Contraint
            closeButton.widthAnchor.constraint(equalToConstant: 25),
            closeButton.heightAnchor.constraint(equalToConstant: 25),
            closeButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            closeButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20)
        ])
        
        bottomViewConstraint = NSLayoutConstraint(item: resendSMSView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 201)

        view.addConstraint(bottomViewConstraint)

        view.layoutIfNeeded()
        
        if let mobileNo = mobileNumber {
            self.mobileNoField.text = mobileNo
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        didChangeCustomComponant()
        
    }

    private func didChangeCustomComponant(){
        
        //UIView
        view.layer.opacity = Float(72)
        
        view.alpha = CGFloat(0.0)
        
        //UITextField
        digit1Field.setBottomBorder(backgroundColor: UIColor.clear, shadowColor: UIColor(named: "Black_Color")!)
        
        digit2Field.setBottomBorder(backgroundColor: UIColor.clear, shadowColor: UIColor(named: "Black_Color")!)
        
        digit3Field.setBottomBorder(backgroundColor: UIColor.clear, shadowColor: UIColor(named: "Black_Color")!)
        
        digit4Field.setBottomBorder(backgroundColor: UIColor.clear, shadowColor: UIColor(named: "Black_Color")!)
        
        digit1Field.setTintColor(UIColor(named: "Black_Color")!)
        
        digit2Field.setTintColor(UIColor(named: "Black_Color")!)
        
        digit3Field.setTintColor(UIColor(named: "Black_Color")!)
        
        digit4Field.setTintColor(UIColor(named: "Black_Color")!)
        
        //UIButton
        
        nextButton.layer.cornerRadius = nextButton.layer.frame.height / 2
        
    }
    
    @IBAction private func smsButtonDidPressed(_ sender : UIButton){
        
        if sender.currentTitle!.elementsEqual("SMS"){
            
            heddingLabel.text = "Resend Code"
            messageLabel.text = "Are you sure you want to send the code to following number?"
            
            if let mobileNo = mobileNumber{
                mobileNoLabel.text = mobileNo
            }
            
            
        } else {
            
            heddingLabel.text = "Resend Code from call"
            messageLabel.text = "Are you sure you want to send the code to following number?"
            
            if let mobileNo = mobileNumber{
                mobileNoLabel.text = mobileNo
            }
            
        }
        
        self.blackView.alpha = 1
        
        UIView.animate(withDuration: 0.7, delay: 0, options: .curveEaseOut, animations: {
            
            self.bottomViewConstraint.constant = -0
            
            self.view.layoutIfNeeded()
            
        }, completion: nil)
        
    }
    
    @objc private func smsViewDismiss(_ sender : UIButton){
        
        UIView.animate(withDuration: 0.7, delay: 0, options: .curveEaseOut, animations: {
            
            self.bottomViewConstraint.constant = 201
            
            self.view.layoutIfNeeded()
            
            self.blackView.alpha = 0
        }, completion: nil)
        
    }
    
    @IBAction private func dismissVerificationView(){
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @objc private func changeMobileNo(){
        
        NotificationCenter.default.post(name: Notification.Name("EDIT_MOBILE_NO"), object: nil)
        
        self.dismiss(animated: true) {
            NotificationCenter.default.removeObserver(self, name: Notification.Name("EDIT_MOBILE_NO"), object: nil)
        }
    }
}

extension MobileVerificationViewController : UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        
        if textField.text!.count == 1 {
            
            switch textField {
            
            case digit1Field:
                digit2Field.becomeFirstResponder()
                break
            
            case digit2Field:
                digit3Field.becomeFirstResponder()
                break
                
            case digit3Field:
                digit4Field.becomeFirstResponder()
                break
                
            case digit4Field:
                nextButton.isEnabled = true
                view.endEditing(true)
                break
                
            default:
                break
            }
        } else if textField.text!.count == 0 {
            
            switch textField {
            
            case digit4Field:
                digit3Field.becomeFirstResponder()
                nextButton.isEnabled = false
                break
                
            case digit3Field:
                digit2Field.becomeFirstResponder()
                break
                
            case digit2Field:
                digit1Field.becomeFirstResponder()
                break
                
            case digit1Field:
                digit1Field.text = ""
                break
                
            default:
                break
            }
        }
    }
}
