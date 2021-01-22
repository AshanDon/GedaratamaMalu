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
