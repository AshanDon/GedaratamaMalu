//
//  IntraductionViewController.swift
//  GedaratamaMalu
//
//  Created by Ashan Don on 12/28/20.
//

import UIKit

struct IntraductionDetails {
    
    var image : UIImage!
    
    var quection : String!
    
    var intraduction : String!
    
    init(image : UIImage, quection : String, intraduction : String) {
        
        self.image = image
        
        self.quection = quection
        
        self.intraduction = intraduction
        
    }
}

class IntraductionViewController: UIViewController {

    @IBOutlet weak var pageController: UIPageControl!
    
    @IBOutlet weak var swipingView: UICollectionView!
    
    private let intraductionList : [IntraductionDetails] = [
        
        IntraductionDetails(image: UIImage(named: "Intraduction1")!, quection: "Why Choose Us ?", intraduction: "Our main aim is to supply fresh seafood products to our valuable customers. All kinds of seafood sell on our website are from our daily catch and no added any preservatives. The kinds of seafood delivered to you are so fresh, delicious and at the lowest price of the market."),
        
        IntraductionDetails(image: UIImage(named: "Intraduction2")!, quection: "Payment Method ?", intraduction: "You do not require to pay us before you receive your product. Our friendly delivery staff delivery your order to your doorstep and payment can be made by cash or card upon delivery. So place your order today, and have delicious fresh seafood with your meal !!!"),
        
        IntraductionDetails(image: UIImage(named: "Intraduction3")!, quection: "Terms & Conditions ?", intraduction: "First of all please be honest to pay after receive your order. If you need to cancel any of your orders or If there is an issue with the order on arrival, please notify us as soon as possible.")
        
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        swipingView.register(UINib(nibName: "SwipingViewCell", bundle: nil), forCellWithReuseIdentifier: "SWIPING_CELL")
        
        swipingView.dataSource = self
        
        swipingView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        setNavigationItem()
        
        setupPageController()
        
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let userDefault = UserDefaults.standard
        guard let _ = userDefault.object(forKey: "JWT_TOKEN") as? String else {
            return
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let x = targetContentOffset.pointee.x
        
        let pageNumber = Int(x / swipingView.frame.width)
        
        pageController.currentPage = pageNumber
        
        if pageNumber == 0 {
            
            navigationItem.leftBarButtonItem?.title = "Skip"
            
        } else {
            
            navigationItem.leftBarButtonItem?.title = "Back"
            
        }
    }
    
    private func setNavigationItem(){
        
        let leftNaviButton = UIBarButtonItem(title: "Skip", style: .plain, target: self, action: #selector(skipTapped))
        
        leftNaviButton.tintColor = UIColor(named: "Black_Color")
        
        navigationItem.leftBarButtonItem = leftNaviButton
        
        let rightNaviButton = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextTapped))
        
        rightNaviButton.tintColor = UIColor(named: "Black_Color")
        
        navigationItem.rightBarButtonItem = rightNaviButton
        
    }

    @objc private func skipTapped(){
        
        if navigationItem.leftBarButtonItem?.title == "Skip" {
            
            presentSignInView()
            
        } else {
            
            handleBack()
            
        }
    }
    
    @objc private func nextTapped(){
        
        navigationItem.leftBarButtonItem?.title = "Back"
        
        handleNext()
    }
    
    private func setupPageController(){
        
        pageController.currentPage = 0
        
        pageController.numberOfPages = intraductionList.count
        
    }
    
    private func handleNext(){
        
        let nextIndex = min(pageController.currentPage + 1, intraductionList.count - 1)
        
        if pageController.currentPage == nextIndex {
            
            presentSignInView()
            
        } else {
            
            let indexPath = IndexPath(item: nextIndex, section: 0)
            
            pageController.currentPage = nextIndex
            
            let rect = swipingView.layoutAttributesForItem(at: indexPath)?.frame
            
            swipingView.scrollRectToVisible(rect!, animated: false)
            
        }
        
    }
    
    @objc private func handleBack(){
        
        let prevIndex = max(pageController.currentPage - 1, 0)
        
        let indexPath = IndexPath(item: prevIndex, section: 0)
        
        pageController.currentPage = prevIndex
        
        let rect = swipingView.layoutAttributesForItem(at: indexPath)?.frame
        
        swipingView.scrollRectToVisible(rect!, animated: false)
        
        if pageController.currentPage == 0 {
            
            navigationItem.leftBarButtonItem?.title = "Skip"
            
        }
        
    }
    
    private func presentSignInView(){
        
        let signInView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "SIGNIN_SCREEN") as! SignInViewController
        
        signInView.modalTransitionStyle = .coverVertical
        
        signInView.modalPresentationStyle = .fullScreen
        
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = .moveIn
        transition.subtype = .fromTop
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        self.view.window!.layer.add(transition, forKey: kCATransition)
        
        self.navigationController?.present(signInView, animated: true, completion: nil)
        
    }
}

extension IntraductionViewController : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return intraductionList.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let swippingCell = swipingView.dequeueReusableCell(withReuseIdentifier: "SWIPING_CELL", for: indexPath) as! SwipingViewCell
        
        swippingCell.contentView.frame = CGRect(x: 0, y: 0, width: swippingCell.frame.size.width, height: swippingCell.frame.size.height)
        
        let intraduction = intraductionList[indexPath.row]
        
        swippingCell.intraImageView.image = intraduction.image!
        
        swippingCell.intraTitleLabel.text = intraduction.quection
        
        swippingCell.intraDetailLabel.text = intraduction.intraduction
        
        return swippingCell
        
    }

}

extension IntraductionViewController : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: swipingView.frame.width, height: swipingView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(0.0)
    }
}
