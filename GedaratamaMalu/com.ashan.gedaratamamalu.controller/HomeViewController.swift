//
//  HomeViewController.swift
//  GedaratamaMalu
//
//  Created by Ashan Don on 1/13/21.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var backgroundView: UIImageView!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var separetorView: UIView!
    @IBOutlet weak var cartProductCount: UILabel!
    @IBOutlet weak var productSearchField: UISearchBar!
    @IBOutlet weak var productView: UICollectionView!
    @IBOutlet weak var notifiBackgroundView: UIView!
    
    @IBOutlet weak var navigationViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var separetorTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var middleViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var notifiViewTopConstraint: NSLayoutConstraint!
    
    fileprivate var productList : [Product] = [Product]()
    fileprivate var cartList : [Product] = [Product]()
    
    private var notifiMoveUpAnimation : UIViewPropertyAnimator!
    private var dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("TemparyCartList.plist")
    
    private lazy var touchView : UIView = {
       
        let tView = UIView()
        
        tView.isUserInteractionEnabled = true
        tView.frame = view.bounds
        let viewTGR = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tView.addGestureRecognizer(viewTGR)
        
        return tView
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        modifiyViewComponent()
        
        self.productView.register(UINib(nibName: "ProductViewCell", bundle: nil), forCellWithReuseIdentifier: "PRODUCT_CELL")
        
        productView.delegate = self
        
        productView.dataSource = self
        
        loadProductList()
        
        productSearchField.delegate = self
        
        //Pendding cart item count
        getPenddingCartItem()
        
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {

        let y = targetContentOffset.pointee.y

        if y > 0.0 {
            topViewMoveUP()
        } else {
            topViewMoveDown()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        registerForKeyboardEvent()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        disappearFromKeyboardEvent()
        
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(cartList)
            try data.write(to: dataFilePath!)
            
            
        } catch {
            print("Error encoding cart list \(error)")
        }
        
    }
    
    private func modifiyViewComponent(){
        
        backgroundView.layer.opacity = Float(72)
        
        backgroundView.alpha = 0.7
        
        navigationView.layer.masksToBounds = true
        
        navigationView.layer.cornerRadius = 30.0
        
        navigationView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
        separetorView.layer.cornerRadius = separetorView.frame.height / 2
        
        separetorView.layer.borderWidth = 1
        
        separetorView.layer.borderColor = UIColor(named: "SeparetorBorder_Color")!.cgColor
        
        productSearchField.searchBarStyle = .minimal
        
        productSearchField.searchTextField.backgroundColor = UIColor(named: "NavigationView_Background_Color")!
        
        productView.backgroundColor = .none
        
        notifiBackgroundView.layer.cornerRadius = notifiBackgroundView.frame.height / 2
        notifiBackgroundView.layer.borderColor = UIColor(named: "White_Color")!.cgColor
        notifiBackgroundView.layer.borderWidth = 1
    }

    private func loadProductList(){
        
        let product_1 = Product(productId: 1, productImage: "Fish 1", catogaryName: "Fish", productName: "Alagoduwa (අලගොඩුවා)",description: "Imported", productPrice: 600.00, productQty: 1)
        
        let product_2 = Product(productId: 2, productImage: "Fish 2", catogaryName: "Fish", productName: "Balaya (බල මාළු)",description: "Local", productPrice: 650.00, productQty: 1)
        
        let product_3 = Product(productId: 3, productImage: "Fish 3", catogaryName: "Seafood", productName: "Crabs(කකුළුව)",description: "Imported", productPrice: 1100.00, productQty: 1)
        
        let product_4 = Product(productId: 4, productImage: "Fish 4", catogaryName: "Seafood", productName: "Cuttle fish (Clean)",description: "Local", productPrice: 1100.00, productQty: 1)
        
        let product_5 = Product(productId: 5, productImage: "Fish 5", catogaryName: "Fish", productName: "Galmalu (ගල්මාළු)",description: "Imported", productPrice: 1000.00, productQty: 1)
        
        productList.append(product_1)
        productList.append(product_2)
        productList.append(product_3)
        productList.append(product_4)
        productList.append(product_5)
    }
    
    
    fileprivate func topViewMoveUP(){
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: { [weak self] in
            
            guard let strongeSelf = self else { return }
            guard let statusBarHeight = strongeSelf.view.window?.windowScene?.statusBarManager?.statusBarFrame.height else { return }
            strongeSelf.navigationViewTopConstraint.constant = -(strongeSelf.navigationView.frame.height + statusBarHeight)
            strongeSelf.separetorTopConstraint.constant = statusBarHeight + 20
            strongeSelf.middleViewTopConstraint.constant = 5
            
            strongeSelf.view.layoutIfNeeded()
            
        }, completion: nil)
        
    }
    
    fileprivate func topViewMoveDown(){
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: { [weak self] in
            
            guard let strongeSelf = self else { return }
            strongeSelf.navigationViewTopConstraint.constant = 0
            strongeSelf.separetorTopConstraint.constant = 10
            strongeSelf.middleViewTopConstraint.constant = 0
            strongeSelf.view.layoutIfNeeded()
            
        }, completion: nil)
        
    }
    
    fileprivate func registerForKeyboardEvent(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    fileprivate func disappearFromKeyboardEvent(){
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    @objc fileprivate func keyboardWillShow(){
        view.addSubview(touchView)
    }
    
    @objc fileprivate func keyboardWillHide(){
        touchView.removeFromSuperview()
    }
    
    @objc fileprivate func dismissKeyboard(){
        view.endEditing(true)
    }
    
    @objc private func addToCartButtonDidPressed(sender : UIButton){
        
        let product = self.productList[sender.tag] as Product
        addedItemToCart(product)
        
    }
    
    private func moveDownNotification(){
        
        UIView.animate(withDuration: 1.5, delay: 0.5, options: .curveEaseInOut) { [weak self] in
            guard let strongeSelf = self else { return }
            print("moving down")
            strongeSelf.notifiViewTopConstraint.constant = 15.0
            strongeSelf.view.layoutIfNeeded()
        } completion: { (success) in
            
            self.moveUpNotification()
            self.notifiMoveUpAnimation.startAnimation()
            
        }
        
    }
    
    private func moveUpNotification(){
        
        notifiMoveUpAnimation = UIViewPropertyAnimator(duration: 1.5, curve: .easeInOut, animations: { [weak self] in
            guard let strongeSelf = self else { return }
            strongeSelf.notifiViewTopConstraint.constant = -30.0
            strongeSelf.view.layoutIfNeeded()
            print("moving up")
            
        })

    }
    
    private func getPenddingCartItem(){
        
        if let data = try? Data(contentsOf: dataFilePath!){
            let decode = PropertyListDecoder()
            
            do {
                cartList = try decode.decode([Product].self, from: data)
                cartProductCount.text = "\(cartList.count)"
    
            } catch {
                print("Error decoding cart list \(error)")
            }
        }
    }
}

extension HomeViewController : UICollectionViewDelegate,UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let productCell = productView.dequeueReusableCell(withReuseIdentifier: "PRODUCT_CELL", for: indexPath) as! ProductViewCell
        
        productCell.product = productList[indexPath.row] as Product
        productCell.addCartButton.tag = indexPath.row
        productCell.addCartButton.addTarget(self, action: #selector(addToCartButtonDidPressed), for: .touchUpInside)
        
        return productCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let productVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "VIEW_PRODUCT") as! ProductViewController
        productVC.modalTransitionStyle = .crossDissolve
        productVC.modalPresentationStyle = .formSheet
        productVC.getProductDetails = productList[indexPath.row] as Product
        productVC.cartDelegate = self
        present(productVC, animated: true, completion: nil)
    }
}

extension HomeViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (productView.frame.width - 15) / 2, height: 290)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(5.0)
    }
}

extension HomeViewController : UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        searchBar.endEditing(true)
    }
}

extension HomeViewController : CartDelegete{
    
    func addedItemToCart(_ item: Product) {
        self.cartList.append(item)
        moveDownNotification()
        self.cartProductCount.text = "\(Int(cartList.count))"
    }
    
}
