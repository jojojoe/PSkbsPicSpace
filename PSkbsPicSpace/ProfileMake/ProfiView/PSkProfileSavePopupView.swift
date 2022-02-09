//
//  PSkProfileSavePreviewV.swift
//  PSkbsPicSpace
//
//  Created by JOJO on 2021/11/23.
//

import UIKit
import BetterSegmentedControl

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
    
    let previewImgV = UIImageView()
    let imageSizeLabel = UILabel()
    let sliderSizeLabel = UILabel()
    
    var currentQuality: CGFloat = 0.9
    var currentType: PSkProfileExportImgType = .png
    
    
    func updatePreviewImageV(img: UIImage) {
        
    }
    
    init(frame: CGRect, originImg: UIImage) {
        self.originImg = originImg
        self.processedImg = originImg
        super.init(frame: frame)
        setupView()
        updateChangePng()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        backgroundColor(UIColor.black.withAlphaComponent(0.7))
        //
        
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
        //
        let bgBtn = UIButton(type: .custom)
        bgBtn
            .image(UIImage(named: ""))
            .adhere(toSuperview: self)
        bgBtn.addTarget(self, action: #selector(backBtnClick(sender:)), for: .touchUpInside)
        bgBtn.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        
        let imgScaleHW: CGFloat = originImg.size.height / originImg.size.width
        
        var contentV_Width: CGFloat = 330
        
        var contentWidth: CGFloat = 330
        var contentHeight: CGFloat = CGFloat(Int(imgScaleHW * contentWidth))
        
        if contentHeight > 330 {
            contentHeight = 330
            contentWidth = CGFloat(Int(contentHeight / imgScaleHW))
        }
        
        let padding: CGFloat = 24
        
        let previewImgVWidth: CGFloat = contentWidth - (padding * 2)
        let previewImgVHeight: CGFloat = previewImgVWidth * (originImg.size.height / originImg.size.width)
        
        contentHeight = padding + previewImgVHeight + 240
        
        //
        let contentV = UIView()
            .backgroundColor(UIColor.white.withAlphaComponent(0.95))
            .adhere(toSuperview: self)
        contentV.layer.cornerRadius = 24
        contentV.layer.shadowColor = UIColor.lightGray.withAlphaComponent(0.6).cgColor
        contentV.layer.shadowOffset = CGSize(width: 0, height: 0)
        contentV.layer.shadowRadius = 3
        contentV.layer.shadowOpacity = 0.8
        contentV.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(0)
            $0.width.equalTo(contentV_Width)
            $0.height.equalTo(contentHeight)
        }
       
        previewImgV.image = originImg
        previewImgV
            .contentMode(.scaleAspectFill)
            .backgroundColor(UIColor(hexString: "#F4F4F4")!)
            .adhere(toSuperview: contentV)
        previewImgV.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(contentV.snp.top).offset(54)
            $0.width.equalTo(previewImgVWidth)
            $0.height.equalTo(previewImgVHeight)
        }
        
        //
        let backBtn = UIButton(type: .custom)
        backBtn
            .image(UIImage(named: "i_all_close"))
            .adhere(toSuperview: contentV)

        backBtn.addTarget(self, action: #selector(backBtnClick(sender:)), for: .touchUpInside)

        backBtn.snp.makeConstraints {
            $0.top.equalTo(contentV.snp.top).offset(5)
            $0.right.equalTo(contentV.snp.right).offset(-5)
            $0.width.equalTo(44)
            $0.height.equalTo(44)
        }
        
        //
//        let imgTypeLabel = UILabel()
//        imgTypeLabel
//            .color(UIColor.black)
//            .fontName(14, "AvenirNext-Medium")
//            .text("Image Type")
//            .adhere(toSuperview: contentV)
//        imgTypeLabel.snp.makeConstraints {
//            $0.left.equalTo(padding)
//            $0.top.equalTo(previewImgV.snp.bottom).offset(padding)
//            $0.width.height.greaterThanOrEqualTo(1)
//        }
        //
        let imgTypeControl = BetterSegmentedControl(
            frame: CGRect.zero,
            segments: LabelSegment.segments(withTitles: ["PNG", "JPG"],
                                            normalFont: UIFont(name: "Montserrat-SemiBold", size: 12)!, normalTextColor: UIColor(hexString: "#CFCFCF")!,
                                            selectedTextColor: .white),
            options:[.backgroundColor(UIColor(hexString: "#040404")!),
                     .indicatorViewBackgroundColor(UIColor(hexString: "#EEAB00")!),
                     .cornerRadius(8.0),
                     .animationSpringDamping(2.0)])
        imgTypeControl.addTarget(self, action: #selector(imgTypeControlValueChange(sender:)), for: .valueChanged)
        imgTypeControl.adhere(toSuperview: contentV)
        imgTypeControl.snp.makeConstraints {
            $0.top.equalTo(previewImgV.snp.bottom).offset(28)
            $0.left.equalTo(previewImgV.snp.left).offset(0)
            $0.height.equalTo(36)
            $0.width.equalTo(86)
        }
        imgTypeControl.layer.cornerRadius = 8
        imgTypeControl.layer.masksToBounds = true
        
//        //
//        let imageQualityLabel = UILabel()
//        imageQualityLabel
//            .color(UIColor.black)
//            .fontName(14, "AvenirNext-Medium")
//            .text("Image Quality")
//            .adhere(toSuperview: contentV)
//        imageQualityLabel.snp.makeConstraints {
//            $0.left.equalTo(padding)
//            $0.top.equalTo(imgTypeLabel.snp.bottom).offset(24)
//            $0.width.height.greaterThanOrEqualTo(1)
//        }
        //
        
        imageSizeLabel
            .color(UIColor.black)
            .backgroundColor(UIColor(hexString: "#F3F3F3")!)
            .fontName(12, "Montserrat-SemiBold")
            .textAlignment(.center)
            .adhere(toSuperview: contentV)
        imageSizeLabel.layer.cornerRadius = 8
        imageSizeLabel.layer.masksToBounds = true
        imageSizeLabel.snp.makeConstraints {
            $0.right.equalTo(previewImgV.snp.right).offset(0)
            $0.centerY.equalTo(imgTypeControl.snp.centerY)
            $0.width.equalTo(62)
            $0.height.equalTo(28)
        }
        //
        let imageQualitySlider = UISlider()
        imageQualitySlider.isContinuous = false
        imageQualitySlider.setMinimumTrackImage(UIImage(named: "i_minslider"), for: .normal)
        imageQualitySlider.setMaximumTrackImage(UIImage(named: "i_maxslider"), for: .normal)
        imageQualitySlider.setThumbImage(UIImage(named: "i_qualyPoint"), for: .normal)
        imageQualitySlider.minimumValue = 0.1
        imageQualitySlider.maximumValue = 1
        imageQualitySlider.adhere(toSuperview: contentV)
        imageQualitySlider.snp.makeConstraints {
            $0.top.equalTo(imgTypeControl.snp.bottom).offset(22)
            $0.left.equalTo(previewImgV.snp.left)
            $0.right.equalTo(contentV.snp.right).offset(-80)
            $0.height.equalTo(30)
        }
        imageQualitySlider.value = 1
        
        imageQualitySlider.addTarget(self, action: #selector(imageQualitySliderValueChange(sender: )), for: .valueChanged)
        
        //
        
        sliderSizeLabel
            .color(UIColor.black)
            .backgroundColor(UIColor(hexString: "#F3F3F3")!)
            .fontName(10, "Montserrat-SemiBold")
            .textAlignment(.center)
            .text("100%")
            .adhere(toSuperview: contentV)
        
        sliderSizeLabel.layer.cornerRadius = 8
        sliderSizeLabel.layer.masksToBounds = true
        sliderSizeLabel.snp.makeConstraints {
            $0.right.equalTo(contentV.snp.right).offset(-24)
            $0.centerY.equalTo(imageQualitySlider.snp.centerY)
            $0.width.equalTo(42)
            $0.height.equalTo(22)
        }
        
        
        // save
        let saveBtn = UIButton()
        saveBtn.layer.cornerRadius = 25
        saveBtn
            .backgroundColor(UIColor(hexString: "#000000")!)
            .image(UIImage(named: "i_clip_download"))
            .adhere(toSuperview: contentV)
        saveBtn.addTarget(self, action: #selector(saveBtnClick(sender:)), for: .touchUpInside)
        saveBtn.snp.makeConstraints {
            $0.bottom.equalTo(contentV.snp.bottom).offset(-padding)
            $0.right.equalTo(contentV.snp.centerX).offset(-10)
            $0.left.equalTo(contentV.snp.left).offset(24)
            $0.height.equalTo(50)
        }
         
        // share
        let shareBtn = UIButton()
        shareBtn.layer.cornerRadius = 25
        shareBtn
            .backgroundColor(UIColor(hexString: "#000000")!)
            .image(UIImage(named: "i_clip_share"))
            .adhere(toSuperview: contentV)
        shareBtn.addTarget(self, action: #selector(shareBtnClick(sender:)), for: .touchUpInside)
        shareBtn.snp.makeConstraints {
            $0.bottom.equalTo(contentV.snp.bottom).offset(-padding)
            $0.left.equalTo(contentV.snp.centerX).offset(10)
            $0.right.equalTo(contentV.snp.right).offset(-24)
            $0.height.equalTo(50)
        }
        
    }
     

    @objc func imgTypeControlValueChange(sender: BetterSegmentedControl) {
        if sender.index == 0 {
            updateChangePng()
        } else {
            updateChangeJpg()
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
        let quality: CGFloat = CGFloat(sender.value - 0.1)
        currentQuality = quality
        sliderSizeLabel.text("\(Int(sender.value * 100))%")
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
        previewImgV.image = processedImg
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
        previewImgV.image = processedImg
    }
    
}

 

