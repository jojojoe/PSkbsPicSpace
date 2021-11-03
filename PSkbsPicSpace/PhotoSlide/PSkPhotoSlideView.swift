//
//  PSkPhotoSlideView.swift
//  PSkbsPicSpace
//
//  Created by JOJO on 2021/11/3.
//

import UIKit
 

enum SliderType {
    case slider1_3
    case slider2_3
    case slider3_3
    case slider3_2
    case slider3_1
}

class PSkPhotoSlideView: UIView, UIScrollViewDelegate {
    var sliderType: SliderType = .slider1_3
    
    let scrolleView = UIScrollView.init()
    let contentImageView = UIImageView()
    var maskLayerViews: [UIView] = []
    var sliderLineViews: [UIView] = []
    var sliderAreaViews: [UIView] = []
    var imageViewWidth: CGFloat?
    var imageViewHeight: CGFloat?
    var isSelectZoom = true
    var contentImage: UIImage
    
    var leftOffset: CGFloat = 0
    var topOffset: CGFloat = 0
    var scrollZoomScale: CGFloat = 1
    
    init(frame: CGRect, contentImage: UIImage) {
        self.contentImage = contentImage
        super.init(frame: frame)
        setupView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        self.scrolleView.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        scrolleView.maximumZoomScale = 3
        scrolleView.backgroundColor = UIColor.white
        scrolleView.delegate = self
        self.addSubview(self.scrolleView)
        //
        contentImageView.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        contentImageView.image = contentImage
        contentImageView.contentMode = .scaleAspectFit
        self.scrolleView.addSubview(contentImageView)
        
        //
        debugPrint("contentImageView size = \(contentImageView.frame.size)")
        self.scrolleView.contentSize = contentImageView.frame.size
        self.scrolleView.minimumZoomScale = self.frame.size.width / contentImageView.frame.size.width
        
    }
    
    
    
}

extension PSkPhotoSlideView {
    func processSlideImages() -> [UIImage] {
        let resultImage = contentImage.originImageToScaleSize(size: CGSize(width: contentImage.size.width * scrollZoomScale, height: contentImage.size.height * scrollZoomScale))
        let scale = resultImage.size.height / self.contentImageView.frame.size.height
        
        let imgOffsetLeft: CGFloat = scrolleView.contentOffset.x * scale
        let imgOffsetTop: CGFloat = scrolleView.contentOffset.y * scale
        
        var imgs: [UIImage] = []
        
        
        for subView in sliderAreaViews {
            let areaX = subView.frame.origin.x * scale - leftOffset * scale
            let areaY = subView.frame.origin.y * scale - topOffset * scale
            let pointX: CGFloat = areaX + imgOffsetLeft
            let pointY: CGFloat = areaY + imgOffsetTop
            let width: CGFloat = subView.size.width * scale
            
            let rect = CGRect(x: pointX, y: pointY , width: width, height: width)
            let img = UIImage.init(cgImage: ((resultImage.cgImage?.cropping(to: rect))!))
            imgs.append(img)
        }
        
        return imgs
    }
}

extension PSkPhotoSlideView {
    func updateSliderStyle(sliderType: SliderType) {
        //
        for area in sliderAreaViews {
            area.removeFromSuperview()
        }
        for area in maskLayerViews {
            area.removeFromSuperview()
        }
        
        sliderAreaViews = []
        maskLayerViews = []
        
        scrolleView.zoomScale = 1
        
        
        switch sliderType {
        case .slider1_3:
            updateSlider1_3()
        case .slider2_3:
            updateSlider2_3()
        case .slider3_3:
            updateSlider3_3()
        case .slider3_2:
            updateSlider3_2()
        case .slider3_1:
            updateSlider3_1()
        }
        
         
    }
    
