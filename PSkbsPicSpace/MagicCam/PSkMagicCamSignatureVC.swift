//
//  PSkMagicCamSignatureVC.swift
//  PSkbsPicSpace
//
//  Created by JOJO on 2021/12/9.
//

import UIKit



class PSkMagicCamSignatureVC: UIViewController {

    var backBtn = UIButton()
    var okBtn = UIButton()
    var clearBtn = UIButton()
    var colorBtn = UIButton()
    let colorCenterV = UIView()
    
    var camSignatureOkBlock: ((UIImage?)->Void)?

    let colorBar = PSkMagicCamColorBar()
    
    
    lazy var signatureVC: SignatureDrawingViewController = {
      let vc = SignatureDrawingViewController()
      vc.view.layer.borderColor = UIColor.black.cgColor
      vc.view.layer.borderWidth = 2
      vc.view.layer.masksToBounds = true
      return vc
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupColorBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        forceOrientationPortrait()
    }
    

}

extension PSkMagicCamSignatureVC {
    func setupView() {
        view.backgroundColor = UIColor(hexString: "#F4F4F4")
        //
        signatureVC.view.backgroundColor(UIColor.white)
        addChild(signatureVC)
        signatureVC.didMove(toParent: self)
        signatureVC.delegate = self
        view.addSubview(signatureVC.view)
        
        signatureVC.view.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            $0.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(20)
            $0.right.equalTo(view.safeAreaLayoutGuide.snp.right).offset(-60)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
        }
        
        //
        okBtn
            .image(UIImage(named: "i_sig_done"))
            .adhere(toSuperview: view)
        okBtn.addTarget(self, action: #selector(okBtnClick(sender: )), for: .touchUpInside)
        okBtn.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            $0.right.equalTo(view.safeAreaLayoutGuide.snp.right).offset(-10)
            $0.width.height.equalTo(44)
        }
        
        //
        backBtn
            .image(UIImage(named: "i_sig_back"))
            .adhere(toSuperview: view)
        backBtn.addTarget(self, action: #selector(backBtnClick(sender: )), for: .touchUpInside)
        backBtn.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            $0.right.equalTo(view.safeAreaLayoutGuide.snp.right).offset(-10)
            $0.width.height.equalTo(44)
        }
        
        //
        clearBtn
            .image(UIImage(named: "i_sig_clear"))
            .adhere(toSuperview: view)
        clearBtn.addTarget(self, action: #selector(clearBtnClick(sender: )), for: .touchUpInside)
        clearBtn.snp.makeConstraints {
            $0.bottom.equalTo(backBtn.snp.top).offset(-18)
            $0.right.equalTo(view.safeAreaLayoutGuide.snp.right).offset(-10)
            $0.width.height.equalTo(44)
        }
        
        //
        colorBtn
            .image(UIImage(named: "i_sig_color"))
            .adhere(toSuperview: view)
        colorBtn.addTarget(self, action: #selector(colorBtnClick(sender: )), for: .touchUpInside)
        colorBtn.snp.makeConstraints {
            $0.bottom.equalTo(clearBtn.snp.top).offset(-18)
            $0.right.equalTo(view.safeAreaLayoutGuide.snp.right).offset(-10)
            $0.width.height.equalTo(44)
        }
        
        //
        colorCenterV.backgroundColor(.black)
            .adhere(toSuperview: colorBtn)
        colorCenterV.snp.makeConstraints {
            $0.centerX.equalTo(colorBtn.snp.centerX).offset(-3.7)
            $0.centerY.equalTo(colorBtn.snp.centerY).offset(4.7)
            $0.width.height.equalTo(6)
        }
        colorCenterV.layer.cornerRadius = 3
        
        
    }
    
    func setupColorBar() {
        colorBar.isHidden = true
        colorBar.adhere(toSuperview: view)
        colorBar.backBtnClickBlock = {
            [weak self] in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                self.colorBar.showStatus(isShow: false)
            }
            
        }
        colorBar.selectColorBlock = {
            [weak self] bgColor in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                [weak self] in
                guard let `self` = self else {return}
                self.signatureVC.signatureColor = bgColor
                self.colorCenterV.backgroundColor(bgColor)
            }
            
        }
        colorBar.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }

    }
    
    
}

extension PSkMagicCamSignatureVC {
    @objc func backBtnClick(sender: UIButton) {
        if self.navigationController != nil {
            self.navigationController?.popViewController()
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func okBtnClick(sender: UIButton) {
        if signatureVC.isEmpty {
            camSignatureOkBlock?(nil)
        } else {
            let img = signatureVC.fullSignatureImage
            camSignatureOkBlock?(img)
        }
        backBtnClick(sender: backBtn)
    }
    
    @objc func clearBtnClick(sender: UIButton) {
        signatureVC.reset()
    }
    
    @objc func colorBtnClick(sender: UIButton) {
        self.colorBar.showStatus(isShow: true)
    }
    
}

extension PSkMagicCamSignatureVC: SignatureDrawingViewControllerDelegate {
  func signatureDrawingViewControllerIsEmptyDidChange(controller: SignatureDrawingViewController, isEmpty: Bool) {
      debugPrint("isEmpty: \(isEmpty)")
    
  }
    
    
    
}

extension PSkMagicCamSignatureVC {
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

