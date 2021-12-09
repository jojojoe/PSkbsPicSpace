//
//  PSkMagicCamColorBar.swift
//  PSkbsPicSpace
//
//  Created by JOJO on 2021/12/9.
//

import UIKit
import FlexColorPicker


class PSkMagicCamColorBar: UIView {
    
    var backBtnClickBlock: (()->Void)?
    var selectColorBlock: ((UIColor)->Void)?
    
    var collection: UICollectionView!
    var camSignColorList: [String] = []
    let contentV = UIView()
    let bgV = UIView()
    
    // color picker
    public let colorPicker = ColorPickerController()
    var colorPreview: ColorPreviewWithHex = ColorPreviewWithHex()
    var redSlider: RedSliderControl = RedSliderControl()
    var greenSlider: GreenSliderControl = GreenSliderControl()
    var blueSlider: BlueSliderControl = BlueSliderControl()
    
    var contentHeight: CGFloat = 290
    var isShow: Bool = false
    
    
    func showStatus(isShow: Bool) {
        self.isShow = isShow
        if isShow {
            self.isHidden = false
            bgV.snp.makeConstraints {
                $0.right.equalToSuperview()
                $0.top.bottom.equalToSuperview()
                $0.width.equalTo(400)
            }
        } else {
            bgV.snp.remakeConstraints {
                $0.right.equalToSuperview().offset(420)
                $0.top.bottom.equalToSuperview()
                $0.width.equalTo(400)
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

extension PSkMagicCamColorBar {
    
    func loadData() {
        
        camSignColorList = PSkMagicCamManager.default.camSignColorList
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
        
        bgV
            .backgroundColor(.white)
            .adhere(toSuperview: self)
        bgV.snp.makeConstraints {
            $0.right.equalToSuperview().offset(420)
            $0.top.bottom.equalToSuperview()
            $0.width.equalTo(400)
        }
        
        //
        contentV
            .backgroundColor(UIColor.white)
            .adhere(toSuperview: bgV)
        contentV.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.right.equalToSuperview().offset(-40)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(contentHeight)
        }
        
        //
        let backBtn = UIButton(type: .custom)
        backBtn
            .title("B")
            .image("")
            .backgroundColor(.orange)
            .adhere(toSuperview: bgV)
        backBtn.addTarget(self, action: #selector(backBtnClick(sender:)), for: .touchUpInside)
        backBtn.snp.makeConstraints {
            $0.right.equalToSuperview()
            $0.top.bottom.equalToSuperview()
            $0.width.equalTo(40)
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
            $0.top.equalToSuperview().offset(20)
            $0.height.equalTo(60)
            $0.left.equalToSuperview().offset(100)
        }
        collection.register(cellWithClass: ITMagicCamColorCell.self)
        
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

extension PSkMagicCamColorBar: ColorPickerDelegate {
    func colorPicker(_ colorPicker: ColorPickerController, selectedColor: UIColor, usingControl: ColorControl) {
//        backgroundColor(selectedColor)
        selectColorBlock?(selectedColor)
    }
}

extension PSkMagicCamColorBar {
    @objc func backBtnClick(sender: UIButton) {
        backBtnClickBlock?()
    }
    
    
}

 
extension PSkMagicCamColorBar: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: ITMagicCamColorCell.self, for: indexPath)
        
        let item = camSignColorList[indexPath.item]
        cell.contentImgV
            .backgroundColor(UIColor(hexString: item)!)
        cell.contentImgV.layer.cornerRadius = cell.bounds.width / 2
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return camSignColorList.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension PSkMagicCamColorBar: UICollectionViewDelegateFlowLayout {
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

extension PSkMagicCamColorBar: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let colorStr = camSignColorList[indexPath.item]
        let color = UIColor(hexString: colorStr) ?? UIColor.white
        colorPicker.selectedColor = color
        //
        selectColorBlock?(color)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}







class ITMagicCamColorCell: UICollectionViewCell {
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







