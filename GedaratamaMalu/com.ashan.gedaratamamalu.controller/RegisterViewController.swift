//
//  RegisterViewController.swift
//  GedaratamaMalu
//
//  Created by Ashan Don on 1/6/21.
//

import UIKit
import Alamofire

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var scrollView : UIScrollView!

    @IBOutlet weak var backgroundView: UIImageView!
    
    @IBOutlet weak var closeImage: UIImageView!
    
    @IBOutlet weak var middleView: UIView!
    
    @IBOutlet weak var firstNameField: UITextField!
    
    @IBOutlet weak var lastNameField: UITextField!
    
    @IBOutlet weak var countryCodeField : UITextField!
    
    @IBOutlet weak var contactField: UITextField!
    
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var userNameField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var rePasswordField: UITextField!
    
    @IBOutlet weak var registerButton: UIButton!
    
    private var bottomViewConstraint : NSLayoutConstraint!
    
    private let countryCodeList : [String] = ["+91 India","+92 Pakistan","+94 Sri Lanka","+95 Myanmar","+960 Maldives","+971 United Arab Emirates","+91 India","+92 Pakistan","+94 Sri Lanka","+95 Myanmar","+960 Maldives","+971 United Arab Emirates"]
    
    private var countryCode : String? = nil
    
    private var jwt_Token : String = String()
    
    private var registerMV : RegisterModelView!
    
    private var otpMV : OTPViewModel!
    
    private lazy var touchView : UIView = {
        
        let tv = UIView()
        
        tv.frame = view.bounds
        
        tv.isUserInteractionEnabled = true
        
        let viewTGR = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        tv.addGestureRecognizer(viewTGR)
        
        return tv
        
    }()
    
    private lazy var pickerViewBackground : UIView = {
       
        let background = UIView()
        
        background.translatesAutoresizingMaskIntoConstraints = false
        
        background.isUserInteractionEnabled = true
        
        background.backgroundColor = UIColor(named: "White_Color")!
        
        background.addSubview(pickerToolBar)
        
        background.addSubview(countryCodePicker)
        
        return background
        
    }()
    
    private lazy var leftBarButton : UIBarButtonItem = {
       
        let barButton = UIBarButtonItem()
        
        barButton.title = "Cancel"
        barButton.style = .plain
        barButton.target = self
        barButton.action = #selector(cancelPressed)
        
        return barButton
        
    }()
    
    private lazy var rightBarButton : UIBarButtonItem = {
       
        let barButton = UIBarButtonItem()
        
        barButton.title = "Done"
        barButton.style = .plain
        barButton.target = self
        barButton.action = #selector(donePressed)
        
        return barButton
        
    }()
    
    private lazy var toolBarTitle : UILabel = {
       
        let titleLabel = UILabel()
        
        titleLabel.tintColor = UIColor(named: "Black_Color")
        
        titleLabel.text = "Select your country"
        
        titleLabel.textAlignment = .center
        
        return titleLabel
        
    }()
    
    private lazy var pickerToolBar : UIToolbar = {
        
        let toolBar = UIToolbar()
        
        toolBar.isUserInteractionEnabled = true
        
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        
        toolBar.barTintColor = UIColor(named: "ToolBar_Background_Color")!
        
        toolBar.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44)
    
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        let barTitle = UIBarButtonItem(customView: toolBarTitle)

        toolBar.setItems([leftBarButton,flexibleSpace,barTitle,flexibleSpace,rightBarButton], animated: false)
        
        return toolBar
        
    }()
    
    private lazy var countryCodePicker : UIPickerView = {
       
        let picker = UIPickerView()
    
        picker.isUserInteractionEnabled = true
        
        picker.translatesAutoresizingMaskIntoConstraints = false
        
        picker.backgroundColor = .none
        
        picker.tintColor = UIColor(named: "Black_Color")!
        
        picker.dataSource = self
        
        picker.delegate = self
        
        return picker
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addTapGestureRecognizer()
        
        firstNameField.delegate = self
        
        lastNameField.delegate = self
        
        contactField.delegate = self
        
        emailField.delegate = self
        
        userNameField.delegate = self
        
        passwordField.delegate = self
        
        rePasswordField.delegate = self
        
        let constraint : [NSLayoutConstraint] = [
            
            //Background View constraint
            pickerViewBackground.heightAnchor.constraint(equalToConstant: 261),
            
            NSLayoutConstraint(item: pickerViewBackground, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 0),
            
            NSLayoutConstraint(item: pickerViewBackground, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: 0),
            
            //Tool bar constraint
            pickerToolBar.heightAnchor.constraint(equalToConstant: 44),
            
            NSLayoutConstraint(item: pickerToolBar, attribute: .top, relatedBy: .equal, toItem: pickerViewBackground, attribute: .top, multiplier: 1, constant: 0),
            
            NSLayoutConstraint(item: pickerToolBar, attribute: .left, relatedBy: .equal, toItem: pickerViewBackground, attribute: .left, multiplier: 1, constant: 0),
            
            NSLayoutConstraint(item: pickerToolBar, attribute: .right, relatedBy: .equal, toItem: pickerViewBackground, attribute: .right, multiplier: 1, constant: 0),
            
            //Picker view constraint
            NSLayoutConstraint(item: countryCodePicker, attribute: .top, relatedBy: .equal, toItem: pickerToolBar, attribute: .bottom, multiplier: 1, constant: 0),
            
            NSLayoutConstraint(item: countryCodePicker, attribute: .left, relatedBy: .equal, toItem: pickerViewBackground, attribute: .left, multiplier: 1, constant: 0),
            
            NSLayoutConstraint(item: countryCodePicker, attribute: .bottom, relatedBy: .equal, toItem: pickerViewBackground, attribute: .bottom, multiplier: 1, constant: 0),
            
            NSLayoutConstraint(item: countryCodePicker, attribute: .right, relatedBy: .equal, toItem: pickerViewBackground, attribute: .right, multiplier: 1, constant: 0)
            
        ]
        
        view.addSubview(pickerViewBackground)
        
        view.addConstraints(constraint)
        
        bottomViewConstraint = NSLayoutConstraint(item: pickerViewBackground, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 261)
        
        view.addConstraint(bottomViewConstraint)
        
        countryCodePicker.selectRow(countryCodeList.count / 2, inComponent: 0, animated: true)
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeMobileNoFormFV), name: Notification.Name("EDIT_MOBILE_NO"), object: nil)
        
        getDefaultJWTToken()
        
        registerMV = RegisterModelView(jwt_Token)
        registerMV.delegate = self
        
        otpMV = OTPViewModel(jwt_Token)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateViewComponent()
        
        registedKeyboardEvent()
        
        scrollView.isScrollEnabled = false
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        disappearKeyboardEvent()
        
    }
    
    private func updateViewComponent(){
        
        // UIImageView
        
        backgroundView.layer.opacity = Float(72)
        
        backgroundView.alpha = 0.7
        
        // UIView
        
        middleView.layer.cornerRadius = 23
        
        middleView.layer.borderColor = UIColor(named: "Black_Color")!.cgColor
        
        middleView.layer.borderWidth = 2
        
        middleView.applyViewShadow(color: UIColor(named: "View_Shadow_Color")!, alpha: 0.5, x: 4, y: 10, blur: 4, spread: 0)
        
        middleView.layer.opacity = Float(100)
        
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
        
        //Country Code Field
        countryCodeField.attributedPlaceholder = NSAttributedString(string: "+94", attributes: [
            
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)
            
        ])
        
        countryCodeField.setTintColor(.darkGray)
        
        countryCodeField.setBackgroundColor()
        
        countryCodeField.setLeftPaddingPoints(5)
        
        countryCodeField.setRightPaddingPoints(5)
        
        //Contact Field
        contactField.attributedPlaceholder = NSAttributedString(string: "Mobile No", attributes: [
            
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)
            
        ])
        
        contactField.setTintColor(.darkGray)
        
        contactField.setBackgroundColor()
        
        contactField.setLeftPaddingPoints(5)
        
        contactField.setRightPaddingPoints(5)
        
        //Email Field
        emailField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [
            
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)
            
        ])
        
        emailField.setTintColor(.darkGray)
        
        emailField.setBackgroundColor()
        
        emailField.setLeftPaddingPoints(5)
        
        //User Name Field
        userNameField.attributedPlaceholder = NSAttributedString(string: "User Name", attributes: [
            
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)
            
        ])
        
        userNameField.setTintColor(.darkGray)
        
        userNameField.setBackgroundColor()
        
        userNameField.setLeftPaddingPoints(5)
        
        userNameField.setRightPaddingPoints(5)
        
        //Password Field
        passwordField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [
            
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)
            
        ])
        
        passwordField.setTintColor(.darkGray)
        
        passwordField.setBackgroundColor()
        
        passwordField.setLeftPaddingPoints(5)
        
        passwordField.setRightPaddingPoints(5)
        
        //Repassword Field
        rePasswordField.attributedPlaceholder = NSAttributedString(string: "Repassword", attributes: [
            
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)
            
        ])
        
        rePasswordField.setTintColor(.darkGray)
        
        rePasswordField.setBackgroundColor()
        
        rePasswordField.setLeftPaddingPoints(5)
        
        rePasswordField.setRightPaddingPoints(5)
        
        //Register Button
        
        registerButton.layer.cornerRadius = registerButton.frame.height / 2
        
    }
    
    @objc private func dismissView(){
        
        UIView.animate(withDuration: 0.5) { [weak self] in
            
            guard let strongeSelf = self else { return }
            
            strongeSelf.dismiss(animated: true, completion: nil)
            
        }
        
        
    }
    
    @IBAction private func registerButtonPressed(){
        
        if firstNameField.text!.isEmpty {
            firstNameField.setupRightCustomImage(imageName: "Empty_Icon", color: .red)
        } else if lastNameField.text!.isEmpty {
            lastNameField.setupRightCustomImage(imageName: "Empty_Icon", color: .red)
        } else if countryCodeField.text!.isEmpty || contactField.text!.isEmpty{
            contactField.setupRightCustomImage(imageName: "Empty_Icon", color: .red)
        } else if emailField.text!.isEmpty {
            emailField.setupRightCustomImage(imageName: "Empty_Icon", color: .red)
        } else if userNameField.text!.isEmpty {
            userNameField.setupRightCustomImage(imageName: "Empty_Icon", color: .red)
        } else if passwordField.text!.isEmpty {
            passwordField.setupRightCustomImage(imageName: "Empty_Icon", color: .red)
        } else if rePasswordField.text!.isEmpty {
            rePasswordField.setupRightCustomImage(imageName: "Empty_Icon", color: .red)
        } else if !passwordField.text!.elementsEqual(rePasswordField.text!){
            presentPopOver("The password does not match. Please try again.", rePasswordField)
        } else {
            
            if let firstName = firstNameField.text,
               let lastName = lastNameField.text,
               let mobile = contactField.text,
               let email = emailField.text,
               let userName = userNameField.text,
               let password = passwordField.text {
                
                let profileType = ProfileType(id: 5, type: "Administrator", status: true, date: "2021-04-05T00:00:00.000+00:00")
                
                guard let code = countryCodeField.text else { return }
                var mobileCode : String {
                    return "\(code) \(mobile)"
                }
                print(Date().getFormattedDate())
                let profile = Profile(id:0,firstName: firstName, lastName: lastName, mobile: mobileCode, email: email, userName: userName, password: password, status: true, date: "", profileType: profileType)
                
                print(profile)
                presentVerificationVC(profile)
                otpMV.generateOTP(userName)
            }

        }
        
    }
    
    @objc private func dismissKeyboard(){
        
        view.endEditing(true)
        
    }
    
    private func registedKeyboardEvent(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    @objc private func keyboardWillShow(_ notification : Notification){
        
        scrollView.isScrollEnabled = true
        
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        let edgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
        
        scrollView.contentInset = edgeInsets
        
        scrollView.scrollIndicatorInsets = edgeInsets
        
        view.addSubview(touchView)
        
    }
    
    @objc private func keyboardWillHide(_ notification : Notification){
        
        let edgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        
        scrollView.contentInset = edgeInsets
        
        scrollView.scrollIndicatorInsets = edgeInsets
        
        touchView.removeFromSuperview()
        
        scrollView.isScrollEnabled = false
    }
    
    private func disappearKeyboardEvent(){
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    private func addTapGestureRecognizer(){
        
        //Add tap gesture recognizer in close image
        
        closeImage.isUserInteractionEnabled = true
        
        let imageTGR = UITapGestureRecognizer(target: self, action: #selector(dismissView))

        closeImage.addGestureRecognizer(imageTGR)
        
        // Add tap gesture recognizer in country code field
        
        countryCodeField.isUserInteractionEnabled = true
        
        let fieldTGR = UITapGestureRecognizer(target: self, action: #selector(showCountryCodePicker))
        
        countryCodeField.addGestureRecognizer(fieldTGR)
        
    }
    
    @objc private func showCountryCodePicker(){
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: { [weak self] in
            
            guard let strongeSelf = self else { return }
            
            strongeSelf.bottomViewConstraint.constant = -0
            
            strongeSelf.view.layoutIfNeeded()
            
        }, completion: nil)
        
    
    }
    
    @objc private func cancelPressed(){
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: { [weak self] in
            
            guard let strongeSelf = self else { return }
            
            strongeSelf.bottomViewConstraint.constant = 261
            
            strongeSelf.view.layoutIfNeeded()
            
        }, completion: nil)
        
    }
    
    @objc private func donePressed(){
        
        guard let code = countryCode else {
            
            countryCodeField.text = ""
            
            return
            
        }
        
        countryCodeField.text = code
        
        contactField.becomeFirstResponder()
        
        pickerViewBackground.removeFromSuperview()
        
        countryCode = nil
        
    }
    
    @objc private func changeMobileNoFormFV(){
        showCountryCodePicker()
    }
    
    fileprivate func getDefaultJWTToken() {
        let userDefault = UserDefaults.standard
        guard let token = userDefault.object(forKey: "JWT_TOKEN") as? String else {
            return
        }
        self.jwt_Token = token
    }
    
    
    fileprivate func presentVerificationVC(_ profile : Profile){
        
        let verificationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "MOBILE_VERIFIY_SCREEN") as MobileVerificationViewController
        
        verificationVC.modalPresentationStyle = .fullScreen
        
        verificationVC.modalTransitionStyle = .crossDissolve
        
        verificationVC.profile = profile
        
        verificationVC.delegate = self
        
        self.present(verificationVC, animated: true, completion: nil)
    }
    
    @IBAction func checkValiedEmail() {
        //emailField.setupRightImage(imageName: "envelope.fill", color:.red)
        if let emailAddress = emailField.text {
            
            if isValidEmail(emailAddress) {
                registerMV.checkEmail(emailAddress)
            } else {
                emailField.setupRightImage(imageName: "envelope.fill", color: UIColor.red)
                presentPopOver("Enter valid Email Address", emailField)
            }
            
        }
    }
    
    @IBAction func checkUserNameAvailability() {
        if let userName = userNameField.text {
            registerMV.checkUserName(userName)
        }
    }
    
    @IBAction func checkPassword(_ sender: UITextField) {
        
        if let password = sender.text,4 < password.count && 8 > password.count {
            passwordField.setupRightImage(imageName: "key.fill", color: .orange)
        } else if isValidPassword(testStr: sender.text) {
            passwordField.setupRightImage(imageName: "checkmark", color: .green)
        } else {
            passwordField.setupRightImage(imageName: "key.fill", color: .red)
        }
    }
    
    @IBAction func textEditDidBegining(_ sender: UITextField) {
        sender.rightView = nil
        sender.clearsOnBeginEditing = true
        sender.setTintColor(.darkGray)
    }
    
    @IBAction func repasswordDidEnd(_ sender: UITextField) {
        guard let password = passwordField.text else { return }
        
        if let rePassword = rePasswordField.text, rePassword.count > 0 && !password.elementsEqual(rePassword){
            rePasswordField.setupRightImage(imageName: "exclamationmark.triangle.fill", color: .red)
        }
    }
    
    fileprivate func isValidPassword(testStr:String?) -> Bool {
        guard testStr != nil else { return false }
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,}")
        return passwordTest.evaluate(with: testStr)
    }
    
    fileprivate func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    fileprivate func presentPopOver(_ message : String,_ field : UITextField){
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "POP_VIEW") as! AlertPopOverViewController
        controller.getMessage = message
        controller.modalPresentationStyle = .popover
        controller.preferredContentSize = CGSize(width: 250 , height: 50)
        
        let popover = controller.popoverPresentationController
        popover?.delegate = self
        popover?.permittedArrowDirections = .down
        popover?.sourceView = field
        popover?.sourceRect = field.bounds
        popover?.backgroundColor = UIColor.lightGray
        self.present(controller, animated: true, completion: nil)
    }
}

