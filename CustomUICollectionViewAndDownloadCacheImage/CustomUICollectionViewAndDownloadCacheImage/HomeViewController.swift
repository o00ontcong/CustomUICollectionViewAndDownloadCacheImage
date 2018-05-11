//
//  HomeViewController.swift
//  CustomUICollectionViewAndDownloadCacheImage
//
//  Created by Cong Nguyen on 07/05/2018.
//  Copyright © 2018 Cong Nguyen. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var collectionView: UICollectionView!
    
    let productCache:NSCache = NSCache<NSString, UIImage>()
    var downloadingTasks = Dictionary<IndexPath,Operation>()
    lazy var downloadPhotoQueue:OperationQueue = {
        let queue = OperationQueue()
        queue.name = "DOWNLOAD_PHOTO"
        queue.maxConcurrentOperationCount = 2
        return queue
    }()
    
    var listImages = ["https://preview.ibb.co/dFpS17/vinh_ha_long_canh_dep_vietnam_wallpaper_2880x1620.jpg",
                      "https://preview.ibb.co/dHABTn/boat_halong_landscape_wallpaper_3840x2160.jpg",
                      "https://preview.ibb.co/cHuS17/boat_rowing_on_halong_bay_wallpaper_3840x2160.jpg",
                      "https://preview.ibb.co/kQ11Tn/canh_dep_vietnam_vinh_ha_long_wallpaper_3840x2160.jpg",
                      "https://preview.ibb.co/fyEXZS/ha_long_bay_islands_wallpaper_3840x2160.jpg",
                      "https://preview.ibb.co/g4SmuS/ha_long_bay_sunset_in_vietnam_wallpaper_3840x2160.jpg",
                      "https://preview.ibb.co/cVh2ZS/ha_long_bay_vietnam_landscape_wallpaper_3840x2160.jpg",
                      "https://preview.ibb.co/hK39ES/halonbg_landscape_in_vietnam_wallpaper_3840x2160.jpg",
                      "https://preview.ibb.co/bFTLM7/halong_bay_in_vietnam_island_wallpaper_3840x2160.jpg",
                      "https://preview.ibb.co/dqJ9ES/halong_bay_islands_vietnam_wallpaper_2880x1620.jpg",
                      "https://preview.ibb.co/hzObuS/halong_bay_landscape_bing_wallpaper_1920x1080.jpg",
                      "https://preview.ibb.co/b0oWTn/halong_bay_nam_cat_island_wallpaper_3840x2160.jpg",
                      "https://preview.ibb.co/kXB717/halong_bay_night_lanscape_wallpaper_3840x2160.jpg",
                      "https://preview.ibb.co/i4ty8n/halong_bay_vietnam_sundeck_wallpaper_3840x2160.jpg",
                      "https://preview.ibb.co/ee8Fon/halong_bay_paloma_cruise_wallpaper_1920x1080.jpg",
                      "https://preview.ibb.co/kiFT8n/halong_bay_vietnam_tropical_islands_ships_ultra_3840x2160.jpg",
                      "https://preview.ibb.co/fYQjg7/halong_northeast_monsoon_winter_wallpaper_3840x2160.jpg",
                      "https://preview.ibb.co/m9uug7/landscape_boat_island_Ha_Long_bay_ocean_wallpaper_3840x2160.jpg",
                      "https://preview.ibb.co/fV5BTn/landscap_halong_bay_vietnam_wallpaper_3840x2160.jpg",
                      "https://preview.ibb.co/dFpS17/vinh_ha_long_canh_dep_vietnam_wallpaper_2880x1620.jpg"]
    //MARK: -  Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.gray;
        self.configureView()
        
    }
    
    //MARK: -  Custom Accessors
    
    func configureView(){
        let flowLayout = CustomCollectionViewLayout()
        collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: flowLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.clear
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        self.view.addSubview(collectionView)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCollectionViewCell
        cell.contentView.backgroundColor = UIColor.blue
        cell.imageView.frame = cell.bounds;
        
        let keyCache: String = listImages[indexPath.item] as String
        if let downloadedIMG = productCache.object(forKey: keyCache as NSString){
            cell.imageView.image = downloadedIMG
        } else {
            //            cell.layoutIfNeeded()
            cell.imageView.image = UIImage(named: "NoPicture")
            let url = listImages[indexPath.item]
            if !collectionView.isDecelerating {
                let downloadPhoto = DownloadImageOperation(indexPath: indexPath, photoURL: url, delegate: self)
                startDownloadImage(downloadPhoto, indexPath: indexPath)
            }
            
        }
        
        return cell
    }
    
    //MARK: - ScrollView
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        reloadVisibleCells()
        
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.isDecelerating {
            downloadingTasks.removeAll()
            downloadPhotoQueue.cancelAllOperations()
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func startDownloadImage(_ operation: DownloadImageOperation, indexPath: IndexPath)  {
        if let _ = downloadingTasks[indexPath]{
            return
        }
        downloadingTasks[indexPath] = operation
        downloadPhotoQueue.addOperation(operation)
    }
    func reloadVisibleCells() {
        UIView.setAnimationsEnabled(false)
        self.collectionView.performBatchUpdates({
            let visibleCellIndexPaths = self.collectionView.indexPathsForVisibleItems
            self.collectionView.reloadItems(at: visibleCellIndexPaths)
        }) { (finished) in
            UIView.setAnimationsEnabled(true)
        }
    }
}
extension HomeViewController: DownloadImageOperationDelegate {
    func downloadPhotoDidFail(_ operation: DownloadImageOperation) {
        
    }
    func downloadPhotoDidFinish(_ operation: DownloadImageOperation, image: UIImage) {
        let keyCache = listImages[(operation.indexPath as IndexPath).item]
        let cell = self.collectionView(self.collectionView, cellForItemAt: operation.indexPath as IndexPath) as! CustomCollectionViewCell
        let resultImg = image.scaleImage(cell.bounds.size)
        self.productCache.setObject(resultImg, forKey: keyCache as NSString)
        let visibleCellIndexPaths = self.collectionView.indexPathsForVisibleItems
        for indexPath in visibleCellIndexPaths {
            if (indexPath == operation.indexPath){
                self.collectionView.reloadItems(at: [operation.indexPath as IndexPath])
            }
        }
        downloadingTasks.removeValue(forKey: operation.indexPath as IndexPath)
    }
}