    func updateSlider1_3() {
        var lengthPer: CGFloat = frame.size.width / 3
        if lengthPer > frame.size.height {
            lengthPer = frame.size.height
        }
        leftOffset = (frame.size.width - (lengthPer * 3)) / 2
        topOffset = (frame.size.height - lengthPer) / 2
        
        //
        let slideRect1 = UIView()
        slideRect1
            .isUserInteractionEnabled(false)
            .backgroundColor(UIColor.clear)
            .adhere(toSuperview: self)
        slideRect1.snp.makeConstraints {
            $0.left.equalTo(self.snp.left).offset(leftOffset)
            $0.top.equalTo(self.snp.top).offset(topOffset)
            $0.width.height.equalTo(lengthPer)
        }
        slideRect1.layer.borderWidth = 0.5
        slideRect1.layer.borderColor = UIColor.white.cgColor
        //
        let slideRect2 = UIView()
        slideRect2
            .isUserInteractionEnabled(false)
            .backgroundColor(UIColor.clear)
            .adhere(toSuperview: self)
        slideRect2.snp.makeConstraints {
            $0.left.equalTo(slideRect1.snp.right).offset(0)
            $0.top.equalTo(self.snp.top).offset(topOffset)
            $0.width.height.equalTo(lengthPer)
        }
        slideRect2.layer.borderWidth = 0.5
        slideRect2.layer.borderColor = UIColor.white.cgColor
        //
        let slideRect3 = UIView()
        slideRect3
            .isUserInteractionEnabled(false)
            .backgroundColor(UIColor.clear)
            .adhere(toSuperview: self)
        slideRect3.snp.makeConstraints {
            $0.left.equalTo(slideRect2.snp.right).offset(0)
            $0.top.equalTo(self.snp.top).offset(topOffset)
            $0.width.height.equalTo(lengthPer)
        }
        slideRect3.layer.borderWidth = 0.5
        slideRect3.layer.borderColor = UIColor.white.cgColor
        
        //
        let maskVleft = UIView()
        let maskVright = UIView()
        let maskVtop = UIView()
        let maskVbottom = UIView()
        maskVleft.isUserInteractionEnabled = false
        maskVright.isUserInteractionEnabled = false
        maskVtop.isUserInteractionEnabled = false
        maskVbottom.isUserInteractionEnabled = false
        //
        maskVleft
            .backgroundColor(UIColor.white.withAlphaComponent(0.4))
            .adhere(toSuperview: self)
        maskVright
            .backgroundColor(UIColor.white.withAlphaComponent(0.4))
            .adhere(toSuperview: self)
        maskVtop
            .backgroundColor(UIColor.white.withAlphaComponent(0.4))
            .adhere(toSuperview: self)
        maskVbottom
            .backgroundColor(UIColor.white.withAlphaComponent(0.4))
            .adhere(toSuperview: self)
        
        maskVleft.snp.makeConstraints {
            $0.left.equalTo(self.snp.left)
            $0.top.equalTo(self.snp.top)
            $0.bottom.equalTo(self.snp.bottom)
            $0.right.equalTo(slideRect1.snp.left)
        }
        maskVright.snp.makeConstraints {
            $0.left.equalTo(slideRect3.snp.right)
            $0.top.equalTo(self.snp.top)
            $0.bottom.equalTo(self.snp.bottom)
            $0.right.equalTo(self.snp.right)
        }
        maskVtop.snp.makeConstraints {
            $0.left.equalTo(slideRect1.snp.left)
            $0.top.equalTo(self.snp.top)
            $0.bottom.equalTo(slideRect1.snp.top)
            $0.right.equalTo(slideRect3.snp.right)
        }
        maskVbottom.snp.makeConstraints {
            $0.left.equalTo(slideRect1.snp.left)
            $0.bottom.equalTo(self.snp.bottom)
            $0.top.equalTo(slideRect1.snp.bottom)
            $0.right.equalTo(slideRect3.snp.right)
        }
        
        sliderAreaViews = [slideRect1, slideRect2, slideRect3]
        maskLayerViews = [maskVleft, maskVright, maskVtop, maskVbottom]
        
        //
        let scrollWidth: CGFloat = frame.size.width + leftOffset * 2
        let scrollHeight: CGFloat = frame.size.height + topOffset * 2
        scrolleView.contentSize = CGSize(width: scrollWidth, height: scrollHeight)
        contentImageView.frame = CGRect(x: leftOffset, y: topOffset, width: frame.size.width, height: frame.size.height)
        
        scrolleView.contentOffset = CGPoint(x: leftOffset, y: topOffset)
    }
    func updateSlider2_3() {
        var lengthPer: CGFloat = frame.size.width / 3
        if lengthPer * 2 > frame.size.height {
            lengthPer = frame.size.height / 2
        }
        leftOffset = (frame.size.width - (lengthPer * 3)) / 2
        topOffset = (frame.size.height - lengthPer * 2) / 2
        
        //
        let slideRect1 = UIView()
        slideRect1
            .isUserInteractionEnabled(false)
            .backgroundColor(UIColor.clear)
            .adhere(toSuperview: self)
        slideRect1.snp.makeConstraints {
            $0.left.equalTo(self.snp.left).offset(leftOffset)
            $0.top.equalTo(self.snp.top).offset(topOffset)
            $0.width.height.equalTo(lengthPer)
        }
        slideRect1.layer.borderWidth = 0.5
        slideRect1.layer.borderColor = UIColor.white.cgColor
        //
        let slideRect2 = UIView()
        slideRect2
            .isUserInteractionEnabled(false)
            .backgroundColor(UIColor.clear)
            .adhere(toSuperview: self)
        slideRect2.snp.makeConstraints {
            $0.left.equalTo(slideRect1.snp.right).offset(0)
            $0.top.equalTo(self.snp.top).offset(topOffset)
            $0.width.height.equalTo(lengthPer)
        }
        slideRect2.layer.borderWidth = 0.5
        slideRect2.layer.borderColor = UIColor.white.cgColor
        //
        let slideRect3 = UIView()
        slideRect3
            .isUserInteractionEnabled(false)
            .backgroundColor(UIColor.clear)
            .adhere(toSuperview: self)
        slideRect3.snp.makeConstraints {
            $0.left.equalTo(slideRect2.snp.right).offset(0)
            $0.top.equalTo(self.snp.top).offset(topOffset)
            $0.width.height.equalTo(lengthPer)
        }
        slideRect3.layer.borderWidth = 0.5
        slideRect3.layer.borderColor = UIColor.white.cgColor
        //
        let slideRect4 = UIView()
        slideRect4
            .isUserInteractionEnabled(false)
            .backgroundColor(UIColor.clear)
            .adhere(toSuperview: self)
        slideRect4.snp.makeConstraints {
            $0.left.equalTo(self.snp.left).offset(leftOffset)
            $0.bottom.equalTo(self.snp.bottom).offset(-topOffset)
            $0.width.height.equalTo(lengthPer)
        }
        slideRect4.layer.borderWidth = 0.5
        slideRect4.layer.borderColor = UIColor.white.cgColor
        //
        let slideRect5 = UIView()
        slideRect5
            .isUserInteractionEnabled(false)
            .backgroundColor(UIColor.clear)
            .adhere(toSuperview: self)
        slideRect5.snp.makeConstraints {
            $0.left.equalTo(slideRect1.snp.right).offset(0)
            $0.bottom.equalTo(self.snp.bottom).offset(-topOffset)
            $0.width.height.equalTo(lengthPer)
        }
        slideRect5.layer.borderWidth = 0.5
        slideRect5.layer.borderColor = UIColor.white.cgColor
        //
        let slideRect6 = UIView()
        slideRect6
            .isUserInteractionEnabled(false)
            .backgroundColor(UIColor.clear)
            .adhere(toSuperview: self)
        slideRect6.snp.makeConstraints {
            $0.left.equalTo(slideRect2.snp.right).offset(0)
            $0.bottom.equalTo(self.snp.bottom).offset(-topOffset)
            $0.width.height.equalTo(lengthPer)
        }
        slideRect6.layer.borderWidth = 0.5
        slideRect6.layer.borderColor = UIColor.white.cgColor
        
        //
        let maskVleft = UIView()
        let maskVright = UIView()
        let maskVtop = UIView()
        let maskVbottom = UIView()
        maskVleft.isUserInteractionEnabled = false
        maskVright.isUserInteractionEnabled = false
        maskVtop.isUserInteractionEnabled = false
        maskVbottom.isUserInteractionEnabled = false
        //
        maskVleft
            .backgroundColor(UIColor.white.withAlphaComponent(0.4))
            .adhere(toSuperview: self)
        maskVright
            .backgroundColor(UIColor.white.withAlphaComponent(0.4))
            .adhere(toSuperview: self)
        maskVtop
            .backgroundColor(UIColor.white.withAlphaComponent(0.4))
            .adhere(toSuperview: self)
        maskVbottom
            .backgroundColor(UIColor.white.withAlphaComponent(0.4))
            .adhere(toSuperview: self)
        
        maskVleft.snp.makeConstraints {
            $0.left.equalTo(self.snp.left)
            $0.top.equalTo(self.snp.top)
            $0.bottom.equalTo(self.snp.bottom)
            $0.right.equalTo(slideRect1.snp.left)
        }
        maskVright.snp.makeConstraints {
            $0.left.equalTo(slideRect3.snp.right)
            $0.top.equalTo(self.snp.top)
            $0.bottom.equalTo(self.snp.bottom)
            $0.right.equalTo(self.snp.right)
        }
        maskVtop.snp.makeConstraints {
            $0.left.equalTo(slideRect1.snp.left)
            $0.top.equalTo(self.snp.top)
            $0.bottom.equalTo(slideRect1.snp.top)
            $0.right.equalTo(slideRect3.snp.right)
        }
        maskVbottom.snp.makeConstraints {
            $0.left.equalTo(slideRect4.snp.left)
            $0.bottom.equalTo(self.snp.bottom)
            $0.top.equalTo(slideRect4.snp.bottom)
            $0.right.equalTo(slideRect6.snp.right)
        }
        
        sliderAreaViews = [slideRect1, slideRect2, slideRect3, slideRect4, slideRect5, slideRect6]
        maskLayerViews = [maskVleft, maskVright, maskVtop, maskVbottom]
        
        //
        let scrollWidth: CGFloat = frame.size.width + leftOffset * 2
        let scrollHeight: CGFloat = frame.size.height + topOffset * 2
        scrolleView.contentSize = CGSize(width: scrollWidth, height: scrollHeight)
        contentImageView.frame = CGRect(x: leftOffset, y: topOffset, width: frame.size.width, height: frame.size.height)
        scrolleView.contentOffset = CGPoint(x: leftOffset, y: topOffset)
    }
    func updateSlider3_3() {
        var lengthPer: CGFloat = frame.size.width / 3
        if lengthPer * 3 > frame.size.height {
            lengthPer = frame.size.height / 3
        }
        leftOffset = (frame.size.width - (lengthPer * 3)) / 2
        topOffset = (frame.size.height - lengthPer * 3) / 2
        
        //
        let slideRect1 = UIView()
        slideRect1
            .isUserInteractionEnabled(false)
            .backgroundColor(UIColor.clear)
            .adhere(toSuperview: self)
        slideRect1.snp.makeConstraints {
            $0.left.equalTo(self.snp.left).offset(leftOffset)
            $0.top.equalTo(self.snp.top).offset(topOffset)
            $0.width.height.equalTo(lengthPer)
        }
        slideRect1.layer.borderWidth = 0.5
        slideRect1.layer.borderColor = UIColor.white.cgColor
        //
        let slideRect2 = UIView()
        slideRect2
            .isUserInteractionEnabled(false)
            .backgroundColor(UIColor.clear)
            .adhere(toSuperview: self)
        slideRect2.snp.makeConstraints {
            $0.left.equalTo(slideRect1.snp.right).offset(0)
            $0.top.equalTo(self.snp.top).offset(topOffset)
            $0.width.height.equalTo(lengthPer)
        }
        slideRect2.layer.borderWidth = 0.5
        slideRect2.layer.borderColor = UIColor.white.cgColor
        //
        let slideRect3 = UIView()
        slideRect3
            .isUserInteractionEnabled(false)
            .backgroundColor(UIColor.clear)
            .adhere(toSuperview: self)
        slideRect3.snp.makeConstraints {
            $0.left.equalTo(slideRect2.snp.right).offset(0)
            $0.top.equalTo(self.snp.top).offset(topOffset)
            $0.width.height.equalTo(lengthPer)
        }
        slideRect3.layer.borderWidth = 0.5
        slideRect3.layer.borderColor = UIColor.white.cgColor
        //
        let slideRect4 = UIView()
        slideRect4
            .isUserInteractionEnabled(false)
            .backgroundColor(UIColor.clear)
            .adhere(toSuperview: self)
        slideRect4.snp.makeConstraints {
            $0.left.equalTo(self.snp.left).offset(leftOffset)
            $0.top.equalTo(slideRect1.snp.bottom).offset(0)
            $0.width.height.equalTo(lengthPer)
        }
        slideRect4.layer.borderWidth = 0.5
        slideRect4.layer.borderColor = UIColor.white.cgColor
        //
        let slideRect5 = UIView()
        slideRect5
            .isUserInteractionEnabled(false)
            .backgroundColor(UIColor.clear)
            .adhere(toSuperview: self)
        slideRect5.snp.makeConstraints {
            $0.left.equalTo(slideRect1.snp.right).offset(0)
            $0.top.equalTo(slideRect1.snp.bottom).offset(0)
            $0.width.height.equalTo(lengthPer)
        }
        slideRect5.layer.borderWidth = 0.5
        slideRect5.layer.borderColor = UIColor.white.cgColor
        //
        let slideRect6 = UIView()
        slideRect6
            .isUserInteractionEnabled(false)
            .backgroundColor(UIColor.clear)
            .adhere(toSuperview: self)
        slideRect6.snp.makeConstraints {
            $0.left.equalTo(slideRect2.snp.right).offset(0)
            $0.top.equalTo(slideRect1.snp.bottom).offset(0)
            $0.width.height.equalTo(lengthPer)
        }
        slideRect6.layer.borderWidth = 0.5
        slideRect6.layer.borderColor = UIColor.white.cgColor
        
        //
        let slideRect7 = UIView()
        slideRect7
            .isUserInteractionEnabled(false)
            .backgroundColor(UIColor.clear)
            .adhere(toSuperview: self)
        slideRect7.snp.makeConstraints {
            $0.left.equalTo(self.snp.left).offset(leftOffset)
            $0.bottom.equalTo(self.snp.bottom).offset(-topOffset)
            $0.width.height.equalTo(lengthPer)
        }
        slideRect7.layer.borderWidth = 0.5
        slideRect7.layer.borderColor = UIColor.white.cgColor
        //
        let slideRect8 = UIView()
        slideRect8
            .isUserInteractionEnabled(false)
            .backgroundColor(UIColor.clear)
            .adhere(toSuperview: self)
        slideRect8.snp.makeConstraints {
            $0.left.equalTo(slideRect1.snp.right).offset(0)
            $0.bottom.equalTo(self.snp.bottom).offset(-topOffset)
            $0.width.height.equalTo(lengthPer)
        }
        slideRect8.layer.borderWidth = 0.5
        slideRect8.layer.borderColor = UIColor.white.cgColor
        //
        let slideRect9 = UIView()
        slideRect9
            .isUserInteractionEnabled(false)
            .backgroundColor(UIColor.clear)
            .adhere(toSuperview: self)
        slideRect9.snp.makeConstraints {
            $0.left.equalTo(slideRect2.snp.right).offset(0)
            $0.bottom.equalTo(self.snp.bottom).offset(-topOffset)
            $0.width.height.equalTo(lengthPer)
        }
        slideRect9.layer.borderWidth = 0.5
        slideRect9.layer.borderColor = UIColor.white.cgColor
        
        
        //
        let maskVleft = UIView()
        let maskVright = UIView()
        let maskVtop = UIView()
        let maskVbottom = UIView()
        maskVleft.isUserInteractionEnabled = false
        maskVright.isUserInteractionEnabled = false
        maskVtop.isUserInteractionEnabled = false
        maskVbottom.isUserInteractionEnabled = false
        //
        maskVleft
            .backgroundColor(UIColor.white.withAlphaComponent(0.4))
            .adhere(toSuperview: self)
        maskVright
            .backgroundColor(UIColor.white.withAlphaComponent(0.4))
            .adhere(toSuperview: self)
        maskVtop
            .backgroundColor(UIColor.white.withAlphaComponent(0.4))
            .adhere(toSuperview: self)
        maskVbottom
            .backgroundColor(UIColor.white.withAlphaComponent(0.4))
            .adhere(toSuperview: self)
        
        maskVleft.snp.makeConstraints {
            $0.left.equalTo(self.snp.left)
            $0.top.equalTo(self.snp.top)
            $0.bottom.equalTo(self.snp.bottom)
            $0.right.equalTo(slideRect1.snp.left)
        }
        maskVright.snp.makeConstraints {
            $0.left.equalTo(slideRect3.snp.right)
            $0.top.equalTo(self.snp.top)
            $0.bottom.equalTo(self.snp.bottom)
            $0.right.equalTo(self.snp.right)
        }
        maskVtop.snp.makeConstraints {
            $0.left.equalTo(slideRect1.snp.left)
            $0.top.equalTo(self.snp.top)
            $0.bottom.equalTo(slideRect1.snp.top)
            $0.right.equalTo(slideRect3.snp.right)
        }
        maskVbottom.snp.makeConstraints {
            $0.left.equalTo(slideRect7.snp.left)
            $0.bottom.equalTo(self.snp.bottom)
            $0.top.equalTo(slideRect7.snp.bottom)
            $0.right.equalTo(slideRect9.snp.right)
        }
        
        sliderAreaViews = [slideRect1, slideRect2, slideRect3, slideRect4, slideRect5, slideRect6, slideRect7, slideRect8, slideRect9]
        maskLayerViews = [maskVleft, maskVright, maskVtop, maskVbottom]
        
        //
        let scrollWidth: CGFloat = frame.size.width + leftOffset * 2
        let scrollHeight: CGFloat = frame.size.height + topOffset * 2
        scrolleView.contentSize = CGSize(width: scrollWidth, height: scrollHeight)
        contentImageView.frame = CGRect(x: leftOffset, y: topOffset, width: frame.size.width, height: frame.size.height)
        scrolleView.contentOffset = CGPoint(x: leftOffset, y: topOffset)
    }
    func updateSlider3_2() {
        var lengthPer: CGFloat = frame.size.height / 3
        if lengthPer * 2 > frame.size.width {
            lengthPer = frame.size.width / 2
        }
        leftOffset = (frame.size.width - (lengthPer * 2)) / 2
        topOffset = (frame.size.height - lengthPer * 3) / 2
        
        //
        let slideRect1 = UIView()
        slideRect1
            .isUserInteractionEnabled(false)
            .backgroundColor(UIColor.clear)
            .adhere(toSuperview: self)
        slideRect1.snp.makeConstraints {
            $0.left.equalTo(self.snp.left).offset(leftOffset)
            $0.top.equalTo(self.snp.top).offset(topOffset)
            $0.width.height.equalTo(lengthPer)
        }
        slideRect1.layer.borderWidth = 0.5
        slideRect1.layer.borderColor = UIColor.white.cgColor
        //
        let slideRect2 = UIView()
        slideRect2
            .isUserInteractionEnabled(false)
            .backgroundColor(UIColor.clear)
            .adhere(toSuperview: self)
        slideRect2.snp.makeConstraints {
            $0.left.equalTo(slideRect1.snp.right).offset(0)
            $0.top.equalTo(self.snp.top).offset(topOffset)
            $0.width.height.equalTo(lengthPer)
        }
        slideRect2.layer.borderWidth = 0.5
        slideRect2.layer.borderColor = UIColor.white.cgColor
        //
        let slideRect3 = UIView()
        slideRect3
            .isUserInteractionEnabled(false)
            .backgroundColor(UIColor.clear)
            .adhere(toSuperview: self)
        slideRect3.snp.makeConstraints {
            $0.left.equalTo(slideRect1.snp.left).offset(0)
            $0.top.equalTo(slideRect1.snp.bottom)
            $0.width.height.equalTo(lengthPer)
        }
        slideRect3.layer.borderWidth = 0.5
        slideRect3.layer.borderColor = UIColor.white.cgColor
        //
        let slideRect4 = UIView()
        slideRect4
            .isUserInteractionEnabled(false)
            .backgroundColor(UIColor.clear)
            .adhere(toSuperview: self)
        slideRect4.snp.makeConstraints {
            $0.left.equalTo(slideRect2.snp.left).offset(0)
            $0.bottom.equalTo(slideRect3.snp.bottom)
            $0.width.height.equalTo(lengthPer)
        }
        slideRect4.layer.borderWidth = 0.5
        slideRect4.layer.borderColor = UIColor.white.cgColor
        //
        let slideRect5 = UIView()
        slideRect5
            .isUserInteractionEnabled(false)
            .backgroundColor(UIColor.clear)
            .adhere(toSuperview: self)
        slideRect5.snp.makeConstraints {
            $0.left.equalTo(slideRect1.snp.left).offset(0)
            $0.top.equalTo(slideRect3.snp.bottom).offset(0)
            $0.width.height.equalTo(lengthPer)
        }
        slideRect5.layer.borderWidth = 0.5
        slideRect5.layer.borderColor = UIColor.white.cgColor
        //
        let slideRect6 = UIView()
        slideRect6
            .isUserInteractionEnabled(false)
            .backgroundColor(UIColor.clear)
            .adhere(toSuperview: self)
        slideRect6.snp.makeConstraints {
            $0.left.equalTo(slideRect2.snp.left).offset(0)
            $0.bottom.equalTo(slideRect5.snp.bottom).offset(0)
            $0.width.height.equalTo(lengthPer)
        }
        slideRect6.layer.borderWidth = 0.5
        slideRect6.layer.borderColor = UIColor.white.cgColor
        
        //
        let maskVleft = UIView()
        let maskVright = UIView()
        let maskVtop = UIView()
        let maskVbottom = UIView()
        maskVleft.isUserInteractionEnabled = false
        maskVright.isUserInteractionEnabled = false
        maskVtop.isUserInteractionEnabled = false
        maskVbottom.isUserInteractionEnabled = false
        //
        maskVleft
            .backgroundColor(UIColor.white.withAlphaComponent(0.4))
            .adhere(toSuperview: self)
        maskVright
            .backgroundColor(UIColor.white.withAlphaComponent(0.4))
            .adhere(toSuperview: self)
        maskVtop
            .backgroundColor(UIColor.white.withAlphaComponent(0.4))
            .adhere(toSuperview: self)
        maskVbottom
            .backgroundColor(UIColor.white.withAlphaComponent(0.4))
            .adhere(toSuperview: self)
        
        maskVleft.snp.makeConstraints {
            $0.left.equalTo(self.snp.left)
            $0.top.equalTo(self.snp.top)
            $0.bottom.equalTo(self.snp.bottom)
            $0.right.equalTo(slideRect1.snp.left)
        }
        maskVright.snp.makeConstraints {
            $0.left.equalTo(slideRect2.snp.right)
            $0.top.equalTo(self.snp.top)
            $0.bottom.equalTo(self.snp.bottom)
            $0.right.equalTo(self.snp.right)
        }
        maskVtop.snp.makeConstraints {
            $0.left.equalTo(slideRect1.snp.left)
            $0.top.equalTo(self.snp.top)
            $0.bottom.equalTo(slideRect1.snp.top)
            $0.right.equalTo(slideRect2.snp.right)
        }
        maskVbottom.snp.makeConstraints {
            $0.left.equalTo(slideRect5.snp.left)
            $0.bottom.equalTo(self.snp.bottom)
            $0.top.equalTo(slideRect5.snp.bottom)
            $0.right.equalTo(slideRect6.snp.right)
        }
        
        sliderAreaViews = [slideRect1, slideRect2, slideRect3, slideRect4, slideRect5, slideRect6]
        maskLayerViews = [maskVleft, maskVright, maskVtop, maskVbottom]
        
        //
        let scrollWidth: CGFloat = frame.size.width + leftOffset * 2
        let scrollHeight: CGFloat = frame.size.height + topOffset * 2
        scrolleView.contentSize = CGSize(width: scrollWidth, height: scrollHeight)
        contentImageView.frame = CGRect(x: leftOffset, y: topOffset, width: frame.size.width, height: frame.size.height)
        scrolleView.contentOffset = CGPoint(x: leftOffset, y: topOffset)
    }
    
