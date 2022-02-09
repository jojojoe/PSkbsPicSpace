//
//  PSkProfileMakerVC.swift
//  PSkbsPicSpace
//
//  Created by JOJO on 2021/11/4.
//

import UIKit
import ZKProgressHUD
import YPImagePicker
import Photos
import CoreML


class PSkProfileMakerVC: UIViewController, UINavigationControllerDelegate {

    let backBtn = UIButton(type: .custom)
    
    let contentBgV = UIView()
    let canvasV = UIView()
    let canvasBgV = UIView()
    let frameBtn = PSkProfileMakerBottomBtn(frame: .zero, nameStr: "i_profile_size")
    let bgBtn = PSkProfileMakerBottomBtn(frame: .zero, nameStr: "i_profile_color")
    let photoBtn = PSkProfileMakerBottomBtn(frame: .zero, nameStr: "i_profile_photo")
    let frameBar = PSkProfileFrameToolView()
    let bgColorBar = PSkProfileBgToolView()
    let photoBar = PSkProfilePhotoToolView()
    let touchMoveCanvasV = PSkTouchMoveCanvasView()
    var viewDidLayoutSubviewsOnce: Once = Once()
    let vipAlertView = PSkVipAlertView()
    
    
    var canvasTargetWH: CGFloat = 1 // 1 , 3/4 9/16 16/9
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTouchMoveCanvasV()
        setupToolView()
        setupBarBlockAction()
        setupVipAlertView()
        setupDefaultStatus()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        updateCanvasFrame()
        
    }
    
    func setupDefaultStatus() {
        self.touchMoveCanvasV.backgroundColor(UIColor.white)
        self.canvasV.backgroundColor(UIColor.white)
    }
    
    func updateCanvasFrame() {
        var canvasLeft: CGFloat = 20
        let canvasheight: CGFloat = contentBgV.frame.maxY - contentBgV.frame.minY
        let canvaswidth: CGFloat = (UIScreen.main.bounds.width - canvasLeft * 2)
        
        
        let canvasWH = canvaswidth / canvasheight
        var fineW: CGFloat = canvaswidth
        var fineH: CGFloat = canvaswidth
        
        if canvasTargetWH > canvasWH {
            fineW = canvaswidth
            fineH = canvaswidth / canvasTargetWH
        } else {
            fineH = canvasheight
            fineW = canvasheight * canvasTargetWH
            canvasLeft = (UIScreen.main.bounds.width - fineW) / 2
        }
        let topOffset: CGFloat = (canvasheight - fineH) / 2
        
        canvasV.frame = CGRect(x: canvasLeft, y: topOffset, width: fineW, height: fineH)
         
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            [weak self] in
            guard let `self` = self else {return}
            self.viewDidLayoutSubviewsOnce.run({
                self.checkAlbumAuthorization()
            })
        }
    }
   
    
    func setupView() {
        //
        view.backgroundColor(UIColor(hexString: "#F4F4F4")!)
        
        //
        let topBanner = UIView()
        topBanner.backgroundColor(.white)
            .adhere(toSuperview: view)
        topBanner.snp.makeConstraints {
            $0.left.right.top.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).offset(44)
        }
        
        backBtn
            .image(UIImage(named: "i_back"))
            .adhere(toSuperview: topBanner)
        backBtn.addTarget(self, action: #selector(backBtnClick(sender: )), for: .touchUpInside)
        backBtn.snp.makeConstraints {
            $0.bottom.equalTo(topBanner.snp.bottom).offset(0)
            $0.left.equalTo(10)
            $0.width.height.equalTo(44)
        }
        //
        //
        let saveBtn = UIButton(type: .custom)
        saveBtn
            .image(UIImage(named: "i_download"))
            .adhere(toSuperview: topBanner)
        saveBtn.addTarget(self, action: #selector(saveBtnClick(sender: )), for: .touchUpInside)
        saveBtn.snp.makeConstraints {
            $0.bottom.equalTo(topBanner.snp.bottom).offset(0)
            $0.right.equalTo(-10)
            $0.width.height.equalTo(44)
        }
        
        
        //
        
        contentBgV
            .clipsToBounds()
            .backgroundColor(.clear)
            .adhere(toSuperview: view)
        contentBgV.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(backBtn.snp.bottom).offset(5)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-100)
        }
        
        //
        canvasBgV
            .clipsToBounds()
            .backgroundColor(.clear)
            .adhere(toSuperview: contentBgV)
        canvasBgV.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalToSuperview()
        }
        
        //
        canvasV
            .clipsToBounds()
            .backgroundColor(.white)
            .adhere(toSuperview: canvasBgV)
        canvasV.layer.shadowColor = UIColor.darkGray.withAlphaComponent(0.5).cgColor
        canvasV.layer.shadowOffset = CGSize(width: 0, height: 0)
        canvasV.layer.shadowRadius = 6
        canvasV.layer.shadowOpacity = 0.8
        
        
        
        
        //
        let bottomBarHeight: CGFloat = 130
        let bottomBar = UIView()
        bottomBar
            .backgroundColor(UIColor.white)
            .adhere(toSuperview: view)
        bottomBar.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.height.equalTo(bottomBarHeight)
        }
        let bottomMaskBar = UIView()
        bottomMaskBar
            .backgroundColor(UIColor.white)
            .adhere(toSuperview: view)
        bottomMaskBar.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        //
        let btnWidth: CGFloat = 60
        let btnHeight: CGFloat = 60
        let btnPadding: CGFloat = (UIScreen.main.bounds.width - btnWidth * 3) / 4
        
        frameBtn.adhere(toSuperview: bottomBar)
        bgBtn.adhere(toSuperview: bottomBar)
        photoBtn.adhere(toSuperview: bottomBar)
        
        frameBtn.snp.makeConstraints {
            $0.left.equalToSuperview().offset(btnPadding)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(btnWidth)
            $0.height.equalTo(btnHeight)
        }
        
        bgBtn.snp.makeConstraints {
            $0.left.equalTo(frameBtn.snp.right).offset(btnPadding)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(btnWidth)
            $0.height.equalTo(btnHeight)
        }
        
        photoBtn.snp.makeConstraints {
            $0.left.equalTo(bgBtn.snp.right).offset(btnPadding)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(btnWidth)
            $0.height.equalTo(btnHeight)
        }
        
        
        frameBtn.addTarget(self, action: #selector(frameBtnClick(sender: )), for: .touchUpInside)
        bgBtn.addTarget(self, action: #selector(bgBtnClick(sender: )), for: .touchUpInside)
        photoBtn.addTarget(self, action: #selector(photoBtnClick(sender: )), for: .touchUpInside)
        
        
    }

    func setupToolView() {

        frameBar.adhere(toSuperview: view)
        frameBar.backBtnClickBlock = {
            [weak self] in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                self.showFrameBarStatus(isShow: false)
            }
        }
        frameBar.selectProfileFrameBlock = {
            [weak self] fWidth, fHeight in
            guard let `self` = self else {return}
            PSkProfileManager.default.currentCanvasWidth = fWidth
            PSkProfileManager.default.currentCanvasHeight = fHeight
            self.canvasTargetWH = fWidth / fHeight
            DispatchQueue.main.async {
                [weak self] in
                guard let `self` = self else {return}
                self.updateCanvasFrame()
            }
            
        }
        frameBar.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        frameBar.isHidden = true
        //

        bgColorBar.adhere(toSuperview: view)
        bgColorBar.backBtnClickBlock = {
            [weak self] in
            guard let `self` = self else {return}
            self.showBgBarStatus(isShow: false)
        }
        bgColorBar.selectColorBlock = {
            [weak self] bgColor in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                [weak self] in
                guard let `self` = self else {return}
                self.touchMoveCanvasV.backgroundColor(bgColor)
                self.canvasV.backgroundColor(bgColor)
                PSkProfileManager.default.bgColorPhotoItem.bgColor = bgColor
                self.photoBar.collection.reloadData()
            }
            
        }
        bgColorBar.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        
        
        //
        
        photoBar.adhere(toSuperview: view)
        photoBar.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        
        
        frameBar.isHidden = true
        bgColorBar.isHidden = true
        photoBar.isHidden = true
        
    }
     
    func setupTouchMoveCanvasV() {
        
        touchMoveCanvasV
            
            .backgroundColor(.white)
            .adhere(toSuperview: canvasV)
        touchMoveCanvasV.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
    }
}

