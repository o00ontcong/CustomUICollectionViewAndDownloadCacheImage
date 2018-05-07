//
//  CustomCollectionViewCell.swift
//  CustomUICollectionViewAndDownloadCacheImage
//
//  Created by Cong Nguyen on 07/05/2018.
//  Copyright © 2018 Cong Nguyen. All rights reserved.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    var imageView: UIImageView!
    var label: UILabel!
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        
        initialize()
    }
    
    fileprivate func initialize() {


    }
    func configureView(){
        
    }
    // MARK: - Other Methods
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
}
