//
//  PSkProfilePhotoToolView.swift
//  PSkbsPicSpace
//
//  Created by JOJO on 2021/11/11.
//

import UIKit



class PSkProfilePhotoToolView: UIView {

    var backBtnClickBlock: (()->Void)?
    var addNewPhotoBlock: (()->Void)?
    
    let contentV = UIView()
    var collection: UICollectionView!
    
    var selectUserPhotoBlock: ((ProfilePhotoItem)->Void)?
    
    var deleteBtnClickBlock: ((ProfilePhotoItem?)->Void)?
    var resetBtnClickBlock: ((ProfilePhotoItem?)->Void)?
    var removeBgBtnClickBlock: ((ProfilePhotoItem?)->Void)?
    var beautyBtnClickBlock: ((ProfilePhotoItem?)->Void)?
    var mirrorBtnClickBlock: ((ProfilePhotoItem?)->Void)?
    var upMoveBtnClickBlock: ((ProfilePhotoItem?)->Void)?
    var downMoveBtnClickBlock: ((ProfilePhotoItem?)->Void)?
    
    
    var contentHeight: CGFloat = 500
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
    
    // 扣除背景 镜像 磨皮
    
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
        PSkProfileManager.default.setupTestPhotoItemList()
    }
    
}


extension PSkProfilePhotoToolView {
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
            .title("Back")
            .image("")
            .backgroundColor(.orange)
            .adhere(toSuperview: contentV)
        backBtn.addTarget(self, action: #selector(backBtnClick(sender:)), for: .touchUpInside)
        backBtn.snp.makeConstraints {
            $0.top.equalTo(contentV.snp.top).offset(0)
            $0.right.equalTo(contentV.snp.right).offset(0)
            $0.left.equalTo(contentV.snp.left).offset(0)
            $0.height.equalTo(35)
        }
        
        //
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collection = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.backgroundColor = .clear
        collection.delegate = self
        collection.dataSource = self
        contentV.addSubview(collection)
        collection.snp.makeConstraints {
            $0.top.equalTo(backBtn.snp.bottom)
            $0.bottom.right.left.equalToSuperview()
        }
        collection.register(cellWithClass: PSkProfilePhotoToolCell.self)
    }
    
    func setupDefault() {
        
    }
    
}

extension PSkProfilePhotoToolView {
    @objc func backBtnClick(sender: UIButton) {
        backBtnClickBlock?()
    }
    
    
}

