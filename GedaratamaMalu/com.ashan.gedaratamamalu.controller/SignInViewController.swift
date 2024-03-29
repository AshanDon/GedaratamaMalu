//
//  SignInViewController.swift
//  GedaratamaMalu
//
//  Created by Ashan Don on 1/4/21.
//

import UIKit
import NVActivityIndicatorView

class SignInViewController: UIViewController {

    @IBOutlet weak var backgroundImageView : UIImageView!
    
    @IBOutlet weak var userNameField : UITextField!
    
    @IBOutlet weak var passwordField : UITextField!
    
    @IBOutlet weak var signInButton : UIButton!
    
    @IBOutlet weak var registerButton : UIButton!
    
    @IBOutlet weak var scrollView : UIScrollView!
    
    private var moveLogoAnimator : UIViewPropertyAnimator!
    
    private var logoIVBottomConstraint : NSLayoutConstraint!
    
    fileprivate var authViewMode : AuthenticationViewModel!
    
    private lazy var logoImageView : UIImageView = {
       
        let imageView = UIImageView(image: UIImage(named: "Star_Icon")!)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.layer.cornerRadius = imageView.frame.height / 2
        
        return imageView
        
    }()
    
    private lazy var touchView : UIView = {
        
        let tv = UIView()
        
        tv.frame = backgroundImageView.bounds
        
        tv.isUserInteractionEnabled = true
        
        let viewTGR = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        tv.addGestureRecognizer(viewTGR)
        
        return tv
    }()
    
    private lazy var animationBlackView : UIView = {
       let bView = UIView()
        bView.isUserInteractionEnabled = true
        bView.frame = view.bounds
        bView.backgroundColor = UIColor(white: 0, alpha: 0.7)
        return bView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.addSubview(logoImageView)
        
        NSLayoutConstraint.activate([
            logoImageView.widthAnchor.constraint(equalToConstant: CGFloat(99.0)),
            logoImageView.heightAnchor.constraint(equalToConstant: CGFloat(99.0)),
            logoImageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor)
            
        ])
        
        logoIVBottomConstraint = logoImageView.bottomAnchor.constraint(equalTo: userNameField.topAnchor, constant: 30)
        
        view.addConstraint(logoIVBottomConstraint)
        
        scrollView.transform = CGAffineTransform(scaleX: 0, y: 0)
        
        userNameField.alpha = CGFloat(0)
        
        passwordField.alpha = CGFloat(0)
        
        signInButton.alpha = CGFloat(0)
        
        registerButton.alpha = CGFloat(0)
        
        userNameField.delegate = self
        
        passwordField.delegate = self
        
        authViewMode = AuthenticationViewModel()
        authViewMode.authDelegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        changeComponant()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIView.animate(withDuration: 0.8, delay: 1, usingSpringWithDamping: 0.5, initialSpringVelocity: 2, options: .curveEaseInOut) { [weak self] in
            
            guard let strongeSelf = self else { return }
            
            strongeSelf.scrollView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            
        } completion: { (success) in
           
            self.setupMoveLogoAnimator()
            
            self.moveLogoAnimator.startAnimation()
        }
        
