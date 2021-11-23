//
//  PSkProfileSavePreviewV.swift
//  PSkbsPicSpace
//
//  Created by JOJO on 2021/11/23.
//

import UIKit
import LabelSwitch

enum PSkProfileExportImgType {
    case png
    case jpg
}

 

class PSkProfileSavePopupView: UIView {
    
    var originImg: UIImage
    var processedImg: UIImage
    
    
    var backBtnClickBlock: (()->Void)?
    var saveToAlbumBtnClickBlock: ((UIImage)->Void)?
    var shareBtnClickBlock: ((UIImage)->Void)?
    
    let imageSizeLabel = UILabel()
    
    var currentQuality: CGFloat = 1
    var currentType: PSkProfileExportImgType = .png
    
    
    func updatePreviewImageV(img: UIImage) {
        
    }
    
    init(frame: CGRect, originImg: UIImage) {
        self.originImg = originImg
        self.processedImg = originImg
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        backgroundColor(UIColor.black.withAlphaComponent(0.7))
        //
        //
        let bgBtn = UIButton(type: .custom)
        bgBtn
            .image(UIImage(named: ""))
            .adhere(toSuperview: self)
        bgBtn.addTarget(self, action: #selector(backBtnClick(sender:)), for: .touchUpInside)
        bgBtn.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        
        let imgScaleWH: CGFloat = originImg.size.width / originImg.size.height
        
        let contentWidth: CGFloat = 330
        var contentHeight: CGFloat = CGFloat(Int(imgScaleWH * contentWidth))
        contentHeight += 150
        
        //
        let contentV = UIView()
            .backgroundColor(.white)
            .adhere(toSuperview: self)
        contentV.layer.cornerRadius = 24
        contentV.layer.shadowColor = UIColor.lightGray.withAlphaComponent(0.6).cgColor
        contentV.layer.shadowOffset = CGSize(width: 0, height: 0)
        contentV.layer.shadowRadius = 3
        contentV.layer.shadowOpacity = 0.8
        contentV.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(0)
            $0.width.equalTo(contentWidth)
            $0.height.equalTo(contentHeight)
        }
         
        //
//        let backBtn = UIButton(type: .custom)
//        backBtn
//            .text("X")
//            .titleColor(.lightGray)
//            .adhere(toSuperview: contentV)
//
//        backBtn.addTarget(self, action: #selector(backBtnClick(sender:)), for: .touchUpInside)
//
//        backBtn.snp.makeConstraints {
//            $0.top.equalTo(contentV.snp.top).offset(10)
//            $0.right.equalTo(contentV.snp.right).offset(-10)
//            $0.width.equalTo(44)
//            $0.height.equalTo(44)
//        }
        
        let padding: CGFloat = 24
        
        let previewImgVWidth: CGFloat = contentWidth - (padding * 2)
        let previewImgVHeight: CGFloat = previewImgVWidth * (originImg.size.height / originImg.size.width)
        
        let previewImgV = UIImageView()
        previewImgV
            .contentMode(.scaleAspectFill)
            .adhere(toSuperview: contentV)
        previewImgV.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(contentV.snp.top).offset(padding)
            $0.width.equalTo(previewImgVWidth)
            $0.height.equalTo(previewImgVHeight)
        }
        
        //
        let imgTypeLabel = UILabel()
        imgTypeLabel
            .color(UIColor.black)
            .fontName(14, "AvenirNext-Medium")
            .text("Image Type")
            .adhere(toSuperview: contentV)
        imgTypeLabel.snp.makeConstraints {
            $0.left.equalTo(padding)
            $0.top.equalTo(previewImgV.snp.bottom).offset(padding)
            $0.width.height.greaterThanOrEqualTo(1)
        }
        //
        let ls = LabelSwitchConfig(text: "Png",
                              textColor: .white,
                                   font: UIFont(name: "AvenirNext-Medium", size: 13) ?? UIFont.systemFont(ofSize: 13),
                        backgroundColor: .purple)
                
        let rs = LabelSwitchConfig(text: "Jpg",
                              textColor: .white,
                                   font: UIFont(name: "AvenirNext-Medium", size: 13) ?? UIFont.systemFont(ofSize: 13),
                        backgroundColor: .orange)

        // Set the default state of the switch,
        let labelSwitch = LabelSwitch(center: .zero, leftConfig: ls, rightConfig: rs)

        // Set the appearance of the circle button
        labelSwitch.circleShadow = false
        labelSwitch.circleColor = .white

        // Make switch be triggered by tapping on any position in the switch
        labelSwitch.fullSizeTapEnabled = true

        // Set the delegate to inform when the switch was triggered
        labelSwitch.delegate = self
        labelSwitch.adhere(toSuperview: contentV)
        labelSwitch.snp.makeConstraints {
            $0.centerY.equalTo(imgTypeLabel.snp.centerY)
            $0.right.equalTo(contentV.snp.right).offset(-padding)
            $0.width.greaterThanOrEqualTo(70)
            $0.height.greaterThanOrEqualTo(30)
        }
        
        //
        let imageQualityLabel = UILabel()
        imageQualityLabel
            .color(UIColor.black)
            .fontName(14, "AvenirNext-Medium")
            .text("Image Quality")
            .adhere(toSuperview: contentV)
        imageQualityLabel.snp.makeConstraints {
            $0.left.equalTo(padding)
            $0.top.equalTo(imgTypeLabel.snp.bottom).offset(34)
            $0.width.height.greaterThanOrEqualTo(1)
        }
        //
        
