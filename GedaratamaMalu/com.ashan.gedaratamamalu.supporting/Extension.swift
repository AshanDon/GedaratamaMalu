//
//  Extension.swift
//  GedaratamaMalu
//
//  Created by Ashan Don on 1/5/21.
//

import UIKit
import MapKit

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

extension MKMapView{
    /// when we call this function, we have already added the annotations to the map, and just want all of them to be displayed.
    func fitAll() {
        var zoomRect            = MKMapRect.null;
        for annotation in annotations {
            let annotationPoint = MKMapPoint(annotation.coordinate)
            let pointRect       = MKMapRect(x: annotationPoint.x, y: annotationPoint.y, width: 0.01, height: 0.01);
            zoomRect            = zoomRect.union(pointRect);
        }
        setVisibleMapRect(zoomRect, edgePadding: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5), animated: false)
    }
    
    /// we call this function and give it the annotations we want added to the map. we display the annotations if necessary
    func fitAll(in annotations: [MKAnnotation], andShow show: Bool) {
        var zoomRect:MKMapRect  = MKMapRect.null
        
        for annotation in annotations {
            let aPoint          = MKMapPoint(annotation.coordinate)
            let rect            = MKMapRect(x: aPoint.x, y: aPoint.y, width: 0.1, height: 0.1)
            
            if zoomRect.isNull {
                zoomRect = rect
            } else {
                zoomRect = zoomRect.union(rect)
            }
        }
        if(show) {
            addAnnotations(annotations)
        }
        setVisibleMapRect(zoomRect, edgePadding: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5), animated: true)
    }

}

extension UIApplication {
    
    func suspendApplication(){
        UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            exit(0)
        }
    }
    
}
