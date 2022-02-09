//
//  PSkMagicCamEditVC.swift
//  PSkbsPicSpace
//
//  Created by JOJO on 2021/12/6.
//

import UIKit
import DeviceKit
import Photos
import ZKProgressHUD


class PSkMagicCamEditVC: UIViewController {
    var origImg: UIImage
    
    var saveAlbumBtn = UIButton()
    var backBtn = UIButton()
    let borderBar = PSkMagicCamBorderBar()
    var shareBtn = UIButton()
    let siginBtn = UIButton()
    let sigVipImgV = UIImageView()
    let vipAlertView = PSkVipAlertView()
    var contentBgV = UIView()
    var canvasBgV = UIView()
    let borderImgV = UIImageView()
    let userImgV = UIImageView()
    let touchMoveCanvasV = PSkTouchMoveCanvasView()
    let signVC = PSkMagicCamSignatureVC()
    
    var viewDidLayoutSubviewsOnce: Once = Once()
    var currentCanvasFrameItem: CamBorderItem?
    
    var isVipSignature = false
    
    
    init(origImg: UIImage) {
        self.origImg = origImg
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupTouchMoveCanvasV()
        setupVipAlertView()
        
        updateSignatureVipStatus()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        forceOrientationPortrait()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
        self.viewDidLayoutSubviewsOnce.run({
            let firstBorder = PSkMagicCamManager.default.camBorderList[1]
            updateCanvasFrame(item: firstBorder)
            borderBar.currentItem = firstBorder
            borderBar.collection.reloadData()
        })
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            [weak self] in
            guard let `self` = self else {return}
            
        }
    }
    func setupTouchMoveCanvasV() {
        
        touchMoveCanvasV
            .backgroundColor(.clear)
            .clipsToBounds()
            .adhere(toSuperview: canvasBgV)
        touchMoveCanvasV.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
    }
    
    func updateSignatureVipStatus() {
        if PurchaseManager.share.inSubscription {
            sigVipImgV.isHidden = true
        } else {
            sigVipImgV.isHidden = false
        }
        borderBar.collection.reloadData()
    }
    
    func setupView() {
        //
        view.backgroundColor(UIColor(hexString: "#F4F4F4")!)
        
        //
        contentBgV
            .backgroundColor(.clear)
            .adhere(toSuperview: view)
        //
        let toolBar = UIView()
        toolBar.backgroundColor(.white)
            .adhere(toSuperview: view)
        
        //
        let bottomBar = UIView()
        bottomBar
            .backgroundColor(.white)
            .adhere(toSuperview: view)
        bottomBar.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.height.equalTo(120)
        }
        
        //
        saveAlbumBtn
            .image("i_cam_download")
            .adhere(toSuperview: bottomBar)
        saveAlbumBtn.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(90)
        }
        saveAlbumBtn.addTarget(self, action: #selector(saveAlbumBtnClick(sender: )), for: .touchUpInside)
        //
        backBtn
            .image(UIImage(named: "i_cam_back"))
            .adhere(toSuperview: bottomBar)
        backBtn.addTarget(self, action: #selector(backBtnClick(sender: )), for: .touchUpInside)
        backBtn.snp.makeConstraints {
            $0.centerY.equalTo(bottomBar.snp.centerY)
            $0.left.equalToSuperview().offset(25)
            $0.width.height.equalTo(60)
        }
        //
        shareBtn
            .image(UIImage(named: "i_cam_share"))
            .adhere(toSuperview: bottomBar)
        shareBtn.addTarget(self, action: #selector(shareBtnClick(sender: )), for: .touchUpInside)
        shareBtn.snp.makeConstraints {
            $0.centerY.equalTo(bottomBar.snp.centerY)
            $0.right.equalToSuperview().offset(-25)
            $0.width.height.equalTo(60)
        }
        
        //
        
        toolBar.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(bottomBar.snp.top)
            $0.height.equalTo(120)
        }
//        toolBar.layer.cornerRadius = 24
        toolBar.layer.shadowColor = UIColor.lightGray.withAlphaComponent(0.6).cgColor
        toolBar.layer.shadowOffset = CGSize(width: 0, height: 0)
        toolBar.layer.shadowRadius = 3
        toolBar.layer.shadowOpacity = 0.8
        
        //
        
        borderBar.adhere(toSuperview: toolBar)
        borderBar.snp.makeConstraints {
            $0.right.equalToSuperview()
            $0.left.equalToSuperview().offset(100)
            $0.centerY.equalTo(toolBar.snp.centerY)
            $0.height.equalTo(100)
        }
        borderBar.camBorderBarClickBlock = {
            [weak self] borderItem in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                self.updateCanvasFrame(item: borderItem)
            }
        }
        
        //

        siginBtn
            .image(UIImage(named: "i_cam_sig"))
            .adhere(toSuperview: toolBar)
        siginBtn.snp.makeConstraints {
            $0.left.equalTo(25)
            $0.centerY.equalTo(borderBar.snp.centerY)
            $0.height.width.equalTo(60)
                
        }
        siginBtn.addTarget(self, action: #selector(siginBtnClick(sender: )), for: .touchUpInside)
        
        //
        //
        sigVipImgV
            .image("i_viplog")
            .contentMode(.scaleAspectFit)
            .adhere(toSuperview: toolBar)
        sigVipImgV.snp.makeConstraints {
            $0.top.right.equalTo(siginBtn)
            $0.width.equalTo(56/2)
            $0.width.equalTo(37/2)
        }
        
        sigVipImgV.isHidden = false
        
        //
        contentBgV.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.bottom.equalTo(siginBtn.snp.top).offset(-20)
        }
        
        //
        canvasBgV
            .backgroundColor(.white)
            .adhere(toSuperview: contentBgV)
        //
        userImgV
            .contentMode(.scaleAspectFit)
            .adhere(toSuperview: canvasBgV)
        userImgV.image = origImg
        //
        borderImgV
            .contentMode(.scaleAspectFit)
            .adhere(toSuperview: canvasBgV)
        
        //
        let bottomMaskV = UIView()
        bottomMaskV.backgroundColor(.white)
            .adhere(toSuperview: view)
        bottomMaskV.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        
        
    }

    
}

