//
//  DownloadPhotoOperation.swift
//  The ZARA
//
//  Created by MAC on 14/08/2016.
//  Copyright © 2016 o00ontcong. All rights reserved.
//

import UIKit

protocol DownloadImageOperationDelegate: class {
    func downloadPhotoDidFinish(_ operation:DownloadImageOperation, image:UIImage)
    func downloadPhotoDidFail(_ operation:DownloadImageOperation)
}

class DownloadImageOperation: Operation {

    let indexPath:IndexPath
    let photoURL:String
    weak var delegate:DownloadImageOperationDelegate?

    init(indexPath:IndexPath, photoURL:String, delegate:DownloadImageOperationDelegate?) {
        self.indexPath = indexPath
        self.photoURL = photoURL
        self.delegate = delegate
    }

    override func main() {
        if isCancelled { return }
        let url = URL(string: photoURL)
        let imgData = try? Data(contentsOf: url!)
        if let imageData = imgData {
            if let downloadedImage = UIImage(data: imageData) {
                
                DispatchQueue.main.async {
                    self.delegate?.downloadPhotoDidFinish(self, image: downloadedImage)
                }
                
            } else {
                handleFail()
            }
        }
        
        
    }
    fileprivate func handleFail() {
        DispatchQueue.main.async {
            self.delegate?.downloadPhotoDidFail(self)
        }

    }
    
    
}
