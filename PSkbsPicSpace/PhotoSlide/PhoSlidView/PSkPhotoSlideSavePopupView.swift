//
//  PSkPhotoSlideSavePopupView.swift
//  PSkbsPicSpace
//
//  Created by JOJO on 2021/11/4.
//

import UIKit

class PSkPhotoSlideSavePopupView: UIView {

    var slideImgs: [UIImage] = []
    var slideType: SliderType = .slider1_3
    let fullBtnOpen = UISwitch()
    var backBtnClickBlock: (()->Void)?
    var okBtnClickBlock: (()->Void)?
    var shareBtnClickBlock: (()->Void)?
    var sliderAreaViews: [UIImageView] = []
    let fullBtn = UIButton()
    let clipBtn = UIButton()
    
    
    init(frame: CGRect, slideImgs: [UIImage], slideType: SliderType) {
        self.slideImgs = slideImgs
        self.slideType = slideType
        super.init(frame: frame)
        setupView()
        
        clipBtnClick(sender: clipBtn)
        updateFullImgStatus(isFull: false)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        backgroundColor(UIColor.black.withAlphaComponent(0.5))
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
        
        let contentWidth: CGFloat = 330
        var contentHeight: CGFloat = 480
        if slideType == .slider1_3 {
            contentHeight = 380
        } else if slideType == .slider2_3 {
            contentHeight = 400
        }
        
        
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
            $0.width.equalTo(contentWidth)
            $0.height.equalTo(contentHeight)
        }
        //
//        let nameLabel = UILabel()
//        nameLabel
//            .fontName(15, "")
//            .color(UIColor(hexString: "#000000")!)
//            .text("Save to Album")
//            .adhere(toSuperview: contentV)
//        nameLabel.snp.makeConstraints {
//            $0.centerX.equalToSuperview()
//            $0.top.equalTo(18)
//            $0.width.greaterThanOrEqualTo(1)
//            $0.height.equalTo(40)
//        }
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
        let padding: CGFloat = 24
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
        
        //
        