extension PSkMagicCamEditVC {
    func updateCanvasFrame(item: CamBorderItem) {
        if let borderImg = UIImage(named: item.big) {
            borderImgV.image = borderImg
        } else {
            borderImgV.image = nil
        }
        
        
        //
        var canvasTargetWH: CGFloat = 1
        var userImgVTopOffset: CGFloat = 0
        var userImgVLeftOffset: CGFloat = 0
        var userImgVWidth: CGFloat = 0
        var userImgVHeight: CGFloat = 0
        
        if item.imgPosition == "top" {
            canvasTargetWH = 2/3
        } else if item.imgPosition == "bottom" {
            canvasTargetWH = 2/3
        } else if item.imgPosition == "left" {
            canvasTargetWH = 3/2
        } else if item.imgPosition == "right" {
            canvasTargetWH = 3/2
        } else if item.imgPosition == "center" {
            canvasTargetWH = 1
        } else {
            canvasTargetWH = 1
        }
        
        //
        var canvasTop: CGFloat = 0
        var canvasLeft: CGFloat = 0
        
        let canvasBgVWidth: CGFloat = UIScreen.main.bounds.width
        let canvasBgVHeight: CGFloat = contentBgV.frame.maxY - contentBgV.frame.minY
        
        let canvasheight: CGFloat = canvasBgVHeight - (canvasTop * 2)
        let canvaswidth: CGFloat = (canvasBgVWidth - canvasLeft * 2)
        
        
        let canvasWH = canvaswidth / canvasheight
        var fineW: CGFloat = canvaswidth
        var fineH: CGFloat = canvaswidth
        
        if canvasTargetWH > canvasWH {
            fineW = canvaswidth
            fineH = canvaswidth / canvasTargetWH
            canvasTop = (canvasBgVHeight - fineH) / 2
        } else {
            fineH = canvasheight
            fineW = canvasheight * canvasTargetWH
            canvasLeft = (UIScreen.main.bounds.width - fineW) / 2
        }
        let topOffset: CGFloat = (canvasheight - fineH) / 2
        
        //
        let widthP: CGFloat = 7
        let offsetP: CGFloat = 1
        let centerP: CGFloat = 5
        
        if item.imgPosition == "top" {
            userImgVWidth = fineW * (centerP/widthP)
            userImgVHeight = userImgVWidth
            userImgVTopOffset = fineW * (offsetP/widthP)
            userImgVLeftOffset = fineW * (offsetP/widthP)
        } else if item.imgPosition == "bottom" {
            userImgVWidth = fineW * (centerP/widthP)
            userImgVHeight = userImgVWidth
            userImgVTopOffset = fineH - userImgVHeight - (fineW * (offsetP/widthP))
            userImgVLeftOffset = fineW * (offsetP/widthP)
        } else if item.imgPosition == "left" {
            userImgVHeight = fineH * (centerP/widthP)
            userImgVWidth = userImgVHeight
            userImgVTopOffset = fineH * (offsetP/widthP)
            userImgVLeftOffset = fineH * (offsetP/widthP)
        } else if item.imgPosition == "right" {
            userImgVHeight = fineH * (centerP/widthP)
            userImgVWidth = userImgVHeight
            userImgVTopOffset = fineH * (offsetP/widthP)
            userImgVLeftOffset = fineW - userImgVWidth - (fineH * (offsetP/widthP))
        } else if item.imgPosition == "center" {
            userImgVWidth = fineW * (centerP/widthP)
            userImgVHeight = userImgVWidth
            userImgVTopOffset = fineW * (offsetP/widthP)
            userImgVLeftOffset = fineW * (offsetP/widthP)
        } else {
            userImgVWidth = fineW
            userImgVHeight = fineH
            userImgVTopOffset = 0
            userImgVLeftOffset = 0
        }
        
        //
        canvasBgV.frame = CGRect(x: canvasLeft, y: topOffset, width: fineW, height: fineH)
        borderImgV.frame = CGRect(x: 0, y: 0, width: fineW, height: fineH)
        userImgV.frame = CGRect(x: userImgVLeftOffset, y: userImgVTopOffset, width: userImgVWidth, height: userImgVHeight)
        
        if currentCanvasFrameItem?.imgPosition != item.imgPosition {
            currentCanvasFrameItem = item
            if let signV = self.touchMoveCanvasV.subViewList.first as? UIImageView {
                updateTouchMoveSignImgVPosition(moveImgV: signV)
            }
        } else {
            currentCanvasFrameItem = item
        }
        
    }
    