extension RegisterViewController : UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countryCodeList.count
    }
    
}

extension RegisterViewController : UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        
        return countryCodeList[row]
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        countryCode = String(countryCodeList[row].split(separator: " ")[0])
    }
    
}

extension RegisterViewController : UITextFieldDelegate {
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}

extension RegisterViewController : RegistrationDelegate {
    
    func getProfileInfo(_ profile: Profile?) { }
    
    func getUniqueFieldResult(_ field: String, _ result: Bool) {
        switch field {
        case "email":
            if result == false{
                self.emailField.setupRightImage(imageName: "envelope.fill", color: UIColor.red)
                self.presentPopOver("Email already exists.", emailField)
            } else {
                self.emailField.rightView = nil
            }
            break
            
        case "user_name":
            if result == false{
                self.userNameField.setupRightImage(imageName: "person.fill", color: UIColor.red)
                self.presentPopOver("UserName already exists.", userNameField)
            } else {
                self.emailField.rightView = nil
            }
            break
            
        default:
            break
        }
    }
    
    
    func getResponse(_ response: ApiResponse) {
        
    }
}

extension RegisterViewController : UIPopoverPresentationControllerDelegate{
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

extension RegisterViewController : MobileVerifyDelegate {
    
    func clearRegistrationFields() {
        firstNameField.text = nil
        lastNameField.text = nil
        countryCodeField.text = nil
        contactField.text = nil
        emailField.text = nil
        userNameField.text = nil
        passwordField.text = nil
        rePasswordField.text = nil
        countryCode = nil
    }
}
