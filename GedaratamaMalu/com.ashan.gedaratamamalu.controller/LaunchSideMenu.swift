//
//  LaunchSideMenu.swift
//  GedaratamaMalu
//
//  Created by Ashan Don on 1/23/21.
//

import UIKit

protocol SideMenuDelegate : class {
    func didPressedLogOut()
    func didPressedAddress()
}

class LaunchSideMenu : NSObject {
    
    private let list : [String] = ["Address","Account Details","Log Out"]
    private var window = UIWindow()
    private var sideMenuWidth : CGFloat = 0.0
    public weak var delegate : SideMenuDelegate?
    
    private lazy var blackView : UIView = {
        let bView = UIView()
        bView.frame = window.frame
        bView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        bView.alpha = 0
        let bVGR = UITapGestureRecognizer(target: self, action: #selector(moveRightMenuView))
        bView.addGestureRecognizer(bVGR)
        return bView
    }()
    
    private lazy var sideMenuBackgroundView : UIView = {
        let menuView = UIView()
        menuView.backgroundColor = .clear
        menuView.frame = CGRect(x: window.frame.width, y: 0.0, width: sideMenuWidth, height: window.frame.height)
        //Added subvieew
        menuView.addSubview(separetorView)
        menuView.addSubview(menuBackgroundView)
        return menuView
    }()
    
    private lazy var separetorView : UIView = {
        let sView = UIView()
        sView.translatesAutoresizingMaskIntoConstraints = false
        sView.backgroundColor = UIColor(named: "Button_Background_Color")!
        sView.layer.cornerRadius = 5
        return sView
    }()
    
    private lazy var menuBackgroundView : UIView = {
        let mView = UIView()
        mView.translatesAutoresizingMaskIntoConstraints = false
        mView.backgroundColor = UIColor(named: "Button_Background_Color")
        mView.layer.masksToBounds = false
        mView.layer.cornerRadius = 32.0
        mView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        //Added subview
        mView.addSubview(profileImageView)
        mView.addSubview(companyTitleLabel)
        mView.addSubview(profileNameLabel)
        mView.addSubview(menuList)
        return mView
    }()
    
    private lazy var profileImageView : UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "Account_Tab_Bar_Icon"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = imageView.frame.height / 2
        return imageView
    }()
    