        fullBtn.adhere(toSuperview: contentV)
            .image(UIImage(named: "i_clip_he"), .normal)
            .image(UIImage(named: "i_clip_he_s"), .selected)
        fullBtn.snp.makeConstraints {
            $0.bottom.equalTo(saveBtn.snp.top).offset(-20)
            $0.right.equalTo(shareBtn.snp.right)
            $0.width.height.equalTo(48)
        }
        fullBtn.addTarget(self, action: #selector(fullBtnClick(sender: )), for: .touchUpInside)
        
        //

        clipBtn.adhere(toSuperview: contentV)
            .image(UIImage(named: "i_clip_fen"), .normal)
            .image(UIImage(named: "i_clip_fen_s"), .selected)
        clipBtn.snp.makeConstraints {
            $0.centerY.equalTo(fullBtn.snp.centerY)
            $0.right.equalTo(fullBtn.snp.left).offset(-12)
            $0.width.height.equalTo(48)
        }
        clipBtn.addTarget(self, action: #selector(clipBtnClick(sender: )), for: .touchUpInside)
        
        
        
        
        //
//        let fullLabel: UILabel = UILabel()
//            .fontName(15, "")
//            .color(UIColor(hexString: "#000000")!)
//            .text("整幅/分割")
//            .adhere(toSuperview: contentV)
//        fullLabel.snp.makeConstraints {
//            $0.bottom.equalTo(saveBtn.snp.top).offset(-20)
//            $0.left.equalTo(24)
//            $0.width.greaterThanOrEqualTo(1)
//            $0.height.greaterThanOrEqualTo(1)
//        }
        //
        
//        fullBtnOpen
//            .adhere(toSuperview: contentV)
//        fullBtnOpen.isOn = true
//        fullBtnOpen.snp.makeConstraints {
//            $0.centerY.equalTo(fullLabel)
//            $0.right.equalTo(contentV.snp.right).offset(-24)
//            $0.height.width.greaterThanOrEqualTo(1)
//        }
//        fullBtnOpen.addTarget(self, action: #selector(fullBtnOpenClick(sender: )), for: .valueChanged)
        //
        let previewContentV = UIView()
        previewContentV
            .backgroundColor(UIColor(hexString: "#F4F4F4")!)
            .adhere(toSuperview: contentV)
        
        let preWidth: CGFloat = 270
        let preHeight: CGFloat = contentHeight - 240
        let preX: CGFloat = (contentWidth - preWidth) / 2
        let preY: CGFloat = 66
        
        let previewRect = CGRect(x: preX, y: preY, width: preWidth, height: preHeight)
        
        previewContentV.frame = previewRect
        
        //
        switch slideType {
        case .slider1_3:
            var lengthPer: CGFloat = previewRect.size.width / 3
            if lengthPer > previewRect.size.height {
                lengthPer = previewRect.size.height
            }
            let leftOffset = (previewRect.size.width - (lengthPer * 3)) / 2
            let topOffset = (previewRect.size.height - lengthPer) / 2
            
            //
            let slideRect1 = CGRect(x: leftOffset, y: topOffset, width: lengthPer, height: lengthPer)
            let slideRect2 = CGRect(x: leftOffset + lengthPer, y: topOffset, width: lengthPer, height: lengthPer)
            let slideRect3 = CGRect(x: leftOffset + lengthPer + lengthPer, y: topOffset, width: lengthPer, height: lengthPer)
            //
            let slideImgV1 = UIImageView(frame: slideRect1)
            let slideImgV2 = UIImageView(frame: slideRect2)
            let slideImgV3 = UIImageView(frame: slideRect3)
            sliderAreaViews = [slideImgV1, slideImgV2, slideImgV3]
            
        case .slider2_3:
            var lengthPer: CGFloat = previewRect.size.width / 3
            if lengthPer * 2 > previewRect.size.height {
                lengthPer = previewRect.size.height / 2
            }
            let leftOffset = (previewRect.size.width - (lengthPer * 3)) / 2
            let topOffset = (previewRect.size.height - lengthPer * 2) / 2
            
            //
            let slideRect1 = CGRect(x: leftOffset, y: topOffset, width: lengthPer, height: lengthPer)
            let slideRect2 = CGRect(x: leftOffset + lengthPer, y: topOffset, width: lengthPer, height: lengthPer)
            let slideRect3 = CGRect(x: leftOffset + lengthPer + lengthPer, y: topOffset, width: lengthPer, height: lengthPer)
            let slideRect4 = CGRect(x: leftOffset, y: topOffset + lengthPer, width: lengthPer, height: lengthPer)
            let slideRect5 = CGRect(x: leftOffset + lengthPer, y: topOffset + lengthPer, width: lengthPer, height: lengthPer)
            let slideRect6 = CGRect(x: leftOffset + lengthPer + lengthPer, y: topOffset + lengthPer, width: lengthPer, height: lengthPer)
            
            //
            let slideImgV1 = UIImageView(frame: slideRect1)
            let slideImgV2 = UIImageView(frame: slideRect2)
            let slideImgV3 = UIImageView(frame: slideRect3)
            let slideImgV4 = UIImageView(frame: slideRect4)
            let slideImgV5 = UIImageView(frame: slideRect5)
            let slideImgV6 = UIImageView(frame: slideRect6)
            sliderAreaViews = [slideImgV1, slideImgV2, slideImgV3, slideImgV4, slideImgV5, slideImgV6]
        case .slider3_3:
            var lengthPer: CGFloat = previewRect.size.width / 3
            if lengthPer * 3 > previewRect.size.height {
                lengthPer = previewRect.size.height / 3
            }
            let leftOffset = (previewRect.size.width - (lengthPer * 3)) / 2
            let topOffset = (previewRect.size.height - lengthPer * 3) / 2
            //
            let slideRect1 = CGRect(x: leftOffset, y: topOffset, width: lengthPer, height: lengthPer)
            let slideRect2 = CGRect(x: leftOffset + lengthPer, y: topOffset, width: lengthPer, height: lengthPer)
            let slideRect3 = CGRect(x: leftOffset + lengthPer + lengthPer, y: topOffset, width: lengthPer, height: lengthPer)
            let slideRect4 = CGRect(x: leftOffset, y: topOffset + lengthPer, width: lengthPer, height: lengthPer)
            let slideRect5 = CGRect(x: leftOffset + lengthPer, y: topOffset + lengthPer, width: lengthPer, height: lengthPer)
            let slideRect6 = CGRect(x: leftOffset + lengthPer + lengthPer, y: topOffset + lengthPer, width: lengthPer, height: lengthPer)
            let slideRect7 = CGRect(x: leftOffset, y: topOffset + lengthPer + lengthPer, width: lengthPer, height: lengthPer)
            let slideRect8 = CGRect(x: leftOffset + lengthPer, y: topOffset + lengthPer + lengthPer, width: lengthPer, height: lengthPer)
            let slideRect9 = CGRect(x: leftOffset + lengthPer + lengthPer, y: topOffset + lengthPer + lengthPer, width: lengthPer, height: lengthPer)
            
            //
            let slideImgV1 = UIImageView(frame: slideRect1)
            let slideImgV2 = UIImageView(frame: slideRect2)
            let slideImgV3 = UIImageView(frame: slideRect3)
            let slideImgV4 = UIImageView(frame: slideRect4)
            let slideImgV5 = UIImageView(frame: slideRect5)
            let slideImgV6 = UIImageView(frame: slideRect6)
            let slideImgV7 = UIImageView(frame: slideRect7)
            let slideImgV8 = UIImageView(frame: slideRect8)
            let slideImgV9 = UIImageView(frame: slideRect9)
            sliderAreaViews = [slideImgV1, slideImgV2, slideImgV3, slideImgV4, slideImgV5, slideImgV6, slideImgV7, slideImgV8, slideImgV9]
            
        case .slider3_2:
            var lengthPer: CGFloat = previewRect.size.height / 3
            if lengthPer * 2 > previewRect.size.width {
                lengthPer = previewRect.size.width / 2
            }
            let leftOffset = (previewRect.size.width - (lengthPer * 2)) / 2
            let topOffset = (previewRect.size.height - lengthPer * 3) / 2
            
            //
            let slideRect1 = CGRect(x: leftOffset, y: topOffset, width: lengthPer, height: lengthPer)
            let slideRect2 = CGRect(x: leftOffset + lengthPer, y: topOffset, width: lengthPer, height: lengthPer)
            let slideRect3 = CGRect(x: leftOffset, y: topOffset + lengthPer, width: lengthPer, height: lengthPer)
            let slideRect4 = CGRect(x: leftOffset + lengthPer, y: topOffset + lengthPer, width: lengthPer, height: lengthPer)
            let slideRect5 = CGRect(x: leftOffset, y: topOffset + lengthPer + lengthPer, width: lengthPer, height: lengthPer)
            let slideRect6 = CGRect(x: leftOffset + lengthPer, y: topOffset + lengthPer + lengthPer, width: lengthPer, height: lengthPer)
            
            //
            let slideImgV1 = UIImageView(frame: slideRect1)
            let slideImgV2 = UIImageView(frame: slideRect2)
            let slideImgV3 = UIImageView(frame: slideRect3)
            let slideImgV4 = UIImageView(frame: slideRect4)
            let slideImgV5 = UIImageView(frame: slideRect5)
            let slideImgV6 = UIImageView(frame: slideRect6)
            sliderAreaViews = [slideImgV1, slideImgV2, slideImgV3, slideImgV4, slideImgV5, slideImgV6]
            
        case .slider3_1:
            var lengthPer: CGFloat = previewRect.size.height / 3
            if lengthPer > previewRect.size.width {
                lengthPer = previewRect.size.width
            }
            let leftOffset = (previewRect.size.width - (lengthPer * 1)) / 2
            let topOffset = (previewRect.size.height - lengthPer * 3) / 2
            //
            let slideRect1 = CGRect(x: leftOffset, y: topOffset, width: lengthPer, height: lengthPer)
            let slideRect2 = CGRect(x: leftOffset, y: topOffset + lengthPer, width: lengthPer, height: lengthPer)
            let slideRect3 = CGRect(x: leftOffset, y: topOffset + lengthPer + lengthPer, width: lengthPer, height: lengthPer)
            //
            let slideImgV1 = UIImageView(frame: slideRect1)
            let slideImgV2 = UIImageView(frame: slideRect2)
            let slideImgV3 = UIImageView(frame: slideRect3)
            sliderAreaViews = [slideImgV1, slideImgV2, slideImgV3]
            
        }
        
        previewContentV.removeSubviews()
        
        for (inde, subImgV) in sliderAreaViews.enumerated() {
            let img = slideImgs[inde]
            subImgV.image = img
            subImgV.adhere(toSuperview: previewContentV)
        }
        
    }
    
    func updateFullImgStatus(isFull: Bool) {
        if isFull {
            for subImgV in sliderAreaViews {
                subImgV.transform = CGAffineTransform.identity
            }
        } else {
            for subImgV in sliderAreaViews {
                subImgV.transform = CGAffineTransform.init(scaleX: 0.95, y: 0.95)
            }
        }
    }

    @objc func backBtnClick(sender: UIButton) {
        backBtnClickBlock?()
    }
    @objc func saveBtnClick(sender: UIButton) {
        okBtnClickBlock?()
    }
    @objc func shareBtnClick(sender: UIButton) {
        shareBtnClickBlock?()
    }
//    @objc func fullBtnOpenClick(sender: UISwitch) {
//        updateFullImgStatus(isFull: sender.isOn)
//    }
    @objc func fullBtnClick(sender: UIButton) {
        clipBtn.isSelected = false
        fullBtn.isSelected = true
        updateFullImgStatus(isFull: true)
    }
    @objc func clipBtnClick(sender: UIButton) {
        clipBtn.isSelected = true
        fullBtn.isSelected = false
        updateFullImgStatus(isFull: false)
    }
    
    
}