extension PSkProfileMakerVC {
    func showFrameBarStatus(isShow: Bool) {
        frameBar.showStatus(isShow: isShow)
        if isShow {
            moveUpCanvasV()
        } else {
            moveDownCanvasV()
        }
    }
    func showBgBarStatus(isShow: Bool) {
        bgColorBar.showStatus(isShow: isShow)
        if isShow {
            moveUpCanvasV()
        } else {
            moveDownCanvasV()
        }
    }
    func showPhotoBarStatus(isShow: Bool) {
        photoBar.collection.reloadData()
        photoBar.showStatus(isShow: isShow)
        if isShow {
            moveUpCanvasV()
        } else {
            moveDownCanvasV()
        }
    }
    
    func moveUpCanvasV() {
        
//        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
//            let cx = self.canvasV.frame.origin.x
//            let cy = self.canvasV.frame.origin.y - 90
//            let cwidth = self.canvasV.frame.size.width
//            let cheight = self.canvasV.frame.size.height
//
//            self.canvasV.frame = CGRect(x: cx, y: cy, width: cwidth, height: cheight)
//        } completion: { finished in
//
//        }

        canvasBgV.snp.remakeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-80)
            $0.width.height.equalToSuperview()
        }
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            self.contentBgV.layoutIfNeeded()
        } completion: { finished in
            
        }
        
        
    }
    func moveDownCanvasV() {
        
//        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
//            let cx = self.canvasV.frame.origin.x
//            let cy = self.canvasV.frame.origin.y + 90
//            let cwidth = self.canvasV.frame.size.width
//            let cheight = self.canvasV.frame.size.height
//
//            self.canvasV.frame = CGRect(x: cx, y: cy, width: cwidth, height: cheight)
//        } completion: { finished in
//
//        }
        
        
        canvasBgV.snp.remakeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(0)
            $0.width.height.equalToSuperview()
        }
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            self.contentBgV.layoutIfNeeded()
        } completion: { finished in
            
        }

    }
}

