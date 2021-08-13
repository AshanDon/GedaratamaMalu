//
//  ShowCustomAlertMessage.swift
//  GedaratamaMalu
//
//  Created by Ashan Don on 6/19/21.
//

import UIKit

class ShowCustomAlertMessage: UIView{

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(white: 0, alpha: 0.5)
        self.addSubview(errorAletView)
        
        setupLayoutConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate lazy var errorAletView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "White_Color")
        view.layer.cornerRadius = CGFloat(20)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(errorImageView)
        view.addSubview(errorMessageLabel)
        view.addSubview(errorButton)
        return view
    }()
    
    lazy var errorImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var errorMessageLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor(named: "Black_Color")
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var errorButton : UIButton = {
        let button = UIButton()
        button.titleLabel?.textAlignment = .center
        button.setTitle("", for: .normal)
        button.titleLabel?.attributedText = NSAttributedString(string: "", attributes: [
                                                                NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 21)])
        button.titleLabel?.tintColor = UIColor(named: "White_Color")
        button.backgroundColor = UIColor(named: "Intraduction_Background")
        button.layer.cornerRadius = 18
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    fileprivate func setupLayoutConstraint(){
        NSLayoutConstraint.activate([
            //errorAletView layout constraint
            errorAletView.widthAnchor.constraint(equalToConstant: 260),
            errorAletView.heightAnchor.constraint(greaterThanOrEqualToConstant: 283),
            errorAletView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            errorAletView.centerYAnchor.constraint(equalTo: self.centerYAnchor),

            //errorImageView layout constraint
            errorImageView.widthAnchor.constraint(equalToConstant: 200),
            errorImageView.heightAnchor.constraint(equalToConstant: 163),
            errorImageView.topAnchor.constraint(equalTo: errorAletView.topAnchor, constant: 20),
            errorImageView.centerXAnchor.constraint(equalTo: errorAletView.centerXAnchor),

            //errorMessageLabel layout constraint
            errorMessageLabel.widthAnchor.constraint(equalToConstant: 236),
            errorMessageLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 33),
            errorMessageLabel.topAnchor.constraint(equalTo: errorImageView.bottomAnchor, constant: 5),
            errorMessageLabel.centerXAnchor.constraint(equalTo: errorAletView.centerXAnchor),

            //errorButton layout constraint
            errorButton.widthAnchor.constraint(lessThanOrEqualToConstant: 192),
            errorButton.heightAnchor.constraint(equalToConstant: 36),
            errorButton.topAnchor.constraint(equalTo: errorMessageLabel.bottomAnchor, constant: 13),
            errorButton.leftAnchor.constraint(equalTo: errorAletView.leftAnchor, constant: 34),
            errorButton.bottomAnchor.constraint(equalTo: errorAletView.bottomAnchor, constant: -13),
            errorButton.rightAnchor.constraint(equalTo: errorAletView.rightAnchor, constant: -34)
        ])
    }
}

