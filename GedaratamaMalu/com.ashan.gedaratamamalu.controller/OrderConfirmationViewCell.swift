//
//  OrderConfirmationViewCell.swift
//  GedaratamaMalu
//
//  Created by Ashan Don on 8/25/21.
//

import UIKit

class OrderConfirmationViewCell: UICollectionViewCell {

    @IBOutlet weak var gifImageView: UIImageView!
    @IBOutlet weak var timeRemainingLabel: UILabel!
    @IBOutlet weak var orderStatusLabel: UILabel!
    @IBOutlet weak var orderRemainingLabel: UILabel!
    
    fileprivate var timer : Timer!
    var progressCount : Int = 0
    var orderConformTime : Int = 5
    var orderPreparationTime : Int = 15
    var timeRemaining : Int = 0 {
        didSet {
            timeRemainingLabel.text = "within \(timeRemaining) mins"
        
            if progressCount < 5 {
                gifImageView.image = UIImage.gifImageWithName("guidelines")
                orderRemainingLabel.text = "Your order has been received."
            } else if orderConformTime <= progressCount && progressCount <= orderPreparationTime { // 15
                gifImageView.image = UIImage.gifImageWithName("fish3")
                orderRemainingLabel.text = "Preparing your order"
            } else if 20 < progressCount{
                gifImageView.image = UIImage.gifImageWithName("scooter-courier")
                orderRemainingLabel.text = "Get ready! Your order is on its way!!!"
            }
        }
    }
    
    var orderId : Int!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        updateContentView()

        timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(calculateTime), userInfo: nil, repeats: true)
        
    }

    
    fileprivate func updateContentView(){
        contentView.layer.cornerRadius = CGFloat(40)
        contentView.layer.masksToBounds = true
    }
    
    @objc fileprivate func calculateTime(){
        if 0 < timeRemaining {
            timeRemaining -= 1
            progressCount += 1
            timeRemainingLabel.text = "within \(timeRemaining) mins"
            
            if progressCount < orderConformTime {
                gifImageView.image = UIImage.gifImageWithName("guidelines")
                orderRemainingLabel.text = "Your order has been received."
            } else if orderConformTime <= progressCount && progressCount <= orderPreparationTime { // 15
                gifImageView.image = UIImage.gifImageWithName("fish3")
                orderRemainingLabel.text = "Preparing your order"
            } else if (orderConformTime + orderPreparationTime) < progressCount{
                gifImageView.image = UIImage.gifImageWithName("scooter-courier")
                orderRemainingLabel.text = "Get ready! Your order is on its way!!!"
            }
        } else {
            timer.invalidate()
            NotificationCenter.default.post(name: NSNotification.Name("RELOAD_PRODUCT_VIEW"), object: orderId)
        }
    }
    
}
