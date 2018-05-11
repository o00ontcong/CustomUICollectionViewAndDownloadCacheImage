//
//  CustomCollectionViewLayout.swift
//  CustomUICollectionViewAndDownloadCacheImage
//
//  Created by Cong Nguyen on 07/05/2018.
//  Copyright © 2018 Cong Nguyen. All rights reserved.
//

import UIKit

class CustomCollectionViewLayout: UICollectionViewLayout {
    let attributeArray = NSMutableDictionary()
    var contentSize:CGSize!
    let numberOfColumn: Int = 3
    let padding: CGFloat = 15
    var collectionViewWidth: CGFloat = 0
    var itemWidth: CGFloat = 0
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func prepare()
    {
        super.prepare()
        collectionViewWidth = collectionView!.frame.size.width
        itemWidth = ((collectionViewWidth) - padding * CGFloat((numberOfColumn + 1))) / CGFloat(numberOfColumn)
        self.contentSize = CGSize(width: (self.collectionView?.frame.size.width)!, height: 0);

        // Iterate throught cells
        for i in 0..<(collectionView?.numberOfSections ?? 0) {
            for j in 0..<(collectionView?.numberOfItems(inSection: i) ?? 0) {
              
                let indexPath = IndexPath(item: j, section: i)
                let cellAttributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                cellAttributes.frame = self.frameForCellAtIndexPath(indexPath: indexPath)
                self.attributeArray[indexPath] = cellAttributes
                if (((self.collectionView?.numberOfSections)! - 1) == i ) {
                    if (((self.collectionView?.numberOfItems(inSection: i))! - 1) == j){
                    
                    self.contentSize.height = cellAttributes.frame.origin.y + cellAttributes.frame.height
                    }

                }
            }
            
        }
        

    }
    
    override var collectionViewContentSize: CGSize
    {
        return self.contentSize

    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        
        for attributes  in self.attributeArray {
            if (attributes.value as! UICollectionViewLayoutAttributes).frame.intersects(rect ) {
                layoutAttributes.append((attributes.value as! UICollectionViewLayoutAttributes))
            }
        }
        return layoutAttributes
    }
    
  
    func frameForCellAtIndexPath(indexPath: IndexPath) -> CGRect{
        
        var frame: CGRect = CGRect.zero
        var tempX: CGFloat = 0
        var tempY: CGFloat = 0
        let n: Int = indexPath.item % 6
        let groupHeight = CGFloat(indexPath.item / 6) * (itemWidth + padding) * 3
        switch n {
        case 0, 1, 2:
            tempX = (itemWidth * CGFloat(n)) + (padding * CGFloat((n + 1)))
            tempY = padding + groupHeight
            frame = CGRect(x: tempX, y: tempY, width: itemWidth, height: itemWidth)
        case 3:
            tempX = padding
            tempY = padding*2 + itemWidth + groupHeight
            frame = CGRect(x: tempX, y: tempY, width: itemWidth, height: itemWidth)
        case 4:
            tempX = itemWidth + padding * 2
            tempY = padding*2 + itemWidth + groupHeight
            frame = CGRect(x: tempX, y: tempY, width: itemWidth * 2 + padding, height: itemWidth * 2 + padding)
        case 5:
            tempX = padding
            tempY = padding*3 + itemWidth*2 + groupHeight
            frame = CGRect(x: tempX, y: tempY, width: itemWidth, height: itemWidth)
        default:
            break
        }
        
        return frame
    }
    
}
