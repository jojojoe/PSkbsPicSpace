//
//  PSkPhotoSlideVC.swift
//  PSkbsPicSpace
//
//  Created by JOJO on 2021/11/3.
//

import UIKit
import Photos


struct PhotoSlideItem {
    var slideType: SliderType = .slider1_3
    var iconName: String = ""
    var titleStr: String = ""
}

class PSkPhotoSlideVC: UIViewController {

    var originalImg: UIImage
    
    var slideItemList: [PhotoSlideItem] = []
    var currentSlideItem: PhotoSlideItem!
    
    let backBtn = UIButton(type: .custom)
    let bottomBar = UIView()
    var collection: UICollectionView!
    let canvasBgView = UIView()
    var viewDidLayoutSubviewsOnce: Once = Once()
    var slideView: PSkPhotoSlideView?
    
    init(originalImg: UIImage) {
        self.originalImg = originalImg
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupView()
        setupCollection()
        
        
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let Canvasheight: CGFloat = bottomBar.frame.minY - backBtn.frame.maxY
        let Canvaswidth: CGFloat = UIScreen.main.bounds.width
        let imgWH = self.originalImg.size.width / self.originalImg.size.height
        let canvasWH = Canvaswidth / Canvasheight
        var fineW: CGFloat = Canvaswidth
        var fineH: CGFloat = Canvaswidth
        
        if imgWH > canvasWH {
            fineW = Canvaswidth
            fineH = Canvaswidth / imgWH
        } else {
            fineH = Canvasheight
            fineW = Canvasheight * imgWH
        }
        let topOffset: CGFloat = (Canvasheight - fineH) / 2
        debugPrint("layout did")
        debugPrint("layout did fineW = \(fineW)")
        debugPrint("layout did fineH = \(fineH)")
        canvasBgView.snp.remakeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalTo(fineW)
            $0.bottom.equalTo(bottomBar.snp.top).offset(-topOffset)
            $0.top.equalTo(backBtn.snp.bottom).offset(topOffset)
        }
        
        //
        viewDidLayoutSubviewsOnce.run {
            DispatchQueue.main.async {
                let slideView = PSkPhotoSlideView(frame: CGRect(x: 0, y: 0, width: fineW, height: fineH), contentImage: self.originalImg)
                self.slideView = slideView
                slideView.adhere(toSuperview: self.canvasBgView)
                slideView.updateSliderStyle(sliderType: self.currentSlideItem.slideType)
                self.collection.selectItem(at: IndexPath(item: 2, section: 0), animated: false, scrollPosition: .centeredHorizontally)
                
            }
        }
    }
    
    func setupData() {
        let slideType1 = PhotoSlideItem(slideType: .slider1_3, iconName: "", titleStr: "1x3")
        let slideType2 = PhotoSlideItem(slideType: .slider2_3, iconName: "", titleStr: "2x3")
        let slideType3 = PhotoSlideItem(slideType: .slider3_3, iconName: "", titleStr: "3x3")
        let slideType4 = PhotoSlideItem(slideType: .slider3_2, iconName: "", titleStr: "3x2")
        let slideType5 = PhotoSlideItem(slideType: .slider3_1, iconName: "", titleStr: "3x1")
        slideItemList = [slideType1, slideType2, slideType3, slideType4, slideType5]
        currentSlideItem = slideType3
    }
    
    func setupView() {
        view.backgroundColor(.white)
        
        backBtn
            .backgroundColor(UIColor.lightGray)
            .image(UIImage(named: ""))
            .adhere(toSuperview: view)
        backBtn.addTarget(self, action: #selector(backBtnClick(sender: )), for: .touchUpInside)
        backBtn.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.left.equalTo(10)
            $0.width.height.equalTo(44)
        }
        //
        let saveBtn = UIButton(type: .custom)
        saveBtn
            .backgroundColor(UIColor(hexString: "#999999")!)
            .title("Save")
            .font(16, "AvenirNext-DemiBold")
            .titleColor(UIColor(hexString: "#111111")!)
            .adhere(toSuperview: view)
        saveBtn.layer.cornerRadius = 20
        saveBtn.addTarget(self, action: #selector(saveBtnClick(sender: )), for: .touchUpInside)
        saveBtn.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.right.equalTo(-10)
            $0.height.equalTo(40)
            $0.width.greaterThanOrEqualTo(96)
        }
        //
        bottomBar
            .backgroundColor(UIColor.clear)
            .adhere(toSuperview: view)
        bottomBar.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.height.equalTo(136)
        }
        
        //
        canvasBgView
            .backgroundColor(UIColor.lightGray)
            .adhere(toSuperview: view)
            .clipsToBounds()
        canvasBgView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.left.equalTo(15)
            $0.height.equalTo(UIScreen.main.bounds.width - 15 * 2)
            $0.centerY.equalTo(view.snp.centerY)
        }
        
    }
    
}

extension PSkPhotoSlideVC {
    func setupCollection() {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collection = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.backgroundColor = .clear
        collection.delegate = self
        collection.dataSource = self
        collection.adhere(toSuperview: bottomBar)
        collection.snp.makeConstraints {
            $0.top.bottom.right.left.equalToSuperview()
        }
        collection.register(cellWithClass: PSkSlideTypeCell.self)
    }
}

