//
//  AccountDetailViewController.swift
//  GedaratamaMalu
//
//  Created by Ashan Don on 1/27/21.
//

import UIKit

class AccountDetailViewController: UIViewController {
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var backgroundView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var displayNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var currentPasswordField: UITextField!
    @IBOutlet weak var newPasswordField: UITextField!
    @IBOutlet weak var retypePasswordField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    private lazy var touchView : UIView = {
        let tView = UIView()
        tView.isUserInteractionEnabled = true
        tView.frame = view.bounds
        tView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        return tView
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstNameField.delegate = self
        lastNameField.delegate = self
        displayNameField.delegate = self
        emailField.delegate = self
        currentPasswordField.delegate = self
        newPasswordField.delegate = self
        retypePasswordField.delegate = self
        
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        changeViewComponents()
        registerFromKeyboardEvent()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        disappearFromKeyboardEvent()
    }
    
    private func changeViewComponents(){
        
        // navigation bar
        let navigationItem = UINavigationItem()
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: #selector(dismissView))
        navigationItem.leftBarButtonItem = cancelButton
        
        navigationBar.setItems([navigationItem], animated: false)
        
        navigationBar.layer.opacity = Float(72)
        navigationBar.alpha = 0.7
        
        //Background Image View
        backgroundView.layer.opacity = Float(72)
        backgroundView.alpha = 0.7
        
        //Detail View
        detailView.layer.cornerRadius = 20.0
        detailView.layer.borderColor = UIColor(named: "Black_Color")!.cgColor
        detailView.layer.borderWidth = 2.0
        
        //First Name Field
        firstNameField.attributedPlaceholder = NSAttributedString(string: "First Name", attributes: [
            
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)
            
        ])
        
        firstNameField.setTintColor(.darkGray)
        
        firstNameField.setBackgroundColor()
        
        firstNameField.setLeftPaddingPoints(5)
        
        firstNameField.setRightPaddingPoints(5)
        
        //Last Name Field
        lastNameField.attributedPlaceholder = NSAttributedString(string: "Last Name", attributes: [
            
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)
            
        ])
        
        lastNameField.setTintColor(.darkGray)
        
        lastNameField.setBackgroundColor()
        
        lastNameField.setLeftPaddingPoints(5)
        
        lastNameField.setRightPaddingPoints(5)
        
        //Display Name Field
        displayNameField.attributedPlaceholder = NSAttributedString(string: "Display Name", attributes: [
            
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)
            
        ])
        
        displayNameField.setTintColor(.darkGray)
        
        displayNameField.setBackgroundColor()
        
        displayNameField.setLeftPaddingPoints(5)
        
        displayNameField.setRightPaddingPoints(5)
        
        //Email Field
        emailField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [
            
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)
            
        ])
        
        emailField.setTintColor(.darkGray)
        
        emailField.setBackgroundColor()
        
        emailField.setLeftPaddingPoints(5)
        
        emailField.setRightPaddingPoints(5)
        
        //Current Password Field
        currentPasswordField.attributedPlaceholder = NSAttributedString(string: "Current Password", attributes: [
            
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)
            
        ])
        
        currentPasswordField.setTintColor(.darkGray)
        
        currentPasswordField.setBackgroundColor()
        
        currentPasswordField.setLeftPaddingPoints(5)
        
        currentPasswordField.setRightPaddingPoints(5)
        
        //New Password Field
        newPasswordField.attributedPlaceholder = NSAttributedString(string: "New Password", attributes: [
            
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)
            
        ])
        
        newPasswordField.setTintColor(.darkGray)
        
        newPasswordField.setBackgroundColor()
        
        newPasswordField.setLeftPaddingPoints(5)
        
        newPasswordField.setRightPaddingPoints(5)
        
        //Retype Password Field
        retypePasswordField.attributedPlaceholder = NSAttributedString(string: "Retype Password", attributes: [
            
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)
            
        ])
        
        retypePasswordField.setTintColor(.darkGray)
        
        retypePasswordField.setBackgroundColor()
        
        retypePasswordField.setLeftPaddingPoints(5)
        
        retypePasswordField.setRightPaddingPoints(5)
        
        //Save Button
        saveButton.layer.cornerRadius = saveButton.frame.height / 2
        
    }
    
    @objc private func dismissView(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func dismissKeyboard(){
        view.endEditing(true)
    }
    
    private func registerFromKeyboardEvent(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHidden), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func disappearFromKeyboardEvent(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification : Notification){
        
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        let edgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: (keyboardSize.height + 10), right: 0.0)
        
        scrollView.contentInset = edgeInsets
        scrollView.scrollIndicatorInsets = edgeInsets
        
        view.addSubview(touchView)
    }
    
    @objc func keyboardWillHidden(_ notification : Notification){
        
        touchView.removeFromSuperview()
        
        let edgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        
        scrollView.contentInset = edgeInsets
        scrollView.scrollIndicatorInsets = edgeInsets
    }
}

extension AccountDetailViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}