        imageSizeLabel
            .color(UIColor.orange)
            .fontName(18, "AvenirNext-Bold")
            .adhere(toSuperview: contentV)
        .snp.makeConstraints {
            $0.right.equalTo(contentV.snp.right).offset(-padding)
            $0.centerY.equalTo(imageQualityLabel.snp.centerY)
            $0.width.height.greaterThanOrEqualTo(1)
        }
        //
        let imageQualitySlider = UISlider()
        imageQualitySlider.isContinuous = false
        imageQualitySlider.thumbTintColor = UIColor.white
        imageQualitySlider.minimumTrackTintColor = UIColor.yellow
        imageQualitySlider.maximumTrackTintColor = UIColor.yellow
        imageQualitySlider.minimumValue = 0
        imageQualitySlider.maximumValue = 1
        imageQualitySlider.adhere(toSuperview: contentV)
        imageQualitySlider.snp.makeConstraints {
            $0.top.equalTo(imageSizeLabel.snp.bottom).offset(20)
            $0.left.equalTo(40)
        }
        imageQualitySlider.value = Float(currentQuality)
        
        imageQualitySlider.addTarget(self, action: #selector(imageQualitySliderValueChange(sender: )), for: .valueChanged)
        
        // save
        let saveBtn = UIButton(type: .custom)
        saveBtn.layer.cornerRadius = 25
        saveBtn
            .backgroundColor(UIColor(hexString: "#000000")!)
            .text("Save")
            .font(16, "AvenirNext-DemiBold")
            .titleColor(UIColor(hexString: "#FFFFFF")!)
            .adhere(toSuperview: contentV)
        saveBtn.addTarget(self, action: #selector(saveBtnClick(sender:)), for: .touchUpInside)
        saveBtn.snp.makeConstraints {
            $0.bottom.equalTo(contentV.snp.bottom).offset(-30)
            $0.right.equalTo(contentV.snp.centerX).offset(-10)
            $0.width.equalTo(100)
            $0.height.equalTo(50)
        }
         
        // share
        let shareBtn = UIButton(type: .custom)
        shareBtn.layer.cornerRadius = 32
        shareBtn
            .backgroundColor(UIColor(hexString: "#000000")!)
            .text("Share")
            .font(16, "AvenirNext-DemiBold")
            .titleColor(UIColor(hexString: "#FFFFFF")!)
            .adhere(toSuperview: contentV)
        shareBtn.addTarget(self, action: #selector(shareBtnClick(sender:)), for: .touchUpInside)
        shareBtn.snp.makeConstraints {
            $0.bottom.equalTo(contentV.snp.bottom).offset(-30)
            $0.left.equalTo(contentV.snp.centerX).offset(10)
            $0.width.equalTo(100)
            $0.height.equalTo(50)
        }
        
    }
     

    @objc func backBtnClick(sender: UIButton) {
        backBtnClickBlock?()
    }
    @objc func saveBtnClick(sender: UIButton) {
        saveToAlbumBtnClickBlock?(self.processedImg)
        
        
        
    }
    @objc func shareBtnClick(sender: UIButton) {
        shareBtnClickBlock?(self.processedImg)
    }
    
    @objc func imageQualitySliderValueChange(sender: UISlider) {
        currentQuality = CGFloat(sender.value)
        switch currentType {
        case .png:
            processPng()
        case .jpg:
            processJpg()
        }
    }
    
    func updateChangePng() {
        currentType = .png
        processPng()
    }
    
    func updateChangeJpg() {
        currentType = .jpg
        processJpg()
    }
    
    
    func processPng() {
        if currentQuality == 1 {
            if let imageData = originImg.pngData() as NSData? {
                if let imgpng = UIImage(data: imageData as Data) {
                    let allSize: Int64 = Int64(imageData.length)
                    let sizeStr = ByteCountFormatter.string(fromByteCount: allSize, countStyle: ByteCountFormatter.CountStyle.file)
                    imageSizeLabel.text(sizeStr)
                    processedImg = imgpng
                }
            }
        } else {
            if let imageData = originImg.jpegData(compressionQuality: currentQuality) as NSData? {
                if let jpgtopngImg = UIImage(data: imageData as Data) {
                    if let imageData = jpgtopngImg.pngData() as NSData? {
                        if let imgpng = UIImage(data: imageData as Data) {
                            
                            let allSize: Int64 = Int64(imageData.length)
                            let sizeStr = ByteCountFormatter.string(fromByteCount: allSize, countStyle: ByteCountFormatter.CountStyle.file)
                            
                            imageSizeLabel.text(sizeStr)
                            processedImg = imgpng
                        }
                    }
                }
            }
        }
    }
    
    func processJpg() {
        if let imageData = originImg.jpegData(compressionQuality: currentQuality) as NSData? {
            if let imgjpg = UIImage(data: imageData as Data) {
                let allSize: Int64 = Int64(imageData.length)
                let sizeStr = ByteCountFormatter.string(fromByteCount: allSize, countStyle: ByteCountFormatter.CountStyle.file)

                imageSizeLabel.text(sizeStr)
                processedImg = imgjpg
                
                
                let fullPath = NSHomeDirectory().appending("/Documents/").appending("\("imageName").jpg")
                imageData.write(toFile: fullPath, atomically: true)
                debugPrint("fullPath=\(fullPath)")
                
            }
        }
        
    }
    
}


extension PSkProfileSavePopupView: LabelSwitchDelegate {
    func switchChangToState(sender: LabelSwitch) {
        switch sender.curState {
            case .L: updateChangePng()
            case .R: updateChangeJpg()
        }
    }
}

