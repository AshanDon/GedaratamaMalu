//
//  TabBarViewController.swift
//  GedaratamaMalu
//
//  Created by Ashan Don on 1/13/21.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let selectedColor   = UIColor(named: "White_Color")!
        let unselectedColor = UIColor.black

        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: unselectedColor], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: selectedColor], for: .selected)
    }
    
}