extension PSkProfileMakerVC {
    
    @objc func backBtnClick(sender: UIButton) {
        PSkProfileManager.default.clearPhotosListData()
        if self.navigationController != nil {
            self.navigationController?.popViewController()
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func saveBtnClick(sender: UIButton) {
        
        if PSkProfileManager.default.photoItemList.count >= 4 {
            if PurchaseManager.share.inSubscription {
                processBigImg()
            } else {
                showSubscribeView()
            }
        } else {
            processBigImg()
        }
        
    }
    
    @objc func frameBtnClick(sender: UIButton) {
        
        showFrameBarStatus(isShow: true)
        
    }
    
    @objc func bgBtnClick(sender: UIButton) {
        showBgBarStatus(isShow: true)
        
    }
    
    @objc func photoBtnClick(sender: UIButton) {
        showPhotoBarStatus(isShow: true)
        
    }
    
    
    

}

extension PSkProfileMakerVC {
    
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

extension PSkProfileMakerVC {
    func addNewPhotos(img: UIImage) {
        
        HUD.show()
        DispatchQueue.global().async {
            let item = ProfilePhotoItem()
            item.bgColor = nil
            item.originImg = img
            item.smartImg = PSkProfileManager.default.processRemoveImageBg(originImg: img)
            item.isRemoveBg = true
            item.isSkinBeauty = true
            item.isMirror = false
            PSkProfileManager.default.userPhotosItem.append(item)
            PSkProfileManager.default.currentItem = item
            PSkProfileManager.default.processUserPhotosItemList()
            
            //
            guard let img = item.smartImg else { return }
            let skinBeautyImg = PSkProfileManager.default.processSkinBeautyFilterImageBg(originImg: img)
            
            DispatchQueue.main.async {
                HUD.hide()
                self.photoBar.collection.reloadData()
                
                //
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
                let moveImgV = UIImageView(image: skinBeautyImg)
                moveImgV.frame = moveImgVFrame
                moveImgV.center = CGPoint(x: self.touchMoveCanvasV.width / 2, y: self.touchMoveCanvasV.height / 2)
                moveImgV
                    .contentMode(.scaleAspectFill)
                    .adhere(toSuperview: self.touchMoveCanvasV)
                self.touchMoveCanvasV.moveV = moveImgV
                self.touchMoveCanvasV.subViewList.append(moveImgV)
            }
            
        }
        
        
    }
    func setupBarBlockAction() {
        photoBar.backBtnClickBlock = {
            [weak self] in
            guard let `self` = self else {return}
            self.showPhotoBarStatus(isShow: false)
        }
        photoBar.addNewPhotoBlock = {
            [weak self] in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                self.checkAlbumAuthorization()
            }
        }
        photoBar.selectUserPhotoBlock = {
            [weak self] item_m in
            guard let `self` = self else {return}
            PSkProfileManager.default.currentItem = item_m
            let index = PSkProfileManager.default.userPhotosItem.firstIndex(of: item_m)
            if let imgV = self.touchMoveCanvasV.subViewList[Int(index ?? 0)] as? UIImageView {
                self.touchMoveCanvasV.moveV = imgV
            }
        }
        
        photoBar.deleteBtnClickBlock = {
            [weak self] item in
            guard let `self` = self else {return}
            guard let item_m = item else { return }
            let index = PSkProfileManager.default.userPhotosItem.firstIndex(of: item_m)
            
            PSkProfileManager.default.userPhotosItem.removeAll(item_m)
            PSkProfileManager.default.processUserPhotosItemList()
            
            //
            let imgV = self.touchMoveCanvasV.subViewList[Int(index ?? 0)]
            imgV.removeFromSuperview()
            self.touchMoveCanvasV.subViewList.removeAll(imgV)
            
            //
            if PSkProfileManager.default.currentItem == item_m {
                if PSkProfileManager.default.userPhotosItem.count >= 1 {
                    let lastIndex = PSkProfileManager.default.userPhotosItem.count - 1
                    let lastItem = PSkProfileManager.default.userPhotosItem[lastIndex]
                    PSkProfileManager.default.currentItem = lastItem
                    
                    //
                    let imgV = self.touchMoveCanvasV.subViewList[lastIndex]
                    self.touchMoveCanvasV.moveV = imgV
                    
                } else {
                    PSkProfileManager.default.currentItem = nil
                    self.touchMoveCanvasV.moveV = nil
                }
                
            }
//            if let item_im = item {
//                PSkProfileManager.default.photoItemList.removeAll(item_im)
//            }
            self.photoBar.collection.reloadData()
            
        }
        photoBar.resetBtnClickBlock = {
            [weak self] item in
            guard let `self` = self else {return}
            guard let item_m = item else { return }
            item_m.isRemoveBg = true
            item_m.isSkinBeauty = true
            item_m.isMirror = false
            self.photoBar.collection.reloadData()
            //
            //
            let index = PSkProfileManager.default.userPhotosItem.firstIndex(of: item_m)
            if let imgV = self.touchMoveCanvasV.subViewList[Int(index ?? 0)] as? UIImageView, let img = item_m.smartImg {
                let skinBeautyImg = PSkProfileManager.default.processSkinBeautyFilterImageBg(originImg: img)
                imgV.image = skinBeautyImg
                imgV.center = CGPoint(x: self.touchMoveCanvasV.width / 2, y: self.touchMoveCanvasV.height / 2)
                imgV.transform = CGAffineTransform.identity
            }
            
        }
        photoBar.removeBgBtnClickBlock = {
            [weak self] item in
            guard let `self` = self else {return}
            guard let item_m = item else { return }
            item_m.isRemoveBg = !(item_m.isRemoveBg ?? true)
            self.photoBar.collection.reloadData()
            //
            self.processTouchCanvasViewImageViewStatus(item_m: item_m)
            //

        }
        photoBar.beautyBtnClickBlock = {
            [weak self] item in
            guard let `self` = self else {return}
            guard let item_m = item else { return }
            item_m.isSkinBeauty = !(item_m.isSkinBeauty ?? true)
            self.photoBar.collection.reloadData()
            //
            self.processTouchCanvasViewImageViewStatus(item_m: item_m)
        }
        photoBar.mirrorBtnClickBlock = {
            [weak self] item in
            guard let `self` = self else {return}
            guard let item_m = item else { return }
            item_m.isMirror = !(item_m.isMirror ?? true)
            self.photoBar.collection.reloadData()
            //
            self.processTouchCanvasViewImageViewStatus(item_m: item_m)
        }
        photoBar.upMoveBtnClickBlock = {
            [weak self] item in
            guard let `self` = self else {return}
            guard let item_m = item else { return }
            if let itemIndex = PSkProfileManager.default.userPhotosItem.firstIndex(of: item_m) {
                PSkProfileManager.default.userPhotosItem.removeAll(item_m)
                PSkProfileManager.default.userPhotosItem.insert(item_m, at: itemIndex - 1)
                PSkProfileManager.default.processUserPhotosItemList()
                self.photoBar.collection.reloadData()
                
                //
                let imgV = self.touchMoveCanvasV.subViewList[itemIndex]
                self.touchMoveCanvasV.subViewList.remove(at: itemIndex)
                self.touchMoveCanvasV.subViewList.insert(imgV, at: itemIndex - 1)
                //
                imgV.removeFromSuperview()
                self.touchMoveCanvasV.insertSubview(imgV, at: itemIndex - 1)
                
            }
        }
        photoBar.downMoveBtnClickBlock = {
            [weak self] item in
            guard let `self` = self else {return}
            guard let item_m = item else { return }
            if let itemIndex = PSkProfileManager.default.userPhotosItem.firstIndex(of: item_m) {
                PSkProfileManager.default.userPhotosItem.removeAll(item_m)
                if itemIndex + 1 == PSkProfileManager.default.userPhotosItem.count {
                    PSkProfileManager.default.userPhotosItem.append(item_m)
                } else {
                    PSkProfileManager.default.userPhotosItem.insert(item_m, at: itemIndex + 1)
                }
                PSkProfileManager.default.processUserPhotosItemList()
                self.photoBar.collection.reloadData()
                
                //
                let imgV = self.touchMoveCanvasV.subViewList[itemIndex]
                self.touchMoveCanvasV.subViewList.remove(at: itemIndex)
                if itemIndex + 1 == self.touchMoveCanvasV.subViewList.count {
                    self.touchMoveCanvasV.subViewList.append(imgV)
                } else {
                    self.touchMoveCanvasV.subViewList.insert(imgV, at: itemIndex + 1)
                }
                
                //
                imgV.removeFromSuperview()
                if itemIndex + 1 == self.touchMoveCanvasV.subviews.count {
                    self.touchMoveCanvasV.addSubview(imgV)
                } else {
                    self.touchMoveCanvasV.insertSubview(imgV, at: itemIndex + 1)
                }
            }
        }
    }
    
    
    
    func processTouchCanvasViewImageViewStatus(item_m: ProfilePhotoItem) {
        let index = PSkProfileManager.default.userPhotosItem.firstIndex(of: item_m)
        if let imgV = self.touchMoveCanvasV.subViewList[Int(index ?? 0)] as? UIImageView {
            var proImg: UIImage?
            
            if item_m.isRemoveBg == true {
                proImg = item_m.smartImg
            } else {
                proImg = item_m.originImg
            }
            if item_m.isSkinBeauty == true, let proImg_m = proImg {
                proImg = PSkProfileManager.default.processSkinBeautyFilterImageBg(originImg: proImg_m)
            }
            if item_m.isMirror == true, let proImg_m = proImg {
                proImg = proImg_m.withHorizontallyFlippedOrientation()
            }
             
            imgV.image = proImg
        }
    }
    
}

extension PSkProfileMakerVC {
    func processBigImg() {
        let bigCanvasV = UIView()
        bigCanvasV.backgroundColor = touchMoveCanvasV.backgroundColor
        let bigwidth: CGFloat = PSkProfileManager.default.currentCanvasWidth ?? 1000
        let bigheight: CGFloat = PSkProfileManager.default.currentCanvasHeight ?? 1000
        bigCanvasV.frame = CGRect(x: 0, y: 0, width: bigwidth, height: bigheight)
        let scaleWH = bigwidth / touchMoveCanvasV.width
        
        for imgV in touchMoveCanvasV.subviews {
            if let imgV_m = imgV as? UIImageView {
                let bigImgV = UIImageView()
                let bigImgVBound = CGRect(x: 0, y: 0, width: imgV_m.bounds.width * scaleWH, height: imgV_m.bounds.height * scaleWH)
                bigImgV.bounds = bigImgVBound
                
                let bigImgVCenter = CGPoint(x: imgV_m.center.x * scaleWH, y: imgV_m.center.y * scaleWH)
                bigImgV.center = bigImgVCenter
                if let i = imgV_m.image?.cgImage {
                    bigImgV.image = UIImage(cgImage: i)
                }
                bigImgV.adhere(toSuperview: bigCanvasV)
                // trans
                
                bigImgV.transform = imgV_m.transform
                
            }
        }
        
        //
        let canvasSize = CGSize(width: bigwidth, height: bigheight)
        
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, 1)
        defer {
            UIGraphicsEndImageContext()
        }
        guard let context = UIGraphicsGetCurrentContext() else { return }
        bigCanvasV.layer.render(in: context)
        
        if let bigImg = UIGraphicsGetImageFromCurrentImageContext() {
            self.showSavePopupView(image: bigImg)
        }
        
        
        
//        saveImgsToAlbum(imgs: [imgpng])

        

        
        
        
    }
 
    func showSavePopupView(image: UIImage) {
        
        let popupView = PSkProfileSavePopupView(frame: .zero, originImg: image)
        view.addSubview(popupView)
        popupView.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        popupView.backBtnClickBlock = {
            UIView.animate(withDuration: 0.25) {
                popupView.alpha = 0
            } completion: { finished in
                if finished {
                    popupView.removeFromSuperview()
                }
            }
        }
        
        popupView.saveToAlbumBtnClickBlock = {
            [weak self] img in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                self.saveImgsToAlbum(imgs: [img])
            }
            UIView.animate(withDuration: 0.25) {
                popupView.alpha = 0
            } completion: { finished in
                if finished {
                    popupView.removeFromSuperview()
                }
            }
        }
        popupView.shareBtnClickBlock = {
            [weak self] img in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                let ac = UIActivityViewController(activityItems: [img], applicationActivities: nil)
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
        
        
    }
    
}




class PSkProfileMakerBottomBtn: UIButton {
    var nameStr: String
    let iconImgV = UIImageView()
    
    
    init(frame: CGRect, nameStr: String) {
        self.nameStr = nameStr
        super.init(frame: frame)
        setupView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {

        iconImgV
            .image(nameStr)
            .contentMode(.scaleAspectFit)
            .adhere(toSuperview: self)
        iconImgV.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(0)
            $0.width.height.greaterThanOrEqualTo(60)
        }
        
    }
    
