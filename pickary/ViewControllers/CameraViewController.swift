//
//  CameraViewController.swift
//  pickary
//
//  Created by Mobile Developer on 12/22/16.
//  Copyright © 2016 Greg. All rights reserved.
//

import UIKit
import SnapKit
import AVFoundation
import Photos


class CameraViewController: UIViewController, CameraManDelegate, UICollectionViewDataSource,
                                                UICollectionViewDelegate, ImageStackCellDelegate {
    
    
    // Top Control
    
    let topControlView: UIView = {
       
        let view = UIView()
        view.backgroundColor = UIColor.black
        view.alpha = 0.8
        
        return view
        
    }()
    
    let cancelButton: UIButton = {
        
        let button = UIButton(type: UIButtonType.custom)
        button.setTitle("Cancel", for: .normal)
        
        return button;
    }()
    
    let doneButton: UIButton = {
        
        let button = UIButton(type: UIButtonType.custom)
        
        button.setTitle("Done", for: .normal)
        
        return button;
    }()
    
    // Bottom Control View
    
    let bottomControlView: UIView = {
        
        let view = UIView()
        
        view.backgroundColor = UIColor.black
        
        return view
    }()
    
    let cameraButton: UIButton = {
        
        let button = UIButton(type: UIButtonType.custom)
        button.setImage(UIImage(named: "cameraButton"), for: .normal)
        return button
    }()
    
    let albumButton: UIButton = {
        
        let button = UIButton(type: UIButtonType.custom)
        button.setImage(UIImage(named: "libraryButton"), for: .normal)
        return button
    }()
    
    //Camera Preview
    
    let preview: UIView  = {
        
        let view = UIView()
        view.backgroundColor = UIColor.clear
        
        return view
    }()
    
    let topCoverView: UIView = {
        
        let view  = UIView()
        view.backgroundColor = UIColor.black
        
        return view
    }()
    
    let bottomCoverView: UIView = {
        
        let view = UIView()
        view.backgroundColor = UIColor.black
        return view
        
    }()
    
    // ScrollView
    
    let photoCollectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        
        layout.itemSize = CGSize(width: 50, height: 50)
        layout.minimumLineSpacing = 1
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 1
        layout.sectionInset = UIEdgeInsets.zero
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        
        return collectionView

    }()
    
    //Constraint
    
    var topCoverViewHeightConstraint: Constraint? = nil
    var bottomCoverViewHeightConstraint: Constraint? = nil
    //
    
    let phtoCount = 10
    
    var maxCount = 0
    let CELL_WIDTH:Float = 60
    var delta: Float = 0
    //
    
    private var didSetupConstraints = false
    
    var imageArray: [UIImage] = []
    
    let cameraMan = CameraMan()
    
    var previewLayer: AVCaptureVideoPreviewLayer?
