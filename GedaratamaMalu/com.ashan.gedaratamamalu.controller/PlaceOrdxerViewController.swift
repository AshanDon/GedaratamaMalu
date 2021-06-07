//
//  PlaceOrdxerViewController.swift
//  GedaratamaMalu
//
//  Created by Ashan Don on 5/26/21.
//

import UIKit

class PlaceOrderViewController: UIViewController {

    //@IBOutlet weak var customerInfoView: UIView!
    
    fileprivate lazy var backButton : UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 44))
        button.setTitle(" Back", for: .normal)
        button.setImage(UIImage(named: "Arrow_Icon"), for: .normal)
        button.setTitleColor(UIColor(named: "Black_Color"), for: .normal)
        button.addTarget(self, action: #selector(backButtonDidPressed), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupViewLayout()
    }

    fileprivate func setupViewLayout(){
        
       // self.navigationController!.navi
        //customerInfoView
        
//        customerInfoView.layer.cornerRadius = 28
//        customerInfoView.layer.borderWidth = 2
//        customerInfoView.layer.borderColor = UIColor(named: "LightBlack_Color-1")!.cgColor
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
}