        registedKeyboardEvent()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        disappearKeyboardEvent()
    }
    
    private func changeComponant(){
        
        // UIImageView
        backgroundImageView.layer.opacity = Float(72)
        
        backgroundImageView.alpha = 0.7
        
        //UIButton
        signInButton.layer.cornerRadius = signInButton.frame.height / 2
        
        registerButton.layer.cornerRadius = registerButton.frame.height / 2
        
        //UITextField
        userNameField.backgroundColor = .secondarySystemBackground
        
        passwordField.backgroundColor = .secondarySystemBackground
        
        userNameField.attributedPlaceholder = NSAttributedString(string: "User Name", attributes: [
            
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)
            
        ])
        
        passwordField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [
        
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)
        
        ])
        
        userNameField.tintColor = UIColor.darkGray
        
        passwordField.tintColor = UIColor.darkGray
        
        userNameField.setLeftPaddingPoints(10)
        
        userNameField.setRightPaddingPoints(10)
        
        passwordField.setLeftPaddingPoints(10)
        
        passwordField.setRightPaddingPoints(10)
        
    }
    
    @objc private func dismissKeyboard(){
        
        view.endEditing(true)
        
    }
    
    private func registedKeyboardEvent(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHidden(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    private func disappearKeyboardEvent(){
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    @objc private func keyboardWillShow(_ sender : Notification){
        
        scrollView.isScrollEnabled = true
        
        UIView.animate(withDuration: 0.1) { [weak self] in

            guard let strongeSelf = self else { return }

            guard let keyboardSize = (sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
                
                return
                
            }
            
            let edgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height , right: 0.0)
            
            strongeSelf.scrollView.contentInset = edgeInsets
            
            strongeSelf.scrollView.scrollIndicatorInsets = edgeInsets
            
            strongeSelf.view.addSubview(strongeSelf.touchView)

        }
    }
    
    @objc private func keyboardWillHidden(_ sender : Notification){
        
        UIView.animate(withDuration: 0.1) { [weak self] in

            guard let strongeSelf = self else { return }
            
            let edgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
            
            strongeSelf.scrollView.contentInset = edgeInsets
            
            strongeSelf.scrollView.scrollIndicatorInsets = edgeInsets
            
            strongeSelf.touchView.removeFromSuperview()
            
            strongeSelf.scrollView.isScrollEnabled = false
        }
        
        
    }
    
    private func presentedAlert(_ message : String){
        
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            
            alert.dismiss(animated: true, completion: nil)
            
        }
        
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction private func loginButtonPressed(){
    
        if userNameField.text!.isEmpty || passwordField.text!.isEmpty {
            
            presentedAlert("User Name or password is Empty")
            
        } else {
            if let userName = userNameField.text, let password = passwordField.text {
                authViewMode.getUserProfile(userName, password)
            }
        }
    }
    
    @IBAction private func registerButtonPressed(){
        
        let registerVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "REGISTER_SCREEN") as RegisterViewController
        
        registerVC.modalTransitionStyle = .coverVertical
        
        registerVC.modalPresentationStyle = .fullScreen
        
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = .moveIn
        transition.subtype = .fromTop
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        self.view.window!.layer.add(transition, forKey: kCATransition)
        
        self.present(registerVC, animated: true, completion: nil)
        
    }
    
    private func setupMoveLogoAnimator(){
        
        moveLogoAnimator = UIViewPropertyAnimator(duration: 2.0, curve: .easeOut, animations: nil)
        
        moveLogoAnimator.addAnimations({ [weak self] in
            
            guard let strongeSelf = self else { return }
            
            strongeSelf.logoImageView.frame.origin.y = 130
            
        }, delayFactor: 0.2)
        
        moveLogoAnimator.addAnimations({ [weak self] in
            
            guard let strongeSelf = self else { return }
            
            strongeSelf.userNameField.alpha = CGFloat(1.0)
            
        }, delayFactor: 0.6)
        
        moveLogoAnimator.addAnimations({ [weak self] in
            
            guard let strongeSelf = self else { return }
            
            strongeSelf.passwordField.alpha = CGFloat(1.0)
            
        }, delayFactor: 0.7)
        
        moveLogoAnimator.addAnimations({ [weak self] in
            
            guard let strongeSelf = self else { return }
            
            strongeSelf.signInButton.alpha = CGFloat(1.0)
            
            strongeSelf.registerButton.alpha = CGFloat(1.0)
            
        }, delayFactor: 0.8)
        
        moveLogoAnimator.addCompletion { (position) in

            self.logoIVBottomConstraint.constant = -30

            self.view.addConstraint(self.logoIVBottomConstraint)
            self.view.layoutIfNeeded()
        }
    }
    
    private func presentTabBarVC(){
        let tabBarVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "TAB_BAR_SCREEN") as! TabBarViewController
        
        tabBarVC.modalPresentationStyle = .fullScreen
        tabBarVC.modalTransitionStyle = .coverVertical
        
        if let window = UIApplication.shared.windows.first {
            
            let transition = CATransition()
            transition.duration = 0.5
            transition.type = .moveIn
            transition.subtype = .fromLeft
            transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            window.layer.add(transition, forKey: kCATransition)
            
            window.rootViewController = tabBarVC
            window.makeKeyAndVisible()
            
            let userDefault = UserDefaults.standard
            userDefault.set(true, forKey: "IS_LOGGING")
        }
    }
    
    fileprivate func presentAnimationView(){
        
        view.addSubview(animationBlackView)
        
        NSLayoutConstraint.activate([
            animationBlackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            animationBlackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            animationBlackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            animationBlackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0)
        ])
        
        //setup animation
        
        let activityIndicatorView = NVActivityIndicatorView(frame: .zero, type: .orbit, color: UIColor(named: "Intraduction_Background"), padding: 0)
        
        animationBlackView.addSubview(activityIndicatorView)
        
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicatorView.widthAnchor.constraint(equalToConstant: 200.0),
            activityIndicatorView.heightAnchor.constraint(equalToConstant: 200.0),
            activityIndicatorView.centerXAnchor.constraint(equalTo: animationBlackView.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: animationBlackView.centerYAnchor)
        ])
        
        activityIndicatorView.startAnimating()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5){
            activityIndicatorView.stopAnimating()
            self.presentTabBarVC()
        }
    }
}

extension SignInViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.endEditing(true)
        
        return true
    }
}

extension SignInViewController : AuthenticationDelegate {
    
    func getTokenInfo(_ token: String, _ userName: String, _ password: String) {
        let userDefault = UserDefaults.standard
        
        userDefault.set(token, forKey: "JWT_TOKEN")
        userDefault.set(userName, forKey: "USER_NAME")
        userDefault.set(password, forKey: "PASSWORD")
        
        presentAnimationView()
    }
    
    func getSignInError(_ message : String) {
        
        let alertController = UIAlertController(title: "Warning", message: message, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            self.userNameField.text = nil
            self.userNameField.becomeFirstResponder()
            self.passwordField.text = nil
        }
        
        alertController.addAction(alertAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
}