extension PSkPhotoSlideVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: PSkSlideTypeCell.self, for: indexPath)
        let item = slideItemList[indexPath.item]
        cell.udpateSlideType(slide: item)
        if item.slideType == currentSlideItem.slideType {
            cell.setupSelecStatus(isSele: true)
        } else {
            cell.setupSelecStatus(isSele: false)
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return slideItemList.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension PSkPhotoSlideVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let btnWidth: CGFloat = 100
        return CGSize(width: btnWidth, height: btnWidth)
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

extension PSkPhotoSlideVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = slideItemList[indexPath.item]
        currentSlideItem = item
        slideView?.updateSliderStyle(sliderType: item.slideType)
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}


extension PSkPhotoSlideVC {
 
    @objc func backBtnClick(sender: UIButton) {
        
        if self.navigationController != nil {
            self.navigationController?.popViewController()
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func saveBtnClick(sender: UIButton) {
        if let imgs = slideView?.processSlideImages(), let fullImg = slideView?.processFullImage() {
            showSavePopupView(images: imgs, fullImg: fullImg)
            
        }
        
    }
    
    func showSavePopupView(images: [UIImage], fullImg: UIImage) {
        let popupView = PSkPhotoSlideSavePopupView(frame: .zero, slideImgs: images, slideType: currentSlideItem.slideType)
        view.addSubview(popupView)
        popupView.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        popupView.backBtnClickBlock = {
            UIView.animate(withDuration: 0.25) {
                popupView.alpha = 0
            } completion: { finished in
                if finished {
                    popupView.removeFromSuperview()
                }
            }
        }
        popupView.okBtnClickBlock = {
            [weak self] in
            guard let `self` = self else {return}
            if popupView.fullBtnOpen.isOn == true {
                // save full
                self.saveImgsToAlbum(imgs: [fullImg])
            } else {
                self.saveImgsToAlbum(imgs: images)
            }
            
            
            UIView.animate(withDuration: 0.25) {
                popupView.alpha = 0
            } completion: { finished in
                if finished {
                    popupView.removeFromSuperview()
                }
            }
        }
    }
    
}


extension PSkPhotoSlideVC {
    func saveImgsToAlbum(imgs: [UIImage]) {
        HUD.hide()
        let status = PHPhotoLibrary.authorizationStatus()
        if status == .authorized {
            saveToAlbumPhotoAction(images: imgs)
        } else if status == .notDetermined {
            PHPhotoLibrary.requestAuthorization({[weak self] (status) in
                guard let `self` = self else {return}
                DispatchQueue.main.async {
                    if status != .authorized {
                        return
                    }
                    self.saveToAlbumPhotoAction(images: imgs)
                }
            })
        } else {
            // 权限提示
            albumPermissionsAlet()
        }
    }
    
    func saveToAlbumPhotoAction(images: [UIImage]) {
        DispatchQueue.main.async(execute: {
            PHPhotoLibrary.shared().performChanges({
                [weak self] in
                guard let `self` = self else {return}
                for img in images {
                    PHAssetChangeRequest.creationRequestForAsset(from: img)
                }
                DispatchQueue.main.async {
                    [weak self] in
                    guard let `self` = self else {return}
                    self.showSaveSuccessAlert()
                }
                
            }) { (finish, error) in
                if error != nil {
                    HUD.error("Sorry! please try again")
                }
            }
        })
    }
    
    func showSaveSuccessAlert() {
        
        DispatchQueue.main.async {
            let title = ""
            let message = "Photo saved successfully!"
            let okText = "OK"
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okButton = UIAlertAction(title: okText, style: .cancel, handler: { (alert) in
                 DispatchQueue.main.async {
                 }
            })
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    func albumPermissionsAlet() {
        let alert = UIAlertController(title: "Ooops!", message: "You have declined access to photos, please active it in Settings>Privacy>Photos.", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default) { [weak self] (actioin) in
            self?.openSystemAppSetting()
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
        }
        alert.addAction(okButton)
        alert.addAction(cancelButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    func openSystemAppSetting() {
        let url = NSURL.init(string: UIApplication.openSettingsURLString)
        let canOpen = UIApplication.shared.canOpenURL(url! as URL)
        if canOpen {
            UIApplication.shared.open(url! as URL, options: [:], completionHandler: nil)
        }
    }
 
}



class PSkSlideTypeCell: UICollectionViewCell {
    let iconImageV = UIImageView()
    let nameLabel = UILabel()
    
    var slideItem: PhotoSlideItem?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
        //
        nameLabel
            .textAlignment(.center)
            .fontName(16, "AvenirNext-Regular")
            .color(UIColor(hexString: "#999999")!)
            .adhere(toSuperview: contentView)
        nameLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-16)
            $0.width.height.greaterThanOrEqualTo(1)
        }
        //
        iconImageV
            .contentMode(.scaleAspectFit)
            .adhere(toSuperview: contentView)
        iconImageV.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(nameLabel.snp.top).offset(-6)
            $0.width.height.equalTo(37)
        }
        
    }
    
    func udpateSlideType(slide: PhotoSlideItem) {
        slideItem = slide
        iconImageV.image(slide.iconName)
        nameLabel.text(slide.titleStr)
    }
    func setupSelecStatus(isSele: Bool) {
        if isSele {
            contentView.backgroundColor(UIColor(hexString: "#11F151")!)
        } else {
            contentView.backgroundColor(UIColor(hexString: "#F7FAED")!)
        }
    }
    
}

