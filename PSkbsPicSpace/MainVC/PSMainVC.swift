//
//  PSMainVC.swift
//  PSkbsPicSpace
//
//  Created by JOJO on 2021/10/29.
//

import UIKit
import Photos
import YPImagePicker
import DeviceKit



class PSMainVC: UIViewController, UINavigationControllerDelegate {

    var isActionType: String = ""
    var isLock = false
    
    
    override func viewDidLoad() {
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.isLock = false
    }
    
}

extension PSMainVC {
    func setupView() {
        view
            .backgroundColor(UIColor.white)
        //
        let settingBtn = UIButton(type: .custom)
        settingBtn
            .backgroundColor(UIColor.lightGray)
            .adhere(toSuperview: view)
        settingBtn.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.width.equalTo(44)
            $0.height.equalTo(44)
        }
        //
        let vipBtn = UIButton(type: .custom)
        vipBtn
            .backgroundColor(UIColor.lightGray)
            .adhere(toSuperview: view)
        vipBtn.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-10)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-10)
            $0.width.equalTo(64)
            $0.height.equalTo(64)
        }
        
        //
        //
        let magicCamBtn = UIButton(type: .custom)
        magicCamBtn
            .text("Cam")
            .backgroundColor(UIColor.lightGray)
            .text("Cam")
            .adhere(toSuperview: view)
        magicCamBtn.snp.makeConstraints {
            $0.right.equalTo(view.snp.centerX).offset(-20)
            $0.bottom.equalTo(view.snp.centerY).offset(-20)
            $0.width.equalTo(140)
            $0.height.equalTo(60)
        }
        magicCamBtn.addTarget(self, action: #selector(magicCamBtnClick(sender: )), for: .touchUpInside)
        
        //
        let slideBtn = UIButton(type: .custom)
        slideBtn
            .text("Slide")
            .backgroundColor(UIColor.lightGray)
            .text("Slid")
            .adhere(toSuperview: view)
        slideBtn.snp.makeConstraints {
            $0.left.equalTo(view.snp.centerX).offset(20)
            $0.top.equalTo(view.snp.centerY).offset(20)
            $0.width.equalTo(140)
            $0.height.equalTo(60)
        }
        slideBtn.addTarget(self, action: #selector(slideBtnClick(sender: )), for: .touchUpInside)
        
        //
        let customPhotoBtn = UIButton(type: .custom)
        customPhotoBtn
            .text("Custom")
            .backgroundColor(UIColor.lightGray)
            .text("Custom")
            .adhere(toSuperview: view)
        customPhotoBtn.snp.makeConstraints {
            $0.left.equalTo(view.snp.centerX).offset(20)
            $0.bottom.equalTo(magicCamBtn.snp.top).offset(-40)
            $0.width.equalTo(140)
            $0.height.equalTo(60)
        }
        customPhotoBtn.addTarget(self, action: #selector(customPhotoBtnClick(sender: )), for: .touchUpInside)
        
        //
        let profileMakerBtn = UIButton(type: .custom)
        profileMakerBtn
            .text("Profile")
            .backgroundColor(UIColor.lightGray)
            .text("ProfileMake")
            .adhere(toSuperview: view)
        profileMakerBtn.snp.makeConstraints {
            $0.right.equalTo(view.snp.centerX).offset(-20)
            $0.top.equalTo(slideBtn.snp.bottom).offset(40)
            $0.width.equalTo(140)
            $0.height.equalTo(60)
        }
        profileMakerBtn.addTarget(self, action: #selector(profileMakerBtnClick(sender: )), for: .touchUpInside)
        
        
        
        
    }
    
    
}

extension PSMainVC {
    @objc func slideBtnClick(sender: UIButton) {
        isActionType = "slide"
        checkAlbumAuthorization()
    }
    @objc func magicCamBtnClick(sender: UIButton) {
        
    }
    @objc func customPhotoBtnClick(sender: UIButton) {
        
    }
    @objc func profileMakerBtnClick(sender: UIButton) {
        let vc = PSkProfileMakerVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
}


extension PSMainVC: UIImagePickerControllerDelegate {
    
    func checkAlbumAuthorization() {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            if #available(iOS 14, *) {
                PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                    switch status {
                    case .authorized:
                        DispatchQueue.main.async {
//                            self.presentPhotoPickerController()
                            self.presentLimitedPhotoPickerController()
                        }
                    case .limited:
                        DispatchQueue.main.async {
                            self.presentLimitedPhotoPickerController()
                        }
                    case .notDetermined:
                        if status == PHAuthorizationStatus.authorized {
                            DispatchQueue.main.async {
//                                self.presentPhotoPickerController()
                                self.presentLimitedPhotoPickerController()
                            }
                        } else if status == PHAuthorizationStatus.limited {
                            DispatchQueue.main.async {
                                self.presentLimitedPhotoPickerController()
                            }
                        }
                    case .denied:
                        DispatchQueue.main.async {
                            [weak self] in
                            guard let `self` = self else {return}
                            let alert = UIAlertController(title: "Oops", message: "You have declined access to photos, please active it in Settings>Privacy>Photos.", preferredStyle: .alert)
                            let confirmAction = UIAlertAction(title: "Ok", style: .default, handler: { (goSettingAction) in
                                DispatchQueue.main.async {
                                    let url = URL(string: UIApplication.openSettingsURLString)!
                                    UIApplication.shared.open(url, options: [:])
                                }
                            })
                            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
                            alert.addAction(confirmAction)
                            alert.addAction(cancelAction)
                            
                            self.present(alert, animated: true)
                        }
                        
                    case .restricted:
                        DispatchQueue.main.async {
                            [weak self] in
                            guard let `self` = self else {return}
                            let alert = UIAlertController(title: "Oops", message: "You have declined access to photos, please active it in Settings>Privacy>Photos.", preferredStyle: .alert)
                            let confirmAction = UIAlertAction(title: "Ok", style: .default, handler: { (goSettingAction) in
                                DispatchQueue.main.async {
                                    let url = URL(string: UIApplication.openSettingsURLString)!
                                    UIApplication.shared.open(url, options: [:])
                                }
                            })
                            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
                            alert.addAction(confirmAction)
                            alert.addAction(cancelAction)
                            
                            self.present(alert, animated: true)
                        }
                    default: break
                    }
                }
            } else {
                
                PHPhotoLibrary.requestAuthorization { status in
                    switch status {
                    case .authorized:
                        DispatchQueue.main.async {
                            self.presentPhotoPickerController()
                        }
                    case .limited:
                        DispatchQueue.main.async {
                            self.presentLimitedPhotoPickerController()
                        }
                    case .denied:
                        DispatchQueue.main.async {
                            [weak self] in
                            guard let `self` = self else {return}
                            let alert = UIAlertController(title: "Oops", message: "You have declined access to photos, please active it in Settings>Privacy>Photos.", preferredStyle: .alert)
                            let confirmAction = UIAlertAction(title: "Ok", style: .default, handler: { (goSettingAction) in
                                DispatchQueue.main.async {
                                    let url = URL(string: UIApplication.openSettingsURLString)!
                                    UIApplication.shared.open(url, options: [:])
                                }
                            })
                            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
                            alert.addAction(confirmAction)
                            alert.addAction(cancelAction)
                            
                            self.present(alert, animated: true)
                        }
                        
                    case .restricted:
                        DispatchQueue.main.async {
                            [weak self] in
                            guard let `self` = self else {return}
                            let alert = UIAlertController(title: "Oops", message: "You have declined access to photos, please active it in Settings>Privacy>Photos.", preferredStyle: .alert)
                            let confirmAction = UIAlertAction(title: "Ok", style: .default, handler: { (goSettingAction) in
                                DispatchQueue.main.async {
                                    let url = URL(string: UIApplication.openSettingsURLString)!
                                    UIApplication.shared.open(url, options: [:])
                                }
                            })
                            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
                            alert.addAction(confirmAction)
                            alert.addAction(cancelAction)
                            
                            self.present(alert, animated: true)
                        }
                    default: break
                    }
                }
                
            }
        }
    }
    
    func presentLimitedPhotoPickerController() {
        var config = YPImagePickerConfiguration()
        config.library.maxNumberOfItems = 1
        config.screens = [.library]
        config.library.defaultMultipleSelection = false
        config.library.isSquareByDefault = false
        config.library.skipSelectionsGallery = true
        config.showsPhotoFilters = false
        config.library.preselectedItems = nil
        let picker = YPImagePicker(configuration: config)
        picker.view.backgroundColor(UIColor.white)
        picker.didFinishPicking { [unowned picker] items, cancelled in
            var imgs: [UIImage] = []
            for item in items {
                switch item {
                case .photo(let photo):
                    imgs.append(photo.image)
                    print(photo)
                case .video(let video):
                    print(video)
                }
            }
            picker.dismiss(animated: true, completion: nil)
            if !cancelled {
                if let image = imgs.first {
                    self.showEditVC(image: image)
                }
            }
        }
        picker.navigationBar.backgroundColor = UIColor.white
        present(picker, animated: true, completion: nil)
    }
    
     
 
    func presentPhotoPickerController() {
        let myPickerController = UIImagePickerController()
        myPickerController.allowsEditing = false
        myPickerController.delegate = self
        myPickerController.sourceType = .photoLibrary
        self.present(myPickerController, animated: true, completion: nil)

    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.showEditVC(image: image)
        } else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.showEditVC(image: image)
        }

    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func showEditVC(image: UIImage) {
        
        if isLock == true {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                
            }
        } else {
            isLock = true
            DispatchQueue.main.async {
                [weak self] in
                guard let `self` = self else {return}
                if self.isActionType == "slide" {
                    let vc = PSkPhotoSlideVC(originalImg: image)
                    self.navigationController?.pushViewController(vc, animated: true)
                } else if self.isActionType == "" {
                     
                }
            }
        }
    }

}