    func addSignPhotos(signImg: UIImage?) {
        
        if let signV = self.touchMoveCanvasV.subViewList.first as? UIImageView {
          
            signV.image = signImg
            
            updateTouchMoveSignImgVPosition(moveImgV: signV)
            return
        }
        guard let img = signImg else { return }
        // add first sign
        var wi: CGFloat = 0
        var he: CGFloat = 0
        if img.size.width / img.size.height > self.touchMoveCanvasV.width / self.touchMoveCanvasV.height {
            wi = self.touchMoveCanvasV.frame.size.width
            he = CGFloat(Int(self.touchMoveCanvasV.frame.size.width * (img.size.height / img.size.width)))
        } else {
            he = self.touchMoveCanvasV.frame.size.height
            wi = CGFloat(Int(self.touchMoveCanvasV.frame.size.height * (img.size.width / img.size.height)))
        }
        let moveImgVFrame = CGRect(x: 0, y: 0, width: wi, height: he)
        
        //
        let moveImgV = UIImageView(image: img)
        moveImgV.frame = moveImgVFrame
        moveImgV.center = CGPoint(x: self.touchMoveCanvasV.width / 2, y: self.touchMoveCanvasV.height / 2)
        moveImgV
            .contentMode(.scaleAspectFill)
            .adhere(toSuperview: self.touchMoveCanvasV)
        self.touchMoveCanvasV.moveV = moveImgV
        self.touchMoveCanvasV.subViewList.append(moveImgV)
        
        //
        if currentCanvasFrameItem?.imgPosition == "top" {
            moveImgV.center = CGPoint(x: moveImgV.center.x, y: self.touchMoveCanvasV.height * 5.5/7)
        } else if currentCanvasFrameItem?.imgPosition == "bottom" {
            moveImgV.center = CGPoint(x: moveImgV.center.x, y: self.touchMoveCanvasV.height * 2.5/7)
        } else if currentCanvasFrameItem?.imgPosition == "left" {
            moveImgV.center = CGPoint(x: self.touchMoveCanvasV.width * 5.5/7, y: moveImgV.center.y)
        } else if currentCanvasFrameItem?.imgPosition == "right" {
            moveImgV.center = CGPoint(x: self.touchMoveCanvasV.width * 2.5/7, y: moveImgV.center.y)
        }
        updateTouchMoveSignImgVPosition(moveImgV: moveImgV)
    }
    
