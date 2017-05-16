//
//  AlbumViewController.swift
//  pickary
//
//  Created by Mobile Developer on 12/23/16.
//  Copyright © 2016 Greg. All rights reserved.
//

import UIKit
import AVFoundation
import Photos
import PhotosUI

class AlbumViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    let albumCollectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        
        layout.itemSize = CGSize(width: Configuration.thumbnailDimension, height: Configuration.thumbnailDimension)
        layout.minimumLineSpacing = 1
        
        layout.minimumInteritemSpacing = 1
        layout.sectionInset = UIEdgeInsets.zero
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)

        return collectionView
    }()
    
//    internal var assets: PHFetchResult<PHAsset>? = nil
    lazy var assets = [PHAsset]()
    
    private var didSetupConstraints = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func updateViewConstraints() {
        
        if !didSetupConstraints {
            
            
            albumCollectionView.snp.makeConstraints({ (make) in
                
                make.leading.equalToSuperview()
                make.trailing.equalToSuperview()
                make.top.equalToSuperview()
                make.bottom.equalToSuperview()
            })
            
            didSetupConstraints = true
            
        }
        
        super.updateViewConstraints()
    }
    
    // Initialize 
    
    func initialize() {
        
        self.title = "Sale Album"
        let superView = self.view
        superView?.backgroundColor = UIColor.clear
        
        superView?.addSubview(albumCollectionView)
        
        albumCollectionView.register(ImageGalleryCell.self, forCellWithReuseIdentifier: String(describing: ImageGalleryCell.self))
        albumCollectionView.delegate = self
        albumCollectionView.dataSource = self
        view.setNeedsUpdateConstraints()
        
        fetchPhotos()
    }
    
    // Fetch Photos
    
    func fetchPhotos() {
        
        AssetManager.fetch { (asset) in
            
            self.assets.removeAll()
            self.assets.append(contentsOf: asset)
            self.albumCollectionView.reloadData()
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - UICollectionView DataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.assets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:  String(describing: ImageGalleryCell.self), for: indexPath) as? ImageGalleryCell else {
            return UICollectionViewCell()
        }
        
        let asset = assets[indexPath.row]
        
        AssetManager.resolveAsset(asset, size: CGSize(width: Configuration.thumbnailDimension, height: Configuration.thumbnailDimension)) { (image) in
            
            if let image = image {
                
                cell.configureCell(image)
                
                cell.setNeedsUpdateConstraints()
                cell.updateConstraintsIfNeeded()

            }

        }
        
        return cell
    }
    

}