    func updateSlider3_1() {
        var lengthPer: CGFloat = frame.size.height / 3
        if lengthPer > frame.size.width {
            lengthPer = frame.size.width
        }
        leftOffset = (frame.size.width - (lengthPer * 1)) / 2
        topOffset = (frame.size.height - lengthPer * 3) / 2
        
        //
        let slideRect1 = UIView()
        slideRect1
            .isUserInteractionEnabled(false)
            .backgroundColor(UIColor.clear)
            .adhere(toSuperview: self)
        slideRect1.snp.makeConstraints {
            $0.left.equalTo(self.snp.left).offset(leftOffset)
            $0.top.equalTo(self.snp.top).offset(topOffset)
            $0.width.height.equalTo(lengthPer)
        }
        slideRect1.layer.borderWidth = 0.5
        slideRect1.layer.borderColor = UIColor.white.cgColor
        //
        let slideRect2 = UIView()
        slideRect2
            .isUserInteractionEnabled(false)
            .backgroundColor(UIColor.clear)
            .adhere(toSuperview: self)
        slideRect2.snp.makeConstraints {
            $0.left.equalTo(slideRect1.snp.left).offset(0)
            $0.top.equalTo(slideRect1.snp.bottom).offset(0)
            $0.width.height.equalTo(lengthPer)
        }
        slideRect2.layer.borderWidth = 0.5
        slideRect2.layer.borderColor = UIColor.white.cgColor
        //
        let slideRect3 = UIView()
        slideRect3
            .isUserInteractionEnabled(false)
            .backgroundColor(UIColor.clear)
            .adhere(toSuperview: self)
        slideRect3.snp.makeConstraints {
            $0.left.equalTo(slideRect1.snp.left).offset(0)
            $0.top.equalTo(slideRect2.snp.bottom).offset(0)
            $0.width.height.equalTo(lengthPer)
        }
        slideRect3.layer.borderWidth = 0.5
        slideRect3.layer.borderColor = UIColor.white.cgColor
        
        //
        let maskVleft = UIView()
        let maskVright = UIView()
        let maskVtop = UIView()
        let maskVbottom = UIView()
        maskVleft.isUserInteractionEnabled = false
        maskVright.isUserInteractionEnabled = false
        maskVtop.isUserInteractionEnabled = false
        maskVbottom.isUserInteractionEnabled = false
        //
        maskVleft
            .backgroundColor(UIColor.white.withAlphaComponent(0.4))
            .adhere(toSuperview: self)
        maskVright
            .backgroundColor(UIColor.white.withAlphaComponent(0.4))
            .adhere(toSuperview: self)
        maskVtop
            .backgroundColor(UIColor.white.withAlphaComponent(0.4))
            .adhere(toSuperview: self)
        maskVbottom
            .backgroundColor(UIColor.white.withAlphaComponent(0.4))
            .adhere(toSuperview: self)
        
        maskVleft.snp.makeConstraints {
            $0.left.equalTo(self.snp.left)
            $0.top.equalTo(self.snp.top)
            $0.bottom.equalTo(self.snp.bottom)
            $0.right.equalTo(slideRect1.snp.left)
        }
        maskVright.snp.makeConstraints {
            $0.left.equalTo(slideRect1.snp.right)
            $0.top.equalTo(self.snp.top)
            $0.bottom.equalTo(self.snp.bottom)
            $0.right.equalTo(self.snp.right)
        }
        maskVtop.snp.makeConstraints {
            $0.left.equalTo(slideRect1.snp.left)
            $0.top.equalTo(self.snp.top)
            $0.bottom.equalTo(slideRect1.snp.top)
            $0.right.equalTo(slideRect1.snp.right)
        }
        maskVbottom.snp.makeConstraints {
            $0.left.equalTo(slideRect1.snp.left)
            $0.bottom.equalTo(self.snp.bottom)
            $0.top.equalTo(slideRect3.snp.bottom)
            $0.right.equalTo(slideRect1.snp.right)
        }
        
        sliderAreaViews = [slideRect1, slideRect2, slideRect3]
        maskLayerViews = [maskVleft, maskVright, maskVtop, maskVbottom]
        
        //
        let scrollWidth: CGFloat = frame.size.width + leftOffset * 2
        let scrollHeight: CGFloat = frame.size.height + topOffset * 2
        scrolleView.contentSize = CGSize(width: scrollWidth, height: scrollHeight)
        contentImageView.frame = CGRect(x: leftOffset, y: topOffset, width: frame.size.width, height: frame.size.height)
        
        scrolleView.contentOffset = CGPoint(x: leftOffset, y: topOffset)
    }
    
}

extension PSkPhotoSlideView {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        debugPrint(scrollView.contentOffset)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return contentImageView
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        debugPrint("\(scale)")
        
        scrollZoomScale = scale
        
        
        let sizeWidth = scrollView.frame.size.width * scale + leftOffset * 2
        let sizeHeight = scrollView.frame.size.height * scale + topOffset * 2
        scrolleView.contentSize = CGSize(width: sizeWidth, height: sizeHeight)
        
         
         
    }
    
    func zoomFunction() {
    }
    
    func contentImageCenter() {
 
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
         
    }
}
