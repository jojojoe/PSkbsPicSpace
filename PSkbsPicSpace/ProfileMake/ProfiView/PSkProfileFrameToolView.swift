//
//  PSkProfileFrameToolView.swift
//  PSkbsPicSpace
//
//  Created by JOJO on 2021/11/11.
//

import UIKit
import ZKProgressHUD

class PSkProfileFrameToolView: UIView {

    var backBtnClickBlock: (()->Void)?
    var selectProfileFrameBlock: ((CGFloat, CGFloat)->Void)?
    var currentFrameItem: PSkProfileFrameItem?
    
    var frameTypeList: [PSkProfileFrameItem] = []
    
    let sizeWidthCountLabel = UILabel()
    let widthAddBtn = UIButton(type: .custom)
    let widthJianBtn = UIButton(type: .custom)
    let sizeHeightCountLabel = UILabel()
    let heightAddBtn = UIButton(type: .custom)
    let heightJianBtn = UIButton(type: .custom)
    var collection: UICollectionView!
    let contentV = UIView()
    
    var currentWidth: CGFloat = 0
    var currentHeight: CGFloat = 0
    let maxV: CGFloat = 2000
    let minV: CGFloat = 100
    let limitRatio: CGFloat = 2
    
    var timer: Timer?
    var isHoldLongPress: Bool = false
    