    func isCurrentSelect(isSelect: Bool) {
//        if isSelect == true {
//            nameLabel
//                .color(UIColor(hexString: "#454C3D")!)
//
//        } else {
//            nameLabel
//                .color(UIColor(hexString: "#454C3D")!.withAlphaComponent(0.5))
//
//        }
    }
    
}





extension PSkProfileMakerVC: UIImagePickerControllerDelegate {
    
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
                            let cancelAction = UIAlertAction(title: "Cancel".localized(), style: .cancel)
                            alert.addAction(confirmAction)
                            alert.addAction(cancelAction)
                            
                            self.present(alert, animated: true)
                        }
                        
                    case .restricted:
                        DispatchQueue.main.async {
                            [weak self] in
                            guard let `self` = self else {return}
                            let alert = UIAlertController(title: "Oops".localized(), message: "You have declined access to photos, please active it in Settings>Privacy>Photos.".localized(), preferredStyle: .alert)
                            let confirmAction = UIAlertAction(title: "OK".localized(), style: .default, handler: { (goSettingAction) in
                                DispatchQueue.main.async {
                                    let url = URL(string: UIApplication.openSettingsURLString)!
                                    UIApplication.shared.open(url, options: [:])
                                }
                            })
                            let cancelAction = UIAlertAction(title: "Cancel".localized(), style: .cancel)
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
//                            self.presentPhotoPickerController()
                            self.presentLimitedPhotoPickerController()
                        }
                    case .limited:
                        DispatchQueue.main.async {
                            self.presentLimitedPhotoPickerController()
                        }
                    case .denied:
                        DispatchQueue.main.async {
                            [weak self] in
                            guard let `self` = self else {return}
                            let alert = UIAlertController(title: "Oops".localized(), message: "You have declined access to photos, please active it in Settings>Privacy>Photos.".localized(), preferredStyle: .alert)
                            let confirmAction = UIAlertAction(title: "OK".localized(), style: .default, handler: { (goSettingAction) in
                                DispatchQueue.main.async {
                                    let url = URL(string: UIApplication.openSettingsURLString)!
                                    UIApplication.shared.open(url, options: [:])
                                }
                            })
                            let cancelAction = UIAlertAction(title: "Cancel".localized(), style: .cancel)
                            alert.addAction(confirmAction)
                            alert.addAction(cancelAction)
                            
                            self.present(alert, animated: true)
                        }
                        