    private lazy var companyTitleLabel : UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "GedaratamaMalu.lk"
        label.textAlignment = .left
        label.textColor = UIColor(named: "Black_Color")!
        label.font = UIFont(name: "Lucida Grande Bold", size: 16)
        return label
    }()
    
    private lazy var profileNameLabel : UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Alma Malmberg"
        label.textAlignment = .left
        label.textColor = UIColor(named: "White_Color")!
        label.font = UIFont(name: "Lucida Grande Regular", size: 14)
        return label
    }()
    
    private lazy var menuList : UITableView = {
       let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isUserInteractionEnabled = true
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.isMultipleTouchEnabled = false
        tableView.allowsSelection = true
        
        tableView.register(UINib(nibName: "MenuViewCell", bundle: nil), forCellReuseIdentifier: "MENU_LIST_ROW")
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    
//    override init() {
//        super.init()
//
//    }
    
    public func setupBackgroundView(){

        if let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first {
            self.window = window
        }
        
        sideMenuWidth = (window.frame.width / 2) + 70
        
        window.addSubview(blackView)
        window.addSubview(sideMenuBackgroundView)
        
        setMenuListViewConstraint()
        
        moveLeftMenuView()
        
        
    }
    
    private func setMenuListViewConstraint(){
        
        let constraint : [NSLayoutConstraint] = [
            //SeparetorView Constraint
            separetorView.widthAnchor.constraint(equalToConstant: 10),
            separetorView.heightAnchor.constraint(equalToConstant: 60),
            separetorView.leftAnchor.constraint(equalTo: sideMenuBackgroundView.leftAnchor, constant: 0),
            separetorView.centerYAnchor.constraint(equalTo: sideMenuBackgroundView.centerYAnchor),
            
            //MenuBackgroundView Constraint
            menuBackgroundView.topAnchor.constraint(equalTo: sideMenuBackgroundView.safeAreaLayoutGuide.topAnchor, constant: 0),
            menuBackgroundView.leftAnchor.constraint(equalTo: separetorView.rightAnchor, constant: 10),
            menuBackgroundView.bottomAnchor.constraint(equalTo: sideMenuBackgroundView.bottomAnchor, constant: 0),
            menuBackgroundView.rightAnchor.constraint(equalTo: sideMenuBackgroundView.rightAnchor, constant: 0),
            
            //ProfileImageView Constraint
            profileImageView.widthAnchor.constraint(equalToConstant: 50.0),
            profileImageView.heightAnchor.constraint(equalToConstant: 50.0),
            profileImageView.topAnchor.constraint(equalTo: menuBackgroundView.topAnchor, constant: 12),
            profileImageView.leftAnchor.constraint(equalTo: menuBackgroundView.leftAnchor, constant: 12),
            
            //CompanyTitleLabel constraint
            companyTitleLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 172.0),
            companyTitleLabel.heightAnchor.constraint(equalToConstant: 25.0),
            companyTitleLabel.topAnchor.constraint(equalTo: menuBackgroundView.topAnchor, constant: 11.0),
            companyTitleLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 5.0),
            companyTitleLabel.rightAnchor.constraint(equalTo: menuBackgroundView.rightAnchor, constant: 5.0),
            
            //ProfileNameLabel constraint
            profileNameLabel.topAnchor.constraint(equalTo: companyTitleLabel.bottomAnchor, constant: 5.0),
            profileNameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 5.0),
            profileNameLabel.rightAnchor.constraint(equalTo: menuBackgroundView.rightAnchor, constant: 5.0),
            
            //Menulist constraint
            menuList.heightAnchor.constraint(equalToConstant: 200.0),
            menuList.topAnchor.constraint(equalTo: profileNameLabel.bottomAnchor, constant: 20.0),
            menuList.leftAnchor.constraint(equalTo: menuBackgroundView.leftAnchor, constant: 12.0),
            menuList.rightAnchor.constraint(equalTo: menuBackgroundView.rightAnchor, constant: 0.0)
            
        ]
        
        sideMenuBackgroundView.addConstraints(constraint)
        
    }
    
    private func moveLeftMenuView(){
        
        let x : CGFloat = window.frame.width - sideMenuWidth
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: { [weak self] in
            guard let strongeSelf = self else { return }
            strongeSelf.blackView.alpha = 1
            strongeSelf.sideMenuBackgroundView.frame = CGRect(x: x, y: 0.0, width: strongeSelf.sideMenuWidth, height: strongeSelf.sideMenuBackgroundView.frame.height)
        }, completion: nil)
        
    }
    
    @objc private func moveRightMenuView(){
        //guard let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else { return }
        let sideMenuWidth : CGFloat = (window.frame.width / 2) + 70
        UIView.animate(withDuration: 0.5) { [weak self] in
            guard let strongeSelf = self else { return }
            strongeSelf.blackView.alpha = 0
            strongeSelf.sideMenuBackgroundView.frame = CGRect(x: strongeSelf.window.frame.width, y: 0.0, width: sideMenuWidth, height: strongeSelf.window.frame.height)
        }
    }
    
    private func addressPressed(){
        moveRightMenuView()
        delegate?.didPressedAddress()
    }
    
    private func accountDetailsPressed(){
        print("Account Details Button Done!")
    }
    
    private func logOutPressed(){
        moveRightMenuView()
        delegate?.didPressedLogOut()
    }
}

extension LaunchSideMenu : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 41.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            addressPressed()
        case 1:
            accountDetailsPressed()
        case 2:
            logOutPressed()
        default:
            break
        }
    }
}

extension LaunchSideMenu : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let menuViewCell = menuList.dequeueReusableCell(withIdentifier: "MENU_LIST_ROW", for: indexPath) as! MenuViewCell
        menuViewCell.setItemName = list[indexPath.item] as String
        menuViewCell.selectionStyle = .none
        return menuViewCell
    }
}
