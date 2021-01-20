//
//  CollectionLayout.swift
//  Story Book
//
//  Created by Ashan Anuruddika on 7/21/20.
//  Copyright © 2020 Ashan. All rights reserved.
//

import Foundation

import UIKit

class CollectionLayout : UICollectionViewLayout{
    
    fileprivate var numberOfColumns : Int = 2
    
    fileprivate var cellPadding : CGFloat = 5
    
    fileprivate var cache = [UICollectionViewLayoutAttributes]()
    
    fileprivate var contentWidth : CGFloat {
        
        guard let collectionView = collectionView else {
            
            return 0
            
        }
        
        let inset = collectionView.contentInset
        
        return collectionView.bounds.width - (inset.left + inset.right) - (cellPadding * (CGFloat(numberOfColumns) - 1))
        
    }
    
    fileprivate var contentHeight : CGFloat = 290
    
    override var collectionViewContentSize: CGSize {
        
        return CGSize(width: contentWidth, height: contentHeight)
        
    }
    
    
    override func prepare() {
        
        guard cache.isEmpty == true, let collectionView = collectionView else {
            
            return
        }
        
        let itemsPreRow : Int = 3
        
        let normalColumnsWidth : CGFloat = contentWidth / CGFloat(itemsPreRow)
        
        let normalColumnsHeight : CGFloat = normalColumnsWidth
        
        let featuredColumnsWidth : CGFloat = (normalColumnsWidth * 2) + cellPadding
        
        let featuredColumnsHeight : CGFloat = featuredColumnsWidth
        
        var xOffset : [CGFloat] = [CGFloat]()
        
        for item in 0..<6 {
            
            let multiplier = item % 3
            
            let xPosition = CGFloat(multiplier) * (normalColumnsWidth + cellPadding)
            
            xOffset.append(xPosition)
            
        }
        
        xOffset.append(0.0)
        
        for _ in 0..<2 {
            
            xOffset.append(featuredColumnsWidth + cellPadding)
            
        }
        
        var yOffset : [CGFloat] = [CGFloat]()
        
        for item in 0..<9 {
            
            var _yPosition = floor(Double(item / 3) * (Double(normalColumnsHeight) + Double(cellPadding)))
            
            if item == 8 {
                
                _yPosition += (Double(normalColumnsHeight) + Double(cellPadding))
                
            }
            
            yOffset.append(CGFloat(_yPosition))
            
            
        }
        
        let numberOfPerSection : Int = 9
        
        let heightOfSection : CGFloat = 4 * normalColumnsHeight + (4 * cellPadding)
        
        var itemInSection : Int = 0
        
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            
            let indexPath = IndexPath(item: item, section: 0)
            
            let xPosition = xOffset[itemInSection]
            
            let multiplier : Double = floor(Double(item) / Double(numberOfPerSection))
            
            let yPosition = yOffset[itemInSection] + (heightOfSection * CGFloat(multiplier))
            
            var cellWidth = normalColumnsWidth
            
            var cellHeight = normalColumnsHeight
            
            if (itemInSection + 1) % 7 == 0 && itemInSection != 0 {
                
                cellWidth = featuredColumnsWidth
                
                cellHeight = featuredColumnsHeight
                
            }
            
            let frame : CGRect = CGRect(x: xPosition, y: yPosition, width: cellWidth, height: cellHeight)
            
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            attributes.frame = frame
            
            cache.append(attributes)
            
            contentHeight = max(contentHeight, frame.maxY)
            
            itemInSection = itemInSection < (numberOfPerSection - 1) ? (itemInSection + 1) : 0
            
        }
        
    }
    
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
        
        for attributes in cache {
            
            if attributes.frame.intersects(rect){
                
                visibleLayoutAttributes.append(attributes)
                
            }
        }
        
        return visibleLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        return cache[indexPath.item]
    }
    
    
    
}