    func updateTouchMoveSignImgVPosition(moveImgV: UIImageView) {
        //
        if currentCanvasFrameItem?.imgPosition == "top" {
            moveImgV.center = CGPoint(x: self.borderImgV.bounds.width / 2, y: self.borderImgV.height * 5.5/7)
        } else if currentCanvasFrameItem?.imgPosition == "bottom" {
            moveImgV.center = CGPoint(x: self.borderImgV.bounds.width / 2, y: self.borderImgV.height * 1.5/7)
        } else if currentCanvasFrameItem?.imgPosition == "left" {
            moveImgV.center = CGPoint(x: self.borderImgV.bounds.width / 2, y: self.borderImgV.bounds.height / 2)
        } else if currentCanvasFrameItem?.imgPosition == "right" {
            moveImgV.center = CGPoint(x: self.borderImgV.bounds.width / 2, y: self.borderImgV.bounds.height / 2)
        } else {
            moveImgV.center = CGPoint(x: self.borderImgV.bounds.width / 2, y: self.borderImgV.bounds.height / 2)
        }
    }
}

extension PSkMagicCamEditVC {
    func processImg() -> UIImage {
         
        
        //TODO: save
        
        let scale: CGFloat = 3
        
        let saveBgRect: CGRect = CGRect(x: 0, y: 0, width: canvasBgV.size.width * scale, height: canvasBgV.size.height * scale)
        let canvas_big: UIView = UIView(frame: saveBgRect)
        
        //
        let saveUserImgVRect: CGRect = CGRect(x: self.userImgV.frame.origin.x * scale, y: self.userImgV.frame.origin.y * scale, width: self.userImgV.bounds.width * scale, height: self.userImgV.bounds.height * scale)
        let saveUserImgV = UIImageView(frame: saveUserImgVRect)
        if let userImg = userImgV.image, let userImgcg = userImg.cgImage {
            saveUserImgV.image = UIImage(cgImage: userImgcg)
        }
        
        saveUserImgV.adhere(toSuperview: canvas_big)
        //
        let saveBorderImgVRect: CGRect = CGRect(x: self.borderImgV.frame.origin.x * scale, y: self.borderImgV.frame.origin.y * scale, width: self.borderImgV.bounds.width * scale, height: self.borderImgV.bounds.height * scale)
        
        let saveBorderImgV = UIImageView(frame: saveBorderImgVRect)
        saveBorderImgV.image = UIImage(cgImage: borderImgV.image!.cgImage!)
        saveBorderImgV.adhere(toSuperview: canvas_big)
        
        //
        if let signAddonV = self.touchMoveCanvasV.subViewList.first as? UIImageView, let signImg = signAddonV.image {
            let saveSignAddonFrame: CGRect = CGRect(x: 0, y: 0, width: signAddonV.bounds.width * scale, height: signAddonV.bounds.height * scale)
            let saveSignAddonCenter: CGPoint = CGPoint(x: signAddonV.center.x * scale, y: signAddonV.center.y * scale)
            let saveSignAddon = UIImageView(frame: saveSignAddonFrame)
            saveSignAddon.center = saveSignAddonCenter
            saveSignAddon.image = UIImage(cgImage: signImg.cgImage!)
            saveSignAddon.adhere(toSuperview: canvas_big)
            
            transformNewAddonView(newAddon: saveSignAddon, originAddon: signAddonV, scale: scale)
        }
       
        if let canvasImage_big = canvas_big.screenshot {
            return canvasImage_big
            
        }
        return UIImage()
    }
    
    func transformNewAddonView(newAddon: UIView, originAddon: UIView, scale: CGFloat) {
        
        let originalTransform = originAddon.transform
        let translation = CGPoint(x: originalTransform.tx * scale, y: originalTransform.ty * scale)
        let rotation = atan2(originalTransform.b, originalTransform.a)
        let scaleX = sqrt(originAddon.transform.a * originAddon.transform.a + originAddon.transform.c * originAddon.transform.c)
        let scaleY = sqrt(originAddon.transform.b * originAddon.transform.b + originAddon.transform.d * originAddon.transform.d)
        
        newAddon.transform = newAddon.transform.translatedBy(x: translation.x, y: translation.y)
        newAddon.transform = newAddon.transform.rotated(by: rotation)
        newAddon.transform = newAddon.transform.scaledBy(x: scaleX, y: scaleY)
    }
    
}


extension PSkMagicCamEditVC {
    
    func setupVipAlertView() {
        
        vipAlertView.alpha = 0
        vipAlertView.adhere(toSuperview: view)
        vipAlertView.snp.makeConstraints {
            $0.left.right.bottom.top.equalToSuperview()
        }
        
    }

