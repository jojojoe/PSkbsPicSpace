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
    var currentItem: CamBorderItem?
    var isVipBorder: Bool = false
    
    
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
//        cell.contentView.layer.cornerRadius = 10
        cell.contentView.layer.masksToBounds = true
        cell.contentView
            .backgroundColor(UIColor.clear)
        cell.contentImgV
            .image(item.thumb)
//        cell.nameL.text(item.imgPosition)
        
        
        if currentItem?.thumb == item.thumb {
            cell.selectV.isHidden = false
        } else {
            cell.selectV.isHidden = true
        }
        
        if indexPath.item <= 1 {
            cell.vipImgV.isHidden = true
        } else {
            if PurchaseManager.share.inSubscription {
                cell.vipImgV.isHidden = true
            } else {
                cell.vipImgV.isHidden = false
            }
        }
        
        
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
        return CGSize(width: 74, height: 74)
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
        currentItem = item
        collectionView.reloadData()
        if indexPath.item <= 1 {
            isVipBorder = false
        } else {
            isVipBorder = true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}



class PSkMagicCamBorderCell: UICollectionViewCell {
    let contentImgV = UIImageView()
    let selectV = UIView()
    let vipImgV = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        contentImgV.contentMode = .scaleAspectFit
        contentImgV.clipsToBounds = true
        contentView.addSubview(contentImgV)
        contentImgV.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.left.equalToSuperview().offset(0)
            $0.top.equalToSuperview().offset(0)
        }
        
        //
        let selectW: CGFloat = 20
        
        selectV.adhere(toSuperview: contentView)
            .backgroundColor(UIColor(hexString: "#EEAB00")!)
        selectV.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(8)
            $0.width.height.equalTo(selectW)
        }
        selectV.layer.cornerRadius = selectW/2
        selectV.layer.masksToBounds = true

        //
        vipImgV
            .image("i_viplog")
            .contentMode(.scaleAspectFit)
            .adhere(toSuperview: contentView)
        vipImgV.snp.makeConstraints {
            $0.top.right.equalToSuperview()
            $0.width.equalTo(56/2)
            $0.height.equalTo(37/2)
        }
        vipImgV.isHidden = true
        
    }
}
