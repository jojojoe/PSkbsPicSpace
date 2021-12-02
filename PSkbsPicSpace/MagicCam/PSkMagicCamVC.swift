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
/*
 https://github.com/Silence-GitHub/BBMetalImage
 
 拍的照片添加拍立得相框
 
 */

class PSkMagicCamVC: UIViewController {

    private var camera: BBMetalCamera!
    private var metalView: BBMetalView!
    
    var backBtn = UIButton(type: .custom)
    var takePhotoBtn = UIButton(type: .custom)
    var camPositionBtn = UIButton(type: .custom)
    
    
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
        var leftOffset: CGFloat = 0
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
        
        //
        let filterBar = PSkMagicCamFilterBar()
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
        let toolControBar = UIView()
        toolControBar
            .backgroundColor(.darkGray)
            .adhere(toSuperview: view)
        toolControBar.layer.cornerRadius = 10
        toolControBar.layer.masksToBounds = true
        toolControBar.snp.makeConstraints {
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
        
    }
    
    @objc func camPositionBtnClick(sender: UIButton) {
        camera.switchCameraPosition()
    }
    
    
}
