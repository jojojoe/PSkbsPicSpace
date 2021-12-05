//
//  PSkMagicCamVC.swift
//  PSkbsPicSpace
//
//  Created by JOJO on 2021/11/4.
//

import UIKit
import BBMetalImage
import AVFoundation
import DeviceKit
import Photos
import SwiftUI

/*
 https://github.com/Silence-GitHub/BBMetalImage
 
 拍的照片添加拍立得相框
 
 */

class PSkMagicCamVC: UIViewController {

    private var camera: BBMetalCamera!
    private var metalView: BBMetalView!
//    private var imageSource: BBMetalStaticImageSource?
    
    
    var backBtn = UIButton(type: .custom)
    var takePhotoBtn = UIButton(type: .custom)
    var camPositionBtn = UIButton(type: .custom)
    let filterBar = PSkMagicCamFilterBar()
    let vipProBar = UIView()
    
//    var currentApplyingFilter: BBMetalBaseFilter?
    var currentApplyingFilterItem: CamFilterItem?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        camera.start()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        camera.stop()
        
    }
    
    func setupView() {
        //
        view.backgroundColor(.white)
        
        //
        var topOffset: CGFloat = 60
        var leftOffset: CGFloat = 20
        if Device.current.diagonal <= 4.7 || Device.current.diagonal >= 7.0 {
            leftOffset = 50
            topOffset = 50
        }
        let width: CGFloat = UIScreen.main.bounds.width - (leftOffset * 2)
        let height: CGFloat = width
        
        metalView = BBMetalView(frame: CGRect(x: leftOffset, y: topOffset, width: width, height: height))
        metalView.adhere(toSuperview: view)
        metalView.backgroundColor(.purple)
        //
        camera = BBMetalCamera(sessionPreset: .hd1920x1080)
        camera.add(consumer: metalView)
        /*
         hd4K3840x2160
         let topOffsety: Float = ((3840 - 2160) / 2) / 3840
         let heightP: Float = 2160 / 3840
         */
        //

        filterBar.backgroundColor(.lightText)
        filterBar.adhere(toSuperview: view)
        filterBar.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(metalView.snp.bottom).offset(100)
            $0.height.equalTo(70)
        }
        filterBar.camFilterBarClickBlock = {
            [weak self] filterItem in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                self.updateFilterItem(item: filterItem)
            }
        }
        
        //
        
        vipProBar
            .backgroundColor(.darkGray)
            .adhere(toSuperview: view)
        vipProBar.layer.cornerRadius = 10
        vipProBar.layer.masksToBounds = true
        vipProBar.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(filterBar.snp.top).offset(-20)
            $0.height.equalTo(60)
            $0.width.equalTo(UIScreen.main.bounds.width - 80)
        }
        
        //
        let bottomBar = UIView()
        bottomBar
            .backgroundColor(.white)
            .adhere(toSuperview: view)
        bottomBar.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.top.equalTo(filterBar.snp.bottom)
        }
        
        //
        takePhotoBtn
            .image("")
            .backgroundColor(UIColor.orange)
            .adhere(toSuperview: bottomBar)
        takePhotoBtn.layer.cornerRadius = 90/2
        takePhotoBtn.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(90)
        }
        takePhotoBtn.addTarget(self, action: #selector(takePhotoBtnClick(sender: )), for: .touchUpInside)
        //
        backBtn
            .backgroundColor(UIColor.lightGray)
            .image(UIImage(named: ""))
            .adhere(toSuperview: bottomBar)
        backBtn.addTarget(self, action: #selector(backBtnClick(sender: )), for: .touchUpInside)
        backBtn.snp.makeConstraints {
            $0.centerY.equalTo(bottomBar.snp.centerY)
            $0.left.equalToSuperview().offset(25)
            $0.width.height.equalTo(50)
        }
        //
        camPositionBtn
            .backgroundColor(UIColor.lightGray)
            .image(UIImage(named: ""))
            .adhere(toSuperview: bottomBar)
        camPositionBtn.addTarget(self, action: #selector(camPositionBtnClick(sender: )), for: .touchUpInside)
        camPositionBtn.snp.makeConstraints {
            $0.centerY.equalTo(bottomBar.snp.centerY)
            $0.right.equalToSuperview().offset(-25)
            $0.width.height.equalTo(50)
        }
        
        
        
    }

    

}

extension PSkMagicCamVC {
    func updateFilterItem(item: CamFilterItem) {
        camera.removeAllConsumers()
        currentApplyingFilterItem = item
        guard let filter = item.filter else {
            camera.add(consumer: metalView)
            camera.willTransmitTexture = nil
//            imageSource = nil
            return
        }
        //
        camera.add(consumer: filter).add(consumer: metalView)
        
         
//            imageSource?.removeAllConsumers()
//            imageSource = nil
        
//        if let source = imageSource {
//            camera.willTransmitTexture = { [weak self] _, _ in
//                guard self != nil else { return }
//                source.transmitTexture()
//            }
//            source.add(consumer: filter)
//        }
        
    }
    
    func takePhotoProcess(image: UIImage) {
        //
        var finalImg: UIImage = image
        
        if camera.position == .front {
            // flip
            let mirrorFilter = BBMetalFlipFilter(horizontal: true, vertical: false)
            if let img = mirrorFilter.filteredImage(with: finalImg) {
                finalImg = img
            }
        }
        
        // crop
        let topOffsety: Float = ((1920 - 1080) / 2) / 1920
        let heightP: Float = 1080 / 1920
        let cropFilter = BBMetalCropFilter(rect: BBMetalRect(x: 0, y: topOffsety, width: 1, height: heightP))
        
        if let img = cropFilter.filteredImage(with: finalImg) {
            if let applyFilter = currentApplyingFilterItem?.makeFilter(), let filteredImg = applyFilter.filteredImage(with: img) {
                saveImgsToAlbum(imgs: [filteredImg])
            } else {
                saveImgsToAlbum(imgs: [img])
            }
        }
    }
    
    
    
}
extension PSkMagicCamVC {
    
    @objc func backBtnClick(sender: UIButton) {
        if self.navigationController != nil {
            self.navigationController?.popViewController()
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }

    @objc func takePhotoBtnClick(sender: UIButton) {
        
        camera.capturePhoto { [weak self] info in
            switch info.result {
            case let .success(texture):
                DispatchQueue.main.async {
                    [weak self] in
                    guard let `self` = self else {return}
                    if let img = texture.bb_image {
                        self.takePhotoProcess(image: img)
                    }
                }
            case let .failure(error):
                print("Error: \(error)")
            }
        }
    }
    
    @objc func camPositionBtnClick(sender: UIButton) {
        camera.switchCameraPosition()
    }
       
}

extension PSkMagicCamVC {
    
}

extension PSkMagicCamVC {
    
    func saveImgsToAlbum(imgs: [UIImage]) {
        HUD.hide()
        let status = PHPhotoLibrary.authorizationStatus()
        if status == .authorized {
            saveToAlbumPhotoAction(images: imgs)
        } else if status == .notDetermined {
            PHPhotoLibrary.requestAuthorization({[weak self] (status) in
                guard let `self` = self else {return}
                DispatchQueue.main.async {
                    if status != .authorized {
                        return
                    }
                    self.saveToAlbumPhotoAction(images: imgs)
                }
            })
        } else {
            // 权限提示
            albumPermissionsAlet()
        }
    }
    
    func saveToAlbumPhotoAction(images: [UIImage]) {
        DispatchQueue.main.async(execute: {
            PHPhotoLibrary.shared().performChanges({
                [weak self] in
                guard let `self` = self else {return}
                for img in images {
                    PHAssetChangeRequest.creationRequestForAsset(from: img)
                }
                DispatchQueue.main.async {
                    [weak self] in
                    guard let `self` = self else {return}
                    self.showSaveSuccessAlert()
                }
                
            }) { (finish, error) in
                if error != nil {
                    HUD.error("Sorry! please try again")
                }
            }
        })
    }
    
    func showSaveSuccessAlert() {
        DispatchQueue.main.async {
            let title = ""
            let message = "Photo saved successfully!"
            let okText = "OK"
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okButton = UIAlertAction(title: okText, style: .cancel, handler: { (alert) in
                 DispatchQueue.main.async {
                 }
            })
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    func albumPermissionsAlet() {
        let alert = UIAlertController(title: "Ooops!", message: "You have declined access to photos, please active it in Settings>Privacy>Photos.", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default) { [weak self] (actioin) in
            self?.openSystemAppSetting()
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
        }
        alert.addAction(okButton)
        alert.addAction(cancelButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    func openSystemAppSetting() {
        let url = NSURL.init(string: UIApplication.openSettingsURLString)
        let canOpen = UIApplication.shared.canOpenURL(url! as URL)
        if canOpen {
            UIApplication.shared.open(url! as URL, options: [:], completionHandler: nil)
        }
    }
 
}
