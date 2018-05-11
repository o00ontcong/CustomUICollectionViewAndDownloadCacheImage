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
    var labelText: UILabel!
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
        self.contentView.frame = self.bounds
        self.contentView.autoresizingMask = [.flexibleWidth , .flexibleHeight]
        self.imageView = UIImageView()
        self.imageView.contentMode = .scaleAspectFill;
        self.imageView.frame = self.bounds;
        self.contentView.addSubview(self.imageView)
        
    }
}
