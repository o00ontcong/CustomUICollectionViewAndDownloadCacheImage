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
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func prepare()
    {
        super.prepare()
        //  Converted to Swift 4 by Swiftify v4.1.6697 - https://objectivec2swift.com/
        let numberOfColumn: Int = 3
        let padding: CGFloat = 15
        let collectionViewWidth: CGFloat? = collectionView?.frame.size.width
        let itemWidth = ((collectionViewWidth ?? 0.0) - padding * CGFloat((numberOfColumn + 1))) / CGFloat(numberOfColumn)
        var minHeight: CGFloat = 0
        var groupHeight: CGFloat = 0
        var frame: CGRect = CGRect.zero
        // Iterate throught cells
        for i in 0..<(collectionView?.numberOfSections ?? 0) {
            for j in 0..<(collectionView?.numberOfItems(inSection: i) ?? 0) {
                var tempX: CGFloat = 0
                var tempY: CGFloat = 0
                let n: Int = j % 6
                tempY = minHeight + padding + groupHeight
                switch n {
                case 0, 1, 2:
                    tempX = (itemWidth * CGFloat(n)) + (padding * CGFloat((n + 1)))
                    frame = CGRect(x: tempX, y: tempY, width: itemWidth, height: itemWidth)
                    if n == 2 {
                        minHeight = padding + itemWidth
                    }
                case 3:
                    tempX = padding
                    frame = CGRect(x: tempX, y: tempY, width: itemWidth, height: itemWidth)
                case 4:
                    tempX = itemWidth + padding * 2
                    frame = CGRect(x: tempX, y: tempY, width: itemWidth * 2 + padding, height: itemWidth * 2 + padding)
                    minHeight = 2 * (itemWidth + padding)
                case 5:
                    tempX = padding
                    frame = CGRect(x: tempX, y: tempY, width: itemWidth, height: itemWidth)
                    groupHeight += (itemWidth + padding) * 3
                    minHeight = 0
                default:
                    break
                }
                let indexPath = IndexPath(item: j, section: i)
                let cellAttributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                cellAttributes.frame = frame
                self.attributeArray[indexPath] = cellAttributes
                self.contentSize = CGSize(width: (self.collectionView?.frame.size.width)!, height: tempY + minHeight + groupHeight);

            }
        }

    }
    
    override var collectionViewContentSize: CGSize
    {
        return self.contentSize

    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        
        // Duyệt các đối tượng trong attributeArray để tìm ra các cell nằm trong khung nhìn rect
        for attributes  in self.attributeArray {
            if (attributes.value as! UICollectionViewLayoutAttributes).frame.intersects(rect ) {
                layoutAttributes.append((attributes.value as! UICollectionViewLayoutAttributes))
            }
        }
        return layoutAttributes
    }
}