    func showSubscribeView() {
        // show coin alert
        UIView.animate(withDuration: 0.35) {
            self.vipAlertView.alpha = 1
        }
        self.view.bringSubviewToFront(self.vipAlertView)
        
        vipAlertView.backBtnClickBlock = {
            [weak self] in
            guard let `self` = self else {return}
            UIView.animate(withDuration: 0.25) {
                self.vipAlertView.alpha = 0
            } completion: { finished in
                if finished {
                    
                }
            }
        }
        
        vipAlertView.subscribeSuccessBlock = {
            [weak self] purchaseDetail in
            guard let `self` = self else {return}
            ZKProgressHUD.showSuccess("Subscription successful!".localized(), maskStyle: nil, onlyOnceFont: nil, autoDismissDelay: 1.5, completion: nil)
            self.updateSignatureVipStatus()
            //
            UIView.animate(withDuration: 0.25) {
                self.vipAlertView.alpha = 0
            } completion: { finished in
                if finished {
                    
                }
            }
        }
    }
}

extension PSkMagicCamEditVC {
    
    @objc func saveAlbumBtnClick(sender: UIButton) {
        //
        var isVip = false
        
        if isVipSignature == true {
            isVip = true
        } else if borderBar.isVipBorder == true {
            isVip = true
        }
        
        if isVip {
            if PurchaseManager.share.inSubscription {
                let saveImg = processImg()
                saveImgsToAlbum(imgs: [saveImg])
            } else {
                showSubscribeView()
            }
        } else {
            let saveImg = processImg()
            saveImgsToAlbum(imgs: [saveImg])
        }
        
    }
    
    @objc func shareBtnClick(sender: UIButton) {
        
        
        //
        var isVip = false
        
        if isVipSignature == true {
            isVip = true
        } else if borderBar.isVipBorder == true {
            isVip = true
        }
        
        if isVip {
            if PurchaseManager.share.inSubscription {
                shareAction()
            } else {
                showSubscribeView()
            }
        } else {
            shareAction()
        }
    }
    
    @objc func backBtnClick(sender: UIButton) {
        if self.navigationController != nil {
            self.navigationController?.popViewController()
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    @objc func siginBtnClick(sender: UIButton) {
        forceOrientationLandscape()
        
        self.navigationController?.pushViewController(signVC, animated: true)
        signVC.camSignatureOkBlock = {
            [weak self] signImg in
            guard let `self` = self else {return}
            debugPrint(signImg)
            DispatchQueue.main.async {
                if let signImg_m = signImg {
                    self.addSignPhotos(signImg: signImg_m)
                    self.isVipSignature = true
                } else {
                    self.isVipSignature = false
                }
            }
        }
    }
}

extension PSkMagicCamEditVC  {
    func shareAction() {
        
        let saveImg = processImg()
        
        let ac = UIActivityViewController(activityItems: [saveImg], applicationActivities: nil)
        ac.modalPresentationStyle = .fullScreen
        ac.completionWithItemsHandler = {
            (type, flag, array, error) -> Void in
            if flag == true {
                 
            } else {
                
            }
        }
        self.present(ac, animated: true, completion: nil)
    }
}

extension PSkMagicCamEditVC {
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
            let message = "Photo saved successfully!".localized()
            let okText = "OK".localized()
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
        let alert = UIAlertController(title: "Ooops!".localized(), message: "You have declined access to photos, please active it in Settings>Privacy>Photos.".localized(), preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK".localized(), style: .default) { [weak self] (actioin) in
            self?.openSystemAppSetting()
        }
        let cancelButton = UIAlertAction(title: "Cancel".localized(), style: .cancel) { (action) in
            
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

extension PSkMagicCamEditVC {
    // 强制旋转横屏
    func forceOrientationLandscape() {
        let appdelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        appdelegate.isForceLandscape = true
        appdelegate.isForcePortrait = false
        _ = appdelegate.application(UIApplication.shared, supportedInterfaceOrientationsFor: view.window)
        let oriention = UIInterfaceOrientation.landscapeRight // 设置屏幕为横屏
        UIDevice.current.setValue(oriention.rawValue, forKey: "orientation")
        UIViewController.attemptRotationToDeviceOrientation()
    }
    // 强制旋转竖屏
    func forceOrientationPortrait() {
        let appdelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate.isForceLandscape = false
        appdelegate.isForcePortrait = true
        _ = appdelegate.application(UIApplication.shared, supportedInterfaceOrientationsFor: view.window)
        let oriention = UIInterfaceOrientation.portrait // 设置屏幕为竖屏
        UIDevice.current.setValue(oriention.rawValue, forKey: "orientation")
        UIViewController.attemptRotationToDeviceOrientation()
    }
}