    var contentHeight: CGFloat = 330
    var isShow: Bool = false
    
    
    func showStatus(isShow: Bool) {
        self.isShow = isShow
        if isShow {
            self.isHidden = false
            contentV.snp.makeConstraints {
                $0.left.right.equalToSuperview()
                $0.bottom.equalToSuperview()
                $0.height.equalTo(contentHeight)
            }
        } else {
            contentV.snp.remakeConstraints {
                $0.left.right.equalToSuperview()
                $0.bottom.equalToSuperview().offset(contentHeight)
                $0.height.equalTo(contentHeight)
            }
        }
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            self.layoutIfNeeded()
        } completion: { finished in
            if finished {
                if isShow == false {
                    self.isHidden = true
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadData()
        setupView()
        setupDefault()
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    func loadData() {
        frameTypeList = PSkProfileManager.default.profileMakeFrameItems
    }
    
    func setupDefault() {
        let indexP = IndexPath(item: 0, section: 0)
        let item = frameTypeList[indexP.item]
        currentWidth = item.pixWidth
        currentHeight = item.pixHeight
        currentFrameItem = item
        collection.reloadData()
        PSkProfileManager.default.currentCanvasWidth = currentWidth
        PSkProfileManager.default.currentCanvasHeight = currentHeight
        
        updateWidthHeight()
        
        collection.selectItem(at: indexP, animated: true, scrollPosition: .centeredHorizontally)
    }
    
    func setupView() {
        backgroundColor = .clear
        
        //
        let bgBtn = UIButton(type: .custom)
        bgBtn
            .image(UIImage(named: ""))
            .adhere(toSuperview: self)
        bgBtn.addTarget(self, action: #selector(backBtnClick(sender:)), for: .touchUpInside)
        bgBtn.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        
        //
        contentV
            .backgroundColor(UIColor.white)
            .adhere(toSuperview: self)
        contentV.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview().offset(contentHeight)
            $0.height.equalTo(contentHeight)
        }
        //
        let masktBV = UIView()
        masktBV
            .backgroundColor(UIColor.white)
            .adhere(toSuperview: self)
        masktBV.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
        
        //
        let backBtn = UIButton(type: .custom)
        backBtn
            .image("i_profile_downview")
            .backgroundColor(.white)
            .adhere(toSuperview: contentV)
        backBtn.addTarget(self, action: #selector(backBtnClick(sender:)), for: .touchUpInside)
        backBtn.snp.makeConstraints {
            $0.top.equalTo(contentV.snp.top).offset(0)
            $0.right.equalTo(contentV.snp.right).offset(0)
            $0.left.equalTo(contentV.snp.left).offset(0)
            $0.height.equalTo(35)
        }
        backBtn.layer.shadowColor = UIColor(hexString: "#F3F3F3")!.cgColor
        backBtn.layer.shadowOffset = CGSize(width: 0, height: -1)
        backBtn.layer.shadowRadius = 8
        backBtn.layer.shadowOpacity = 0.8
        //
        
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collection = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collection.backgroundColor(UIColor(hexString: "#F3F3F3")!)
        collection.showsHorizontalScrollIndicator = false
        collection.delegate = self
        collection.dataSource = self
        addSubview(collection)
        collection.snp.makeConstraints {
            $0.right.left.equalToSuperview()
            $0.top.equalTo(backBtn.snp.bottom)
            $0.height.equalTo(120)
        }
        collection.register(cellWithClass: PSkProfileFrameCell.self)
        
        //
//        let pointPixLabel = UILabel()
//        pointPixLabel
//            .text("分辨率/尺寸")
//            .color(UIColor.orange)
//            .textAlignment(.left)
//            .fontName(15, "AvenirNext-Regular")
//            .adhere(toSuperview: contentV)
//        pointPixLabel.snp.makeConstraints {
//            $0.left.equalTo(contentV.snp.left).offset(30)
//            $0.top.equalTo(collection.snp.bottom).offset(8)
//            $0.width.height.greaterThanOrEqualTo(1)
//        }
        
        //
        let sizeWidthImgV = UIImageView()
        sizeWidthImgV
            .image("i_profile_sizew")
            .adhere(toSuperview: contentV)
        sizeWidthImgV.snp.makeConstraints {
            $0.left.equalTo(contentV.snp.left).offset(24)
            $0.top.equalTo(collection.snp.bottom).offset(24)
            $0.width.height.greaterThanOrEqualTo(28)
        }
        
        //
        widthJianBtn
            .image(UIImage(named: "i_profile_size_jian"))
            .adhere(toSuperview: contentV)
        widthJianBtn.addTarget(self, action: #selector(widthJianBtnClickTouchUp(sender: )), for: .touchUpInside)
        
        let widthJianLongGes = UILongPressGestureRecognizer()
        widthJianLongGes.addTarget(self, action: #selector(widthJianLongGesAction(ges: )))
        widthJianBtn.addGestureRecognizer(widthJianLongGes)
        
        widthJianBtn.snp.makeConstraints {
            $0.top.equalTo(sizeWidthImgV.snp.bottom).offset(24)
            $0.left.equalTo(sizeWidthImgV.snp.left).offset(0)
            $0.width.height.equalTo(34)
        }
        
        //
        
        sizeWidthCountLabel
            .backgroundColor(UIColor(hexString: "#F3F3F3")!)
            .fontName(15, "AvenirNext-DemiBold")
            .textAlignment(.center)
            .color(UIColor.black)
            .text("1024")
            .adhere(toSuperview: contentV)
        sizeWidthCountLabel.snp.makeConstraints {
            $0.left.equalTo(widthJianBtn.snp.right).offset(2)
            $0.centerY.equalTo(widthJianBtn.snp.centerY).offset(0)
            $0.width.equalTo(58)
            $0.height.equalTo(24)
        }
        sizeWidthCountLabel.layer.cornerRadius = 4
        sizeWidthCountLabel.layer.masksToBounds = true
        //
        
        widthAddBtn
            .image(UIImage(named: "i_profile_size_jia"))
            .adhere(toSuperview: contentV)
        widthAddBtn.addTarget(self, action: #selector(widthAddBtnClickTouchUp(sender: )), for: .touchUpInside)
        let widthAddLongGes = UILongPressGestureRecognizer()
        widthAddLongGes.addTarget(self, action: #selector(widthAddLongGesAction(ges: )))
        widthAddBtn.addGestureRecognizer(widthAddLongGes)
        
        widthAddBtn.snp.makeConstraints {
            $0.centerY.equalTo(sizeWidthCountLabel.snp.centerY)
            $0.left.equalTo(sizeWidthCountLabel.snp.right).offset(2)
            $0.width.height.equalTo(34)
        }
        
        //
        let sizeHeightImgV = UIImageView()
        sizeHeightImgV
            .image("i_profile_sizeh")
            .adhere(toSuperview: contentV)
        sizeHeightImgV.snp.makeConstraints {
            $0.left.equalTo(contentV.snp.centerX).offset(10)
            $0.centerY.equalTo(sizeWidthImgV.snp.centerY)
            $0.width.height.greaterThanOrEqualTo(28)
        }
        //

        //
        heightJianBtn
            .image(UIImage(named: "i_profile_size_jian"))
            .adhere(toSuperview: contentV)
        heightJianBtn.addTarget(self, action: #selector(heightJianBtnClickTouchUp(sender: )), for: .touchUpInside)

        //
        let heightJianLongGes = UILongPressGestureRecognizer()
        heightJianLongGes.addTarget(self, action: #selector(heightJianLongGesAction(ges: )))
        heightJianBtn.addGestureRecognizer(heightJianLongGes)
        
        //
        heightJianBtn.snp.makeConstraints {
            $0.centerY.equalTo(widthJianBtn.snp.centerY)
            $0.left.equalTo(sizeHeightImgV.snp.left).offset(0)
            $0.width.height.equalTo(34)
        }

        
        //
        sizeHeightCountLabel
            .backgroundColor(UIColor(hexString: "#F3F3F3")!)
            .fontName(15, "AvenirNext-DemiBold")
            .textAlignment(.center)
            .color(UIColor.black)
            .text("1024")
            .adhere(toSuperview: contentV)
        sizeHeightCountLabel.snp.makeConstraints {
            $0.left.equalTo(heightJianBtn.snp.right).offset(2)
            $0.centerY.equalTo(heightJianBtn.snp.centerY).offset(0)
            $0.width.equalTo(58)
            $0.height.equalTo(24)
        }
        sizeHeightCountLabel.layer.cornerRadius = 4
        sizeHeightCountLabel.layer.masksToBounds = true
        //
        //

        heightAddBtn
            .image(UIImage(named: "i_profile_size_jia"))
            .adhere(toSuperview: contentV)
        heightAddBtn.addTarget(self, action: #selector(heightAddBtnClickTouchUp(sender: )), for: .touchUpInside)

        //
        let heightAddLongGes = UILongPressGestureRecognizer()
        heightAddLongGes.addTarget(self, action: #selector(heightAddLongGesAction(ges: )))
        heightAddBtn.addGestureRecognizer(heightAddLongGes)
        
        heightAddBtn.snp.makeConstraints {
            $0.centerY.equalTo(sizeHeightCountLabel.snp.centerY)
            $0.left.equalTo(sizeHeightCountLabel.snp.right).offset(2)
            $0.width.height.equalTo(34)
        }

        
    }
    
}


extension PSkProfileFrameToolView {
    @objc func autoWidthAdd() {
        var step: CGFloat = 1
        if isHoldLongPress == true {
            step = 100
        }
        var value = currentWidth + step
        let limitV = currentHeight * limitRatio
        
        if value >= maxV || value >= limitV {
            if limitV > maxV {
                value = maxV
            } else {
                value = limitV
            }
            if !ZKProgressHUD.isShowing {
                ZKProgressHUD.showMessage("Max Value")
            }
        } else {
            
        }
        currentWidth = value
        updateWidthHeight()
    }
    
    @objc func autoWidthJian() {
        var step: CGFloat = 1
        if isHoldLongPress == true {
            step = 100
        }
        var value = currentWidth - step
        let limitV = currentHeight / limitRatio
        if value <= minV || value <= limitV {
            if limitV > minV {
                value = limitV
            } else {
                value = minV
            }
            if !ZKProgressHUD.isShowing {
                ZKProgressHUD.showMessage("Max Value")
            }
            
        } else {
            
        }
        currentWidth = value
        updateWidthHeight()
    }
    
    @objc func autoHeightAdd() {
        var step: CGFloat = 1
        
        if isHoldLongPress == true {
            step = 100
        }
        var value = currentHeight + step
        let limitV = currentWidth * limitRatio
        
        if value >= maxV || value >= limitV {
            if limitV > maxV {
                value = maxV
            } else {
                value = limitV
            }
            if !ZKProgressHUD.isShowing {
                ZKProgressHUD.showMessage("Max Value")
            }
        } else {
            
        }
        currentHeight = value
        updateWidthHeight()
    }
    
    @objc func autoHeightJian() {
        var step: CGFloat = 1
        
        if isHoldLongPress == true {
            step = 100
        }
        var value = currentHeight - step
        let limitV = currentWidth / limitRatio
        
        if value <= minV || value <= limitV {
            if limitV > minV {
                value = limitV
            } else {
                value = minV
            }
            if !ZKProgressHUD.isShowing {
                ZKProgressHUD.showMessage("Max Value")
            }
        } else {
            
        }
        currentHeight = value
        updateWidthHeight()
    }
}

extension PSkProfileFrameToolView {
    @objc func backBtnClick(sender: UIButton) {
        backBtnClickBlock?()
    }
    
    
    
 
    @objc func widthAddBtnClickTouchUp(sender: UIButton) {
        isHoldLongPress = false
        autoWidthAdd()
    }
    
 
    @objc func widthJianBtnClickTouchUp(sender: UIButton) {
        isHoldLongPress = false
        autoWidthJian()
    }
    
 
    
    @objc func heightAddBtnClickTouchUp(sender: UIButton) {
        isHoldLongPress = false
        autoHeightAdd()
    }
    
    
    @objc func heightJianBtnClickTouchUp(sender: UIButton) {
        isHoldLongPress = false
        autoHeightJian()
    }
    
    @objc func widthAddLongGesAction(ges: UIGestureRecognizer) {
        
        if ges.state == .began {
            
            timer = Timer.init(timeInterval: 0.1, target: self, selector: #selector(autoWidthAdd), userInfo: nil, repeats: true)
            if let timer_m = timer {
                RunLoop.main.add(timer_m, forMode: .common)
            }
            
            isHoldLongPress = false
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                [weak self] in
                guard let `self` = self else {return}
                self.isHoldLongPress = true
            }
        }
        
        if ges.state == .ended {
            timer?.invalidate()
            timer = nil
            isHoldLongPress = false
        }
    }
    
    @objc func widthJianLongGesAction(ges: UIGestureRecognizer) {
        if ges.state == .began {
            
            timer = Timer.init(timeInterval: 0.1, target: self, selector: #selector(autoWidthJian), userInfo: nil, repeats: true)
            if let timer_m = timer {
                RunLoop.main.add(timer_m, forMode: .common)
            }
            
            isHoldLongPress = false
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                [weak self] in
                guard let `self` = self else {return}
                self.isHoldLongPress = true
            }
        }
        
        if ges.state == .ended {
            timer?.invalidate()
            timer = nil
            isHoldLongPress = false
        }
    }
    
    @objc func heightAddLongGesAction(ges: UIGestureRecognizer) {
        if ges.state == .began {
            
            timer = Timer.init(timeInterval: 0.1, target: self, selector: #selector(autoHeightAdd), userInfo: nil, repeats: true)
            if let timer_m = timer {
                RunLoop.main.add(timer_m, forMode: .common)
            }
            
            isHoldLongPress = false
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                [weak self] in
                guard let `self` = self else {return}
                self.isHoldLongPress = true
            }
        }
        
        if ges.state == .ended {
            timer?.invalidate()
            timer = nil
            isHoldLongPress = false
        }
    }
    
    @objc func heightJianLongGesAction(ges: UIGestureRecognizer) {
        if ges.state == .began {
            
            timer = Timer.init(timeInterval: 0.1, target: self, selector: #selector(autoHeightJian), userInfo: nil, repeats: true)
            if let timer_m = timer {
                RunLoop.main.add(timer_m, forMode: .common)
            }
            
            isHoldLongPress = false
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                [weak self] in
                guard let `self` = self else {return}
                self.isHoldLongPress = true
            }
        }
        
        if ges.state == .ended {
            timer?.invalidate()
            timer = nil
            isHoldLongPress = false
        }
    }
    
    func updateWidthHeight()  {
        sizeWidthCountLabel.text("\(Int(currentWidth))")
        sizeHeightCountLabel.text("\(Int(currentHeight))")
        selectProfileFrameBlock?(currentWidth, currentHeight)
    }
    
}




extension PSkProfileFrameToolView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: PSkProfileFrameCell.self, for: indexPath)
        let item = frameTypeList[indexPath.item]
        
        if currentFrameItem?.iconImgStr == item.iconImgStr {
            cell.contentImgV.image(item.titleStr)
        } else {
            cell.contentImgV.image(item.iconImgStr)
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return frameTypeList.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension PSkProfileFrameToolView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 65, height: 65)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
}

extension PSkProfileFrameToolView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = frameTypeList[indexPath.item]
        
        currentFrameItem = item
        collectionView.reloadData()
        currentWidth = CGFloat(Int(item.pixWidth))
        currentHeight = CGFloat(Int(item.pixHeight))
        
        self.updateWidthHeight()
        
        
//        widthAddBtn.isHidden = false
//        widthJianBtn.isHidden = false
//        heightAddBtn.isHidden = false
//        heightJianBtn.isHidden = false
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}




class PSkProfileFrameCell: UICollectionViewCell {
    
    
    let contentImgV = UIImageView()
//    let nameLabel: UILabel = UILabel().fontName(12, "AvenirNext-Regular").color(UIColor.orange).textAlignment(.center)
//    let selectedImgView = UIImageView().image("").backgroundColor(.clear)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        
        
        contentImgV
            .contentMode(.scaleAspectFit)
            .adhere(toSuperview: contentView)
        contentImgV.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.height.equalTo(64)
            $0.width.equalTo(64)
        }
        //
        
        
//        nameLabel
//            .adjustsFontSizeToFitWidth()
//            .adhere(toSuperview: contentView)
//        nameLabel.snp.makeConstraints {
//            $0.left.right.equalToSuperview()
//            $0.top.equalTo(contentImgV.snp.bottom)
//            $0.bottom.equalTo(contentView.snp.bottom)
//        }
//
//        selectedImgView
//            .adhere(toSuperview: contentView)
//        selectedImgView.isHidden = true
//        selectedImgView.snp.makeConstraints {
//            $0.top.bottom.left.right.equalTo(contentImgV)
//        }
//
        
    }
    
//    override var isSelected: Bool {
//        didSet {
//            selectedImgView.isHidden = !isSelected
//
//        }
//    }
    
    
}
