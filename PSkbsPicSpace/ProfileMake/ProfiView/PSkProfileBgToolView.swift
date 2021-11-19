//
//  PSkProfileBgToolView.swift
//  PSkbsPicSpace
//
//  Created by JOJO on 2021/11/11.
//

import UIKit
import FlexColorPicker


class PSkProfileBgToolView: UIView {
    

    var backBtnClickBlock: (()->Void)?
    var selectColorBlock: ((UIColor)->Void)?
    
    var collection: UICollectionView!
    var profileBgColorList: [String] = []
    let contentV = UIView()
    
    
    // color picker
    public let colorPicker = ColorPickerController()
    var colorPreview: ColorPreviewWithHex = ColorPreviewWithHex()
    var redSlider: RedSliderControl = RedSliderControl()
    var greenSlider: GreenSliderControl = GreenSliderControl()
    var blueSlider: BlueSliderControl = BlueSliderControl()
    
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
        setupColorPicker()
        setupDefault()
        
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    
    

}

extension PSkProfileBgToolView {
    
    func loadData() {
        profileBgColorList = PSkDataManager.default.profileBgColors
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
        layout.scrollDirection = .horizontal
        collection = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collection.backgroundColor(.lightGray)
        collection.showsHorizontalScrollIndicator = false
        collection.delegate = self
        collection.dataSource = self
        contentV.addSubview(collection)
        collection.snp.makeConstraints {
            $0.right.equalToSuperview()
            $0.top.equalTo(backBtn.snp.bottom).offset(20)
            $0.height.equalTo(60)
            $0.left.equalTo(100)
        }
        collection.register(cellWithClass: ITProfileBgColorCell.self)
        
        //
         
        
    }
    
    func setupColorPicker() {
        /*
        let customAdjsutLabel = UILabel()
        customAdjsutLabel
            .text("Adjust")
            .color(.darkGray)
            .fontName(12, "AvenirNext-Medium")
            .adhere(toSuperview: self)
        customAdjsutLabel.snp.makeConstraints {
            $0.left.equalTo(30)
            $0.top.equalTo(collection.snp.bottom).offset(8)
            $0.width.height.greaterThanOrEqualTo(1)

        }
        */
        
        colorPicker.delegate = self
        colorPicker.colorPreview = colorPreview
        colorPicker.redSlider = redSlider
        colorPicker.greenSlider = greenSlider
        colorPicker.blueSlider = blueSlider
        
        colorPreview.adhere(toSuperview: contentV)
        redSlider.adhere(toSuperview: contentV)
        greenSlider.adhere(toSuperview: contentV)
        blueSlider.adhere(toSuperview: contentV)
        
        colorPreview.snp.makeConstraints {
            $0.centerY.equalTo(collection.snp.centerY)
            $0.left.equalTo(20)
            $0.width.equalTo(60)
            $0.height.equalTo(60)
        }
        
        //
        redSlider.snp.makeConstraints {
            $0.left.equalTo(40)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(collection.snp.bottom).offset(30)
            $0.height.equalTo(30)
        }
        greenSlider.snp.makeConstraints {
            $0.left.equalTo(40)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(redSlider.snp.bottom).offset(30)
            $0.height.equalTo(30)
        }
        blueSlider.snp.makeConstraints {
            $0.left.equalTo(40)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(greenSlider.snp.bottom).offset(30)
            $0.height.equalTo(30)
        }
        
        
        
    }
    
    func setupDefault() {
        
    }
    
    
}

extension PSkProfileBgToolView: ColorPickerDelegate {
    func colorPicker(_ colorPicker: ColorPickerController, selectedColor: UIColor, usingControl: ColorControl) {
//        backgroundColor(selectedColor)
        selectColorBlock?(selectedColor)
    }
}

extension PSkProfileBgToolView {
    @objc func backBtnClick(sender: UIButton) {
        backBtnClickBlock?()
    }
    
    
}

 
extension PSkProfileBgToolView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: ITProfileBgColorCell.self, for: indexPath)
        
        let item = profileBgColorList[indexPath.item]
        cell.contentImgV
            .backgroundColor(UIColor(hexString: item)!)
        cell.contentImgV.layer.cornerRadius = cell.bounds.width / 2
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return profileBgColorList.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension PSkProfileBgToolView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 40, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
}

extension PSkProfileBgToolView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let colorStr = profileBgColorList[indexPath.item]
        let color = UIColor(hexString: colorStr) ?? UIColor.white
        colorPicker.selectedColor = color
        //
        selectColorBlock?(color)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}







class ITProfileBgColorCell: UICollectionViewCell {
    let contentImgV = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        contentImgV.contentMode = .scaleAspectFill
        contentImgV.clipsToBounds = true
        contentView.addSubview(contentImgV)
        contentImgV.snp.makeConstraints {
            $0.top.right.bottom.left.equalToSuperview()
        }
        
        
    }
}







