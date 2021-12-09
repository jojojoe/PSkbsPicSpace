//
//  PSkMagicCamEditVC.swift
//  PSkbsPicSpace
//
//  Created by JOJO on 2021/12/6.
//

import UIKit
import DeviceKit

class PSkMagicCamEditVC: UIViewController {
    var origImg: UIImage
    
    var saveAlbumBtn = UIButton()
    var backBtn = UIButton()
    let borderBar = PSkMagicCamBorderBar()
    var shareBtn = UIButton()
    let siginBtn = UIButton()

    var contentBgV = UIView()
    var canvasBgV = UIView()
    let borderImgV = UIImageView()
    let userImgV = UIImageView()
    let touchMoveCanvasV = PSkTouchMoveCanvasView()
    let signVC = PSkMagicCamSignatureVC()
    
    var viewDidLayoutSubviewsOnce: Once = Once()
    
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
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        forceOrientationPortrait()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let firstBorder = PSkMagicCamManager.default.camBorderList[1]
        
        self.viewDidLayoutSubviewsOnce.run({
            updateCanvasFrame(item: firstBorder)
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
    
    func setupView() {
        //
        view.backgroundColor(UIColor.white)
        //
        let bottomBar = UIView()
        bottomBar
            .backgroundColor(.white)
            .adhere(toSuperview: view)
        bottomBar.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.height.equalTo(100)
        }
        
        //
        saveAlbumBtn
            .image("")
            .backgroundColor(UIColor.orange)
            .adhere(toSuperview: bottomBar)
        saveAlbumBtn.layer.cornerRadius = 70/2
        saveAlbumBtn.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(70)
        }
        saveAlbumBtn.addTarget(self, action: #selector(saveAlbumBtnClick(sender: )), for: .touchUpInside)
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
        shareBtn
            .backgroundColor(UIColor.lightGray)
            .image(UIImage(named: ""))
            .adhere(toSuperview: bottomBar)
        shareBtn.addTarget(self, action: #selector(shareBtnClick(sender: )), for: .touchUpInside)
        shareBtn.snp.makeConstraints {
            $0.centerY.equalTo(bottomBar.snp.centerY)
            $0.right.equalToSuperview().offset(-25)
            $0.width.height.equalTo(50)
        }
        
        //
        //
        
        borderBar.adhere(toSuperview: view)
        borderBar.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(bottomBar.snp.top)
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
            .title("签名")
            .titleColor(.white)
            .backgroundColor(.blue)
            .adhere(toSuperview: view)
        siginBtn.layer.cornerRadius = 5
        siginBtn.snp.makeConstraints {
            $0.left.equalTo(30)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(borderBar.snp.top).offset(-5)
            $0.height.equalTo(44)
                
        }
        siginBtn.addTarget(self, action: #selector(siginBtnClick(sender: )), for: .touchUpInside)
        //
        contentBgV
            .backgroundColor(.white)
            .adhere(toSuperview: view)
        contentBgV.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.bottom.equalTo(siginBtn.snp.top).offset(-20)
        }
        
        //
        canvasBgV
            .backgroundColor(.purple)
            .adhere(toSuperview: contentBgV)
        
        //
        
        borderImgV
            .contentMode(.scaleAspectFit)
            .adhere(toSuperview: canvasBgV)
        //
        userImgV
            .contentMode(.scaleAspectFit)
            .adhere(toSuperview: canvasBgV)
        userImgV.image = origImg
        
    }

    
}

extension PSkMagicCamEditVC {
    func updateCanvasFrame(item: CamBorderItem) {
        
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
            userImgVTopOffset = fineH * (offsetP/widthP)
            userImgVLeftOffset = fineW * (offsetP/widthP)
        } else if item.imgPosition == "bottom" {
            userImgVWidth = fineW * (centerP/widthP)
            userImgVHeight = userImgVWidth
            userImgVTopOffset = fineH - userImgVHeight - (fineH * (offsetP/widthP))
            userImgVLeftOffset = fineW * (offsetP/widthP)
        } else if item.imgPosition == "left" {
            userImgVHeight = fineH * (centerP/widthP)
            userImgVWidth = userImgVHeight
            userImgVTopOffset = fineH * (offsetP/widthP)
            userImgVLeftOffset = fineW * (offsetP/widthP)
        } else if item.imgPosition == "right" {
            userImgVHeight = fineH * (centerP/widthP)
            userImgVWidth = userImgVHeight
            userImgVTopOffset = fineH * (offsetP/widthP)
            userImgVLeftOffset = fineW - userImgVWidth - (fineW * (offsetP/widthP))
        } else if item.imgPosition == "center" {
            userImgVWidth = fineW * (centerP/widthP)
            userImgVHeight = userImgVWidth
            userImgVTopOffset = fineH * (offsetP/widthP)
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
        
        
    }
    
    func addSignPhotos(signImg: UIImage?) {
        
        if let signV = self.touchMoveCanvasV.subViewList.first as? UIImageView {
          
            signV.image = signImg
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
        
        
    }
}

extension PSkMagicCamEditVC {
    
    @objc func saveAlbumBtnClick(sender: UIButton) {
    
    }
    
    @objc func shareBtnClick(sender: UIButton) {
    
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
                self.addSignPhotos(signImg: signImg)
            }
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

