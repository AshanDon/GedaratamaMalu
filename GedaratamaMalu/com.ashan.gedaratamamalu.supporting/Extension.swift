//
//  Extension.swift
//  GedaratamaMalu
//
//  Created by Ashan Don on 1/5/21.
//

import UIKit

extension UITextField {
    
    func setLeftPaddingPoints(_ amount:CGFloat){
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        
        self.leftView = paddingView
        
        self.leftViewMode = .always
        
    }
    
    func setRightPaddingPoints(_ amount:CGFloat) {
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        
        self.rightView = paddingView
        
        self.rightViewMode = .always
        
    }
    
    func setTintColor(_ color : UIColor){
        
        self.tintColor = color
        
    }
    
    func setBackgroundColor(){
        
        self.backgroundColor = .secondarySystemBackground
        
    }
    
    func setBottomBorder(backgroundColor: UIColor,shadowColor : UIColor){
        
        self.borderStyle = .none
        
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = shadowColor.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width,   width:  self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
        
    }
    
    func setupRightImage(imageName:String, color:UIColor){
        let imageView = UIImageView(frame: CGRect(x: -7, y: 0, width: 25, height: 20))
        imageView.image = UIImage(systemName: imageName)
        let imageContainerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: 20))
        imageContainerView.addSubview(imageView)
        rightView = imageContainerView
        rightViewMode = .always
        self.tintColor = color
    }
    
    func setupRightCustomImage(imageName:String, color:UIColor){
        let imageView = UIImageView(frame: CGRect(x: -7, y: 0, width: 25, height: 20))
        imageView.image = UIImage(named: imageName)
        let imageContainerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: 20))
        imageContainerView.addSubview(imageView)
        rightView = imageContainerView
        rightViewMode = .always
        self.tintColor = color
    }
    
    func setupRightCustomImage(imageName:String, color:UIColor, width:CGFloat, height:CGFloat){
        let imageView = UIImageView(frame: CGRect(x: -7, y: 0, width: width, height: height))
        imageView.image = UIImage(named: imageName)
        let imageContainerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        imageContainerView.addSubview(imageView)
        rightView = imageContainerView
        rightViewMode = .always
        self.tintColor = color
    }
    
    func setupBottomLine(lineHeight : CGFloat, lineColor : UIColor){
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: self.bounds.height - lineHeight, width: self.bounds.width, height: lineHeight)
        bottomLine.backgroundColor = lineColor.cgColor
                
        self.borderStyle = UITextField.BorderStyle.none
        self.layer.addSublayer(bottomLine)
    }
    
    @IBInspectable var doneAccessory: Bool{
        get{
            return self.doneAccessory
        }
        set (hasDone) {
            if hasDone{
                addDoneButtonOnKeyboard()
            }
        }
    }
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction()
    {
        self.resignFirstResponder()
    }
}

extension UIView{
    
    func applyViewShadow(color : UIColor, alpha : Float, x : CGFloat, y : CGFloat, blur : CGFloat, spread : CGFloat){
        
        layer.masksToBounds = false
        
        layer.shadowColor = color.cgColor
        
        layer.shadowOpacity = alpha
        
        layer.shadowOffset = CGSize(width: x, height: y)
        
        layer.shadowRadius = blur / UIScreen.main.scale
        
        if spread == 0 {
            
            layer.shadowPath = nil
            
        } else {
            
            let dx = -spread
            
            let rect = bounds.insetBy(dx: dx, dy: dx)
            
            layer.shadowPath = UIBezierPath(rect: rect).cgPath
            
        }
    }
    
    func setRoundCorners(corners : UIRectCorner,redius : CGFloat){
        
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: redius, height: redius))
        
        let mask = CAShapeLayer()
        
        mask.path = path.cgPath
        
        self.layer.mask = mask
        
    }
}

extension String{
    func convertDoubleToCurrency() -> String{
        let amount1 = Double(self)
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale(identifier: "si_LK")
        return numberFormatter.string(from: NSNumber(value: amount1!))!
    }
}

extension Date {
    func getFormattedDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.date(from: dateFormatter.string(from: Date()))!
    }
}