extension PSkProfilePhotoToolView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: PSkProfilePhotoToolCell.self, for: indexPath)
        let item = PSkProfileManager.default.photoItemList[indexPath.item]
        cell.photoItem = item
        if let bgColor = item.bgColor {
            cell.bgColorFrameView.backgroundColor(bgColor)
        }
        if let isRemoveBg = item.isRemoveBg {
            if isRemoveBg == true, let removeImg = item.smartImg {
                cell.photoImgV.image = removeImg
            } else {
                cell.photoImgV.image = item.originImg
            }
            cell.removeBgBtn.isSelected = isRemoveBg
        }
        if let isMirror = item.isMirror {
            cell.mirrorBtn.isSelected = isMirror
            if isMirror == true {
                cell.photoImgV.transform = CGAffineTransform(scaleX: -1, y: 1)
            } else {
                cell.photoImgV.transform = CGAffineTransform.identity
            }
        }
        if let isSkinBeauty = item.isSkinBeauty {
            cell.beautyBtn.isSelected = isSkinBeauty
        }
        
        
        if PSkProfileManager.default.currentItem == item {
            cell.selectV.isHidden = false
        } else {
            cell.selectV.isHidden = true
        }
        
        
        if item == PSkProfileManager.default.bgColorPhotoItem {
            cell.bgColorFrameView.isHidden = false
            let wS = "\(Int(PSkProfileManager.default.currentCanvasWidth ?? 0))"
            let hS = "\(Int(PSkProfileManager.default.currentCanvasHeight ?? 0))"
                
            cell.bgColorFrameTitleLabel
                .text("\(wS) x \(hS)")
                .backgroundColor(UIColor.white)
                .color(UIColor.black)
            cell.canvasV.isHidden = true
            cell.addNewImgV.isHidden = true
        } else if item == PSkProfileManager.default.addNewPhotoItem {
            cell.bgColorFrameView.isHidden = true
            cell.canvasV.isHidden = true
            cell.addNewImgV.isHidden = false
        } else {
            cell.bgColorFrameView.isHidden = true
            cell.canvasV.isHidden = false
            cell.addNewImgV.isHidden = true
        }
        
        
        
        if PSkProfileManager.default.userPhotosItem.count == 0 {
            
        } else if PSkProfileManager.default.userPhotosItem.count == 1 {
            cell.upMoveBtn.isHidden = true
            cell.downMoveBtn.isHidden = true
        } else if PSkProfileManager.default.userPhotosItem.count == 2 {
            if item == PSkProfileManager.default.userPhotosItem[0] {
                cell.upMoveBtn.isHidden = true
                cell.downMoveBtn.isHidden = false
            } else {
                cell.upMoveBtn.isHidden = false
                cell.downMoveBtn.isHidden = true
            }
        } else {
            if item == PSkProfileManager.default.userPhotosItem[0] {
                cell.upMoveBtn.isHidden = true
                cell.downMoveBtn.isHidden = false
            } else if item == PSkProfileManager.default.userPhotosItem[PSkProfileManager.default.userPhotosItem.count - 1] {
                cell.upMoveBtn.isHidden = false
                cell.downMoveBtn.isHidden = true
            } else {
                cell.upMoveBtn.isHidden = false
                cell.downMoveBtn.isHidden = false
            }
        }
        //
        cell.deleteBtnClickBlock = {
            [weak self] item in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                self.deleteBtnClickBlock?(item)
            }
            
        }
        cell.resetBtnClickBlock = {
            [weak self] item in
            guard let `self` = self else {return}
            guard let item_m = item else { return }
            DispatchQueue.main.async {
                self.resetBtnClickBlock?(item)
                self.selectUserPhotoBlock?(item_m)
            }
        }
        cell.removeBgBtnClickBlock = {
            [weak self] item in
            guard let `self` = self else {return}
            guard let item_m = item else { return }
            DispatchQueue.main.async {
                self.removeBgBtnClickBlock?(item)
                self.selectUserPhotoBlock?(item_m)
            }
        }
        cell.beautyBtnClickBlock = {
            [weak self] item in
            guard let `self` = self else {return}
            guard let item_m = item else { return }
            DispatchQueue.main.async {
                self.beautyBtnClickBlock?(item)
                self.selectUserPhotoBlock?(item_m)
            }
        }
        cell.mirrorBtnClickBlock = {
            [weak self] item in
            guard let `self` = self else {return}
            guard let item_m = item else { return }
            DispatchQueue.main.async {
                self.mirrorBtnClickBlock?(item)
                self.selectUserPhotoBlock?(item_m)
            }
        }
        cell.upMoveBtnClickBlock = {
            [weak self] item in
            guard let `self` = self else {return}
            guard let item_m = item else { return }
            DispatchQueue.main.async {
                self.upMoveBtnClickBlock?(item)
                self.selectUserPhotoBlock?(item_m)
            }
        }
        cell.downMoveBtnClickBlock = {
            [weak self] item in
            guard let `self` = self else {return}
            guard let item_m = item else { return }
            DispatchQueue.main.async {
                self.downMoveBtnClickBlock?(item)
                self.selectUserPhotoBlock?(item_m)
            }
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return PSkProfileManager.default.photoItemList.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension PSkProfilePhotoToolView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let left: CGFloat = 10
        let width: CGFloat = UIScreen.main.bounds.width - left * 2
        
        let item = PSkProfileManager.default.photoItemList[indexPath.item]
        var isAddNewItem = false
        if item.originImg == nil && item.bgColor == nil  {
            isAddNewItem = true
        }
        
        
        if indexPath.item == 0 {
            // Add New Photo
            return CGSize(width: width, height: 60)
        } else if isAddNewItem {
            return CGSize(width: width, height: 40)
        } else {
            return CGSize(width: width, height: 100)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
}

extension PSkProfilePhotoToolView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = PSkProfileManager.default.photoItemList[indexPath.item]
        if item == PSkProfileManager.default.addNewPhotoItem {
            addNewPhotoBlock?()
        } else if item == PSkProfileManager.default.bgColorPhotoItem {
            
        } else {
            
            collectionView.reloadData()
            selectUserPhotoBlock?(item)
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}





class PSkProfilePhotoToolCell: UICollectionViewCell {
    let contentImgV = UIImageView()
    
    let canvasV = UIView()
    let addNewImgV = UIImageView()
    
    var bgColorFrameView = UIView()
    var bgColorFrameTitleLabel = UILabel()
    
    
    var selectV = UIView()
    
    let deleteBtn = UIButton(type: .custom)
    let resetBtn = UIButton(type: .custom)
    
    let photoImgV = UIImageView()
    
    let removeBgBtn = UIButton(type: .custom)
    let beautyBtn = UIButton(type: .custom)
    let mirrorBtn = UIButton(type: .custom)
    let upMoveBtn = UIButton(type: .custom)
    let downMoveBtn = UIButton(type: .custom)
    
    var photoItem: ProfilePhotoItem?
    
    var deleteBtnClickBlock: ((ProfilePhotoItem?)->Void)?
    var resetBtnClickBlock: ((ProfilePhotoItem?)->Void)?
    var removeBgBtnClickBlock: ((ProfilePhotoItem?)->Void)?
    var beautyBtnClickBlock: ((ProfilePhotoItem?)->Void)?
    var mirrorBtnClickBlock: ((ProfilePhotoItem?)->Void)?
    var upMoveBtnClickBlock: ((ProfilePhotoItem?)->Void)?
    var downMoveBtnClickBlock: ((ProfilePhotoItem?)->Void)?
   
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        // 100
        contentView.backgroundColor(UIColor.lightGray)
        
        
        //
        contentImgV.contentMode = .scaleAspectFill
        contentImgV.clipsToBounds = true
        contentView.addSubview(contentImgV)
        contentImgV.snp.makeConstraints {
            $0.top.right.bottom.left.equalToSuperview()
        }
        
        //
        bgColorFrameView
            .backgroundColor(UIColor.clear)
            .adhere(toSuperview: contentView)
        bgColorFrameView.snp.makeConstraints {
            $0.top.right.bottom.left.equalToSuperview()
        }
        bgColorFrameTitleLabel.layer.cornerRadius = 6
        bgColorFrameTitleLabel
            .fontName(20, "AvenirNext-DemiBold")
            .color(UIColor(hexString: "#000000")!)
            .textAlignment(.center)
            .adhere(toSuperview: bgColorFrameView)
        bgColorFrameTitleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(190)
            $0.height.equalTo(30)
        }
        
        //
        canvasV
            .backgroundColor(.white)
            .adhere(toSuperview: contentView)
        canvasV.snp.makeConstraints {
            $0.top.right.bottom.left.equalToSuperview()
        }
        
        
        //
        addNewImgV
            .backgroundColor(UIColor(hexString: "#A0A0A0")!)
            .adhere(toSuperview: contentView)
        addNewImgV.snp.makeConstraints {
            $0.top.right.bottom.left.equalToSuperview()
        }
        
        //
        let bgBorderV = UIView()
        bgBorderV
            .isUserInteractionEnabled(false)
            .backgroundColor(UIColor.clear)
            .adhere(toSuperview: contentView)
        bgBorderV.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        bgBorderV.layer.borderColor = UIColor.black.cgColor
        bgBorderV.layer.borderWidth = 3
        
        //
        selectV.isUserInteractionEnabled = false
        selectV.layer.borderColor = UIColor.yellow.cgColor
        selectV.layer.borderWidth = 3
        selectV
            .backgroundColor(.clear)
            .adhere(toSuperview: contentView)
        selectV.snp.makeConstraints {
            $0.top.right.bottom.left.equalToSuperview()
        }
        //
        
        deleteBtn
            .title("D")
            .titleColor(UIColor.orange)
            .backgroundColor(UIColor.purple)
            .adhere(toSuperview: canvasV)
        deleteBtn.addTarget(self, action: #selector(deleteBtnClick(sender: )), for: .touchUpInside)
        deleteBtn.snp.makeConstraints {
            $0.bottom.equalTo(contentView.snp.centerY).offset(-2)
            $0.left.equalTo(10)
            $0.width.height.equalTo(30)
        }
        
        //
        resetBtn
            .title("R")
            .titleColor(UIColor.orange)
            .backgroundColor(UIColor.purple)
            .adhere(toSuperview: canvasV)
        resetBtn.addTarget(self, action: #selector(resetBtnClick(sender: )), for: .touchUpInside)
        resetBtn.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.centerY).offset(2)
            $0.left.equalTo(10)
            $0.width.height.equalTo(30)
        }
        
        //
        photoImgV
            .contentMode(.scaleAspectFill)
            .clipsToBounds()
            .backgroundColor(.darkGray)
            .adhere(toSuperview: canvasV)
        photoImgV.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(deleteBtn.snp.right).offset(10)
            $0.width.height.equalTo(80)
        }
        //
        removeBgBtn
            .image(UIImage(named: ""), .normal)
            .image(UIImage(named: ""), .selected)
            .title("R", .normal)
            .title("Red", .selected)
            .titleColor(.white)
            .backgroundColor(.purple)
            .adhere(toSuperview: canvasV)
        removeBgBtn.snp.makeConstraints {
            $0.bottom.equalTo(photoImgV.snp.bottom)
            $0.left.equalTo(photoImgV.snp.right).offset(20)
            $0.width.height.equalTo(40)
        }
        removeBgBtn.addTarget(self, action: #selector(removeBgBtnClick(sender:)), for: .touchUpInside)
        //
        beautyBtn
            .image(UIImage(named: ""), .normal)
            .image(UIImage(named: ""), .selected)
            .title("S", .normal)
            .title("Sed", .selected)
            .titleColor(.white)
            .backgroundColor(.purple)
            .adhere(toSuperview: canvasV)
        beautyBtn.snp.makeConstraints {
            $0.bottom.equalTo(photoImgV.snp.bottom)
            $0.left.equalTo(removeBgBtn.snp.right).offset(10)
            $0.width.height.equalTo(40)
        }
        beautyBtn.addTarget(self, action: #selector(skinBeautyBtnClick(sender:)), for: .touchUpInside)
        //
        mirrorBtn
            .image(UIImage(named: ""), .normal)
            .image(UIImage(named: ""), .selected)
            .title("M", .normal)
            .title("Med", .selected)
            .titleColor(.white)
            .backgroundColor(.purple)
            .adhere(toSuperview: canvasV)
        mirrorBtn.snp.makeConstraints {
            $0.bottom.equalTo(photoImgV.snp.bottom)
            $0.left.equalTo(beautyBtn.snp.right).offset(10)
            $0.width.height.equalTo(40)
        }
        mirrorBtn.addTarget(self, action: #selector(mirrorBtnClick(sender:)), for: .touchUpInside)
        //
        upMoveBtn
            .image(UIImage(named: ""), .normal)
            .image(UIImage(named: ""), .selected)
            .title("u", .normal)
            .title("ued", .selected)
            .titleColor(.white)
            .backgroundColor(.purple)
            .adhere(toSuperview: canvasV)
        upMoveBtn.snp.makeConstraints {
            $0.bottom.equalTo(snp.centerY).offset(-5)
            $0.right.equalTo(canvasV.snp.right).offset(-10)
            $0.width.height.equalTo(40)
        }
        upMoveBtn.addTarget(self, action: #selector(moveUpBtnClick(sender:)), for: .touchUpInside)
        
        //
        downMoveBtn
            .image(UIImage(named: ""), .normal)
            .image(UIImage(named: ""), .selected)
            .title("d", .normal)
            .title("ded", .selected)
            .titleColor(.white)
            .backgroundColor(.purple)
            .adhere(toSuperview: canvasV)
        downMoveBtn.snp.makeConstraints {
            $0.top.equalTo(snp.centerY).offset(5)
            $0.right.equalTo(upMoveBtn.snp.right)
            $0.width.height.equalTo(40)
        }
        downMoveBtn.addTarget(self, action: #selector(moveDownBtnClick(sender:)), for: .touchUpInside)
        
    }
    
    @objc func deleteBtnClick(sender: UIButton) {
        deleteBtnClickBlock?(photoItem)
    }
    @objc func resetBtnClick(sender: UIButton) {
        resetBtnClickBlock?(photoItem)
    }
    @objc func removeBgBtnClick(sender: UIButton) {
        removeBgBtnClickBlock?(photoItem)
    }
    @objc func skinBeautyBtnClick(sender: UIButton) {
        beautyBtnClickBlock?(photoItem)
    }
    @objc func mirrorBtnClick(sender: UIButton) {
        mirrorBtnClickBlock?(photoItem)
    }
    @objc func moveUpBtnClick(sender: UIButton) {
        upMoveBtnClickBlock?(photoItem)
    }
    @objc func moveDownBtnClick(sender: UIButton) {
        downMoveBtnClickBlock?(photoItem)
    }
    
    
    
}