//    weak var delegate: 
    var animationTimer: Timer?
    
    var startOnFrontCamera: Bool = false
    
    var currentIndexPath: IndexPath!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        previewLayer?.connection.videoOrientation = .portrait
    }
    override func updateViewConstraints() {
        
        if !didSetupConstraints {
            
            
            bottomControlView.snp.makeConstraints({ (make) in
                
                make.leading.equalToSuperview()
                make.trailing.equalToSuperview()
                make.bottom.equalToSuperview()
                make.height.equalTo(100)
            })
            
            cameraButton.snp.makeConstraints({ (make) in
                
                make.centerX.equalToSuperview()
                make.centerY.equalToSuperview()
            })
            
            albumButton.snp.makeConstraints({ (make) in
                
                make.trailing.equalToSuperview().inset(kButtonHorizontalInsets)
                make.centerY.equalTo(cameraButton.snp.centerY)
            })
            
            photoCollectionView.snp.makeConstraints({ (make) in
                
                make.leading.equalToSuperview()
                make.trailing.equalToSuperview()
                make.bottom.equalTo(bottomControlView.snp.top)
                make.height.equalTo(CELL_WIDTH)
            })
            
            
            topControlView.snp.makeConstraints({ (make) in
                
                make.leading.equalToSuperview()
                make.trailing.equalToSuperview()
                make.top.equalToSuperview()
                
                make.height.equalTo(50)
            })
            
            cancelButton.snp.makeConstraints({ (make) in
                
                make.leading.equalToSuperview().inset(kButtonHorizontalInsets)
//                make.centerY.equalToSuperview()
                make.bottom.equalToSuperview().inset(7)
            })
            
            doneButton.snp.makeConstraints({ (make) in
                
                make.trailing.equalToSuperview().inset(kButtonHorizontalInsets)
                make.centerY.equalTo(cancelButton.snp.centerY)
            })
            
            topCoverView.snp.makeConstraints({ (make) in
                
                self.topCoverViewHeightConstraint = make.height.equalTo(1).constraint
                make.leading.equalToSuperview()
                make.trailing.equalToSuperview()
//                make.height.equalTo(1)
                make.top.equalTo(topControlView.snp.bottom)
            })
            
            bottomCoverView.snp.makeConstraints({ (make) in
                
                self.bottomCoverViewHeightConstraint = make.height.equalTo(1).constraint
                make.leading.equalToSuperview()
                make.trailing.equalToSuperview()
//                make.height.equalTo(1)
                make.bottom.equalTo(bottomControlView.snp.top)
            })
            
//            preview.snp.makeConstraints({ (make) in
//                make.leading.equalToSuperview()
//                make.trailing.equalToSuperview()
//                make.top.equalTo(topControlView.snp.bottom)
//                make.bottom.equalTo(photoCollectionView.snp.top)
//            })
            
            didSetupConstraints = true
            
        }
        
        super.updateViewConstraints()
    }

    // MARK: - Private
    
    private func initialize() {

        let superView = self.view
        superView?.backgroundColor = UIColor.black
        

        
        superView?.addSubview(bottomControlView)
        topControlView.addSubview(cancelButton)
        topControlView.addSubview(doneButton)
        bottomControlView.addSubview(cameraButton)
        bottomControlView.addSubview(albumButton)
        superView?.addSubview(topControlView)
        superView?.addSubview(photoCollectionView)
        superView?.addSubview(topCoverView)
        superView?.addSubview(bottomCoverView)

        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
        photoCollectionView.register(ImageStackCell.self, forCellWithReuseIdentifier: String(describing: ImageStackCell.self))

        
        
        doneButton.addTarget(self, action: #selector(doneButtonTapped(sender:)), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped(sender:)), for: .touchUpInside)
        albumButton.addTarget(self, action: #selector(albumButtonTapped(sender:)), for: .touchUpInside)
        cameraButton.addTarget(self, action: #selector(captureButtonTapped(sender:)), for: .touchUpInside)
        
        view.setNeedsUpdateConstraints()
        checkStatus()
        //
        
        DispatchQueue.main.async {
            
            self.cameraMan.delegate = self
            self.cameraMan.setup(self.startOnFrontCamera)
            
        }

     
        
    }
    
    // Initialize Camera Session
    func setupPreviewLayer() {
        
        guard let layer = AVCaptureVideoPreviewLayer(session: cameraMan.session) else { return }
        
        layer.backgroundColor = UIColor.groupTableViewBackground.cgColor
        
        layer.autoreverses = true
        layer.videoGravity = AVLayerVideoGravityResizeAspectFill
        
        view.layer.insertSublayer(layer, at: 0)
        layer.frame = view.layer.frame
        view.clipsToBounds = true
        
        previewLayer = layer
    }
    
    // Set up scrollview Content
    
    func setUpScrollViewContent() {
        
        
    }
    
    
    //Check Permission
    
    func checkStatus() {
        
        let currentStatus = PHPhotoLibrary.authorizationStatus()
        
        guard currentStatus != .authorized else {
            return
        }
        
        if currentStatus == .notDetermined {
            
            
        }
        
        PHPhotoLibrary.requestAuthorization { (authorizationStatus) in
            
            DispatchQueue.main.async {
                if authorizationStatus == .denied {
                    self.presentAskPermissionAlert()
                } else if authorizationStatus == .authorized {
                }
            }
        }
    }
    
    func presentAskPermissionAlert() {
        let alertController = UIAlertController(title: Configuration.requestPermissionTitle, message: Configuration.requestPermissionMessage, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: Configuration.OKButtonTitle, style: .default) { _ in
            if let settingsURL = URL(string: UIApplicationOpenSettingsURLString) {
                UIApplication.shared.openURL(settingsURL)
            }
        }
        
        let cancelAction = UIAlertAction(title: Configuration.cancelButtonTitle, style: .cancel) { _ in
            self.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(alertAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    // Check camera button status
    
    func checkCameraButton(){
        
        if self.maxCount >= self.phtoCount {
            
            self.maxCount = self.phtoCount
            self.cameraButton.isEnabled = false
        }else {
            
            self.cameraButton.isEnabled = true
        }

    }
    
    // Move Scrollview
    
    func animateScrollView(_ index:NSInteger) {
        
        
        
        let cell = self.photoCollectionView.cellForItem(at: currentIndexPath)
        
        
        let point = photoCollectionView.convert((cell?.center)!, to: self.view)
        
        print("center point is \(point.x)  ,,,, \(point.y)")
        
        let point2 = photoCollectionView.convert((cell?.center)!, to: self.photoCollectionView)
        
        print("center point is \(point2.x)  ,,,, \(point2.y)")
        
        
        if point.x > self.view.bounds.size.width/2 {
            
            if ((self.view.bounds.size.width - point.x) >= (self.photoCollectionView.contentSize.width - point2.x)) {
                
                
            }else {
                
                delta += self.CELL_WIDTH
                
                UIView.animate(withDuration: 0.3, animations: {
                    
                    let defaultOffset = CGPoint(x: Double(self.delta) , y: 0.0)
                    
                    self.photoCollectionView.setContentOffset(defaultOffset, animated: true)
                    
                }) { (finished) in
                    
                }

            }
        }
        
        
    }
    
    // 
    
    func animateCoverViews() {
        
        UIView.animate(withDuration: 0.1, animations: {
            self.topCoverViewHeightConstraint?.update(offset: 250)
            self.bottomCoverViewHeightConstraint?.update(offset: 250)
            
            self.view.layoutIfNeeded()
        }) { (finished) in
            
            UIView.animate(withDuration: 0.2, delay: 0.1, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                
                self.topCoverViewHeightConstraint?.update(offset: 1)
                self.bottomCoverViewHeightConstraint?.update(offset: 1)
                self.view.layoutIfNeeded()

            }) { (finished) in
                
                
            }
        }
    }

    // MARK: - Actions
    
    func cancelButtonTapped(sender: UIButton?) {
        
        self.navigationController?.dismiss(animated: true, completion: { 
            
        })
    }
    
    func doneButtonTapped(sender: UIButton?) {
        
        let albumVC = AlbumViewController()
        
        self.navigationController?.pushViewController(albumVC, animated: true)
        
    }
    
    func captureButtonTapped(sender: UIButton?) {
    
        
        
        guard let previewLayer = previewLayer else {
            
            return
        }
        
        
        self.animateCoverViews()
        cameraMan.takePhoto(previewLayer, location: nil) { (image) in
            
            guard let img = image else { return }
            
            self.maxCount += 1
            self.checkCameraButton()
            self.imageArray.append(img)
            
            self.photoCollectionView.reloadData()
            
//            self.animateScrollView(0)
            
            
        }
    }
    
    func albumButtonTapped(sender: UIButton?) {
        
        let albumVC = AlbumViewController()
        
        self.navigationController?.pushViewController(albumVC, animated: true)

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - ImageStackCellDelegate
    
    func removeCurrentPhoto(_ row: NSInteger) {
        
        let image = self.imageArray[row]
        self.imageArray.remove(object: image)
        self.maxCount -= 1
        self.checkCameraButton()
        self.photoCollectionView.reloadData()
    }
    
    // MARK: - CameramanDelegate
    
    func cameraManNotAvailable(_ cameraMan: CameraMan) {
        
        
    }
    
    func cameraMan(_ cameraMan: CameraMan, didChangeInput input: AVCaptureDeviceInput) {
        
        
    }
    
    func cameraManDidStart(_ cameraMan: CameraMan) {
        
        setupPreviewLayer()
    }
    
    // MARK: - UICollectionView DataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:  String(describing: ImageStackCell.self), for: indexPath) as? ImageStackCell else {
            return UICollectionViewCell()
        }
        
        if indexPath.row < imageArray.count {
            
            let image = imageArray[indexPath.row]
            cell.configureCell(image, row: indexPath.row)
        }else {
            
            cell.configureCell(nil, row: indexPath.row)

        }
        
        if indexPath.row == imageArray.count - 1 {
            
            
            currentIndexPath = indexPath
        }
        cell.delegate = self
        cell.setNeedsUpdateConstraints()
        cell.updateConstraintsIfNeeded()
        
        return cell
    }


}