                    case .restricted:
                        DispatchQueue.main.async {
                            [weak self] in
                            guard let `self` = self else {return}
                            let alert = UIAlertController(title: "Oops".localized(), message: "You have declined access to photos, please active it in Settings>Privacy>Photos.".localized(), preferredStyle: .alert)
                            let confirmAction = UIAlertAction(title: "OK".localized(), style: .default, handler: { (goSettingAction) in
                                DispatchQueue.main.async {
                                    let url = URL(string: UIApplication.openSettingsURLString)!
                                    UIApplication.shared.open(url, options: [:])
                                }
                            })
                            let cancelAction = UIAlertAction(title: "Cancel".localized(), style: .cancel)
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
        config.showsPhotoFilters = false
        config.library.preselectedItems = nil
        let picker = YPImagePicker(configuration: config)
        picker.view.backgroundColor(UIColor.white)
        picker.didFinishPicking { [unowned picker] items, cancelled in
            var imgs: [UIImage] = []
            for item in items {
                switch item {
                case .photo(let photo):
                    if let img = photo.image.scaled(toWidth: 1800) {
                        imgs.append(img)
                    }
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
//        self.navigationController?.pushViewController(picker, animated: true)
        present(picker, animated: true, completion: nil)
    }
    
    
    
//    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
//        picker.dismiss(animated: true, completion: nil)
//        var imgList: [UIImage] = []
//
//        for result in results {
//            result.itemProvider.loadObject(ofClass: UIImage.self, completionHandler: { (object, error) in
//                if let image = object as? UIImage {
//                    DispatchQueue.main.async {
//                        // Use UIImage
//                        print("Selected image: \(image)")
//                        imgList.append(image)
//                    }
//                }
//            })
//        }
//        if let image = imgList.first {
//            self.showEditVC(image: image)
//        }
//    }
    
 
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
        
        DispatchQueue.main.async {
            [weak self] in
            guard let `self` = self else {return}
            self.addNewPhotos(img: image)
        }
    }
}


 
extension PSkProfileMakerVC {
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
        let cancelButton = UIAlertAction(title: "Cancel".localized().localized(), style: .cancel) { (action) in
            
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
