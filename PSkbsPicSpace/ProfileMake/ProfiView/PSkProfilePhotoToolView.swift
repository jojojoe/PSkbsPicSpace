//
//  PSkProfilePhotoToolView.swift
//  PSkbsPicSpace
//
//  Created by JOJO on 2021/11/11.
//

import UIKit

class ProfilePhotoItem {
    var bgColor: UIColor?
    var originImg: UIImage?
    var smartImg: UIImage?
    var isSkinBeauty: Bool?
    var isSmartBg: Bool?
    var isMirror: Bool?
    // delete
    // layer up
    // layer down
}

class PSkProfilePhotoToolView: UIView {

    var backBtnClickBlock: (()->Void)?
    let contentV = UIView()
    var collection: UICollectionView!
    
    var currentLayerList: [ProfilePhotoItem] = []
    
    // 扣除背景 镜像 磨皮
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setupDefault()
        
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
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
            $0.bottom.equalToSuperview()
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-380)
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
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.backgroundColor = .clear
        collection.delegate = self
        collection.dataSource = self
        contentV.addSubview(collection)
        collection.snp.makeConstraints {
            $0.top.bottom.right.left.equalToSuperview()
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
        
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension PSkProfilePhotoToolView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 10, height: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

extension PSkProfilePhotoToolView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}





class PSkProfilePhotoToolCell: UICollectionViewCell {
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

