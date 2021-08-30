//
//  HomeCategoryViewCell.swift
//  GedaratamaMalu
//
//  Created by Ashan Don on 8/30/21.
//

import UIKit

class HomeCategoryViewCell: UICollectionViewCell {

    @IBOutlet fileprivate weak var titleLabel: UILabel!
    @IBOutlet fileprivate weak var categoryCollectionView: UICollectionView!
    
    fileprivate var categoryList : [Category] = [Category]()
    fileprivate let colorList : [UIColor] = [
        UIColor(named: "Category_Color_1")!,
        UIColor(named: "Category_Color_2")!,
        UIColor(named: "Category_Color_3")!,
        UIColor(named: "Category_Color_4")!
    ]
    fileprivate var categoryMV : CategoryModelView!
    
    var firstName : String = String(){
        didSet {
            self.titleLabel.text = "What would you like to \norder, \(firstName)?"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        createLayout()
        
        let jwtToken = UserDefaults.standard.object(forKey: "JWT_TOKEN") as! String
        categoryMV = CategoryModelView(JwtToken: jwtToken)
        
        
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        categoryMV.delegate = self
        
        categoryCollectionView.register(UINib(nibName: "CategoryViewCell", bundle: nil), forCellWithReuseIdentifier: "CATEGORY_CELL")
        
        
        categoryMV.getAllCategoris()
    }
    
    fileprivate func createLayout(){
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = CGFloat(18)
        self.titleLabel.font = UIFont(name: "LucidaGrande", size: CGFloat(17))
        self.titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        categoryCollectionView.layer.isOpaque = false
    }

}

//MARK:- UICollectionViewDelegateFlowLayout
extension HomeCategoryViewCell : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: (100) , height: 100)
        } else {
            return CGSize(width: 100 , height: 100)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        } else {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(10)
    }
}

//MARK:- UICollectionViewDelegate,UICollectionViewDataSource
extension HomeCategoryViewCell : UICollectionViewDelegate,UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return categoryList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let defaultCell = categoryCollectionView.dequeueReusableCell(withReuseIdentifier: "CATEGORY_CELL", for: indexPath) as! CategoryViewCell
            defaultCell.categoryName = "All"
            defaultCell.categoryImage = "Category_All"
            defaultCell.cellBackgroundColor = colorList[0]
            return defaultCell
        } else {
            let defaultCell = categoryCollectionView.dequeueReusableCell(withReuseIdentifier: "CATEGORY_CELL", for: indexPath) as! CategoryViewCell
            let details = categoryList[indexPath.row] as Category
            defaultCell.categoryName = details.name!
            defaultCell.categoryImage = "Category_\(details.name!)"
            defaultCell.cellBackgroundColor = colorList[indexPath.row + 1]
            return defaultCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            NotificationCenter.default.post(name: Notification.Name("GET_PRODUCT_BY_CID"), object: 0)
        } else {
            let details = categoryList[indexPath.row] as Category
            NotificationCenter.default.post(name: Notification.Name("GET_PRODUCT_BY_CID"), object: details.id!)
        }
        
    }
}

//MARK:- CategoryDelegate
extension HomeCategoryViewCell : CategoryDelegate {
    
    func getAllCategoris(CategoryList list: [Category]) {
        
        DispatchQueue.main.async {
            self.categoryList = list
            self.categoryCollectionView.reloadData()
        }
    }
    
    
}
