//
//  PSkMagicCamBorderBar.swift
//  PSkbsPicSpace
//
//  Created by JOJO on 2021/12/8.
//

import UIKit
 

class PSkMagicCamBorderBar: UIView {

    var collection: UICollectionView!
    var camBorderBarClickBlock: ((CamBorderItem)->Void)?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension PSkMagicCamBorderBar {
    func setupView() {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collection = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.backgroundColor = .clear
        collection.delegate = self
        collection.dataSource = self
        addSubview(collection)
        collection.snp.makeConstraints {
            $0.top.bottom.right.left.equalToSuperview()
        }
        collection.register(cellWithClass: PSkMagicCamBorderCell.self)
    }
    
    
    
}

extension PSkMagicCamBorderBar: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: PSkMagicCamBorderCell.self, for: indexPath)
        let item = PSkMagicCamManager.default.camBorderList[indexPath.item]
        cell.contentView.layer.cornerRadius = 10
        cell.contentView.layer.masksToBounds = true
        cell.contentView
            .backgroundColor(UIColor.darkGray)
        cell.contentImgV
            .image(item.thumb)
        cell.nameL.text(item.imgPosition)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return PSkMagicCamManager.default.camBorderList.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension PSkMagicCamBorderBar: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 90, height: 90)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
}

extension PSkMagicCamBorderBar: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = PSkMagicCamManager.default.camBorderList[indexPath.item]
        camBorderBarClickBlock?(item)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}



class PSkMagicCamBorderCell: UICollectionViewCell {
    let contentImgV = UIImageView()
    let nameL = UILabel()
    
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
            $0.center.equalToSuperview()
            $0.left.equalToSuperview().offset(6)
            $0.top.equalToSuperview().offset(6)
        }
        //
        nameL
            .fontName(10, "AvenirNext-DemiBold")
            .adjustsFontSizeToFitWidth()
            .color(UIColor.white)
            .adhere(toSuperview: contentView)
        nameL.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.top.left.equalToSuperview()
        }
        
    }
}
