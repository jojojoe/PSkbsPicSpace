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
    var shareBtn = UIButton()
    
    var canvasBgV = UIView()
    
    
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
    }
    
    func setupView() {
        //
        
       
        
        
        
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
            .image("")
            .backgroundColor(UIColor.orange)
            .adhere(toSuperview: bottomBar)
        saveAlbumBtn.layer.cornerRadius = 90/2
        saveAlbumBtn.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(90)
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
        let borderBar = PSkMagicCamBorderBar()
        borderBar.adhere(toSuperview: view)
        borderBar.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(bottomBar.snp.top)
            $0.height.equalTo(100)
        }
        
        //
        let siginBtn = UIButton()
        siginBtn
            .title("签名")
            .titleColor(.white)
            .backgroundColor(.blue)
            .adhere(toSuperview: view)
        siginBtn.layer.cornerRadius = 5
        siginBtn.snp.makeConstraints {
            $0.left.equalTo(30)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(borderBar.snp.top)
            $0.height.equalTo(44)
                
        }
        
        //
        canvasBgV
            .backgroundColor(.purple)
            .adhere(toSuperview: view)
        canvasBgV.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.bottom.equalTo(siginBtn.snp.top).offset(-20)
        }
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
    
    
}

