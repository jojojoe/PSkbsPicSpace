//
//  PSkProfileMakerVC.swift
//  PSkbsPicSpace
//
//  Created by JOJO on 2021/11/4.
//

import UIKit

class PSkProfileMakerVC: UIViewController {

    let backBtn = UIButton(type: .custom)
    
    let contentBgV = UIView()
    let canvasV = UIView()
    let frameBtn = PSkProfileMakerBottomBtn(frame: .zero, nameStr: "Frame")
    let bgBtn = PSkProfileMakerBottomBtn(frame: .zero, nameStr: "BgColor")
    let photoBtn = PSkProfileMakerBottomBtn(frame: .zero, nameStr: "Photo")
    
    
    var viewDidLayoutSubviewsOnce: Once = Once()
    
    var canvasTargetWH: CGFloat = 1 // 1 , 3/4 9/16 16/9
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()

        processRemoveImageBg()

        setupToolView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let canvasLeft: CGFloat = 20
        let canvasheight: CGFloat = contentBgV.frame.maxY - contentBgV.frame.minY
        let canvaswidth: CGFloat = (UIScreen.main.bounds.width - canvasLeft * 2)
        
        
        let canvasWH = canvaswidth / canvasheight
        var fineW: CGFloat = canvaswidth
        var fineH: CGFloat = canvaswidth
        
        if canvasTargetWH > canvasWH {
            fineW = canvaswidth
            fineH = canvaswidth / canvasTargetWH
        } else {
            fineH = canvasheight
            fineW = canvasheight * canvasTargetWH
        }
        let topOffset: CGFloat = (canvasheight - fineH) / 2
        
        canvasV.frame = CGRect(x: canvasLeft, y: topOffset, width: fineW, height: fineH)
         
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            [weak self] in
            guard let `self` = self else {return}
            self.viewDidLayoutSubviewsOnce.run({
                
            })
        }
        
>>>>>>> a2a5789489c02733a86769832b122d3b55ac7008
        

    }
    
   
    
    func setupView() {
        //
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
        
        
        contentBgV
        contentBgV.backgroundColor(.lightGray)
            .adhere(toSuperview: view)
        contentBgV.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(backBtn.snp.bottom).offset(5)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-100)
        }
        
        //
        
        canvasV
            .backgroundColor(.white)
            .adhere(toSuperview: contentBgV)
        canvasV.layer.shadowColor = UIColor.darkGray.withAlphaComponent(0.5).cgColor
        canvasV.layer.shadowOffset = CGSize(width: 0, height: 0)
        canvasV.layer.shadowRadius = 6
        canvasV.layer.shadowOpacity = 0.8
        
        //
        let bottomBarHeight: CGFloat = 90
        let bottomBar = UIView()
        bottomBar
            .backgroundColor(UIColor.lightGray)
            .adhere(toSuperview: view)
        bottomBar.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.height.equalTo(bottomBarHeight)
        }
        
        //
        let btnWidth: CGFloat = 90
        let btnHeight: CGFloat = 90
        let btnPadding: CGFloat = (UIScreen.main.bounds.width - btnWidth * 3) / 4
        
        frameBtn.adhere(toSuperview: bottomBar)
        bgBtn.adhere(toSuperview: bottomBar)
        photoBtn.adhere(toSuperview: bottomBar)
        
        frameBtn.snp.makeConstraints {
            $0.left.equalToSuperview().offset(btnPadding)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(btnWidth)
            $0.height.equalTo(btnHeight)
        }
        
        bgBtn.snp.makeConstraints {
            $0.left.equalTo(frameBtn.snp.right).offset(btnPadding)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(btnWidth)
            $0.height.equalTo(btnHeight)
        }
        
        photoBtn.snp.makeConstraints {
            $0.left.equalTo(bgBtn.snp.right).offset(btnPadding)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(btnWidth)
            $0.height.equalTo(btnHeight)
        }
        
        
        frameBtn.addTarget(self, action: #selector(frameBtnClick(sender: )), for: .touchUpInside)
        bgBtn.addTarget(self, action: #selector(bgBtnClick(sender: )), for: .touchUpInside)
        photoBtn.addTarget(self, action: #selector(photoBtnClick(sender: )), for: .touchUpInside)
        
        
    }

    func setupToolView() {
        
    }
     

}

extension PSkProfileMakerVC {

    func setupView() {
        view.backgroundColor(.white)
        //
        
    }

    @objc func backBtnClick(sender: UIButton) {
        
        if self.navigationController != nil {
            self.navigationController?.popViewController()
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func saveBtnClick(sender: UIButton) {
        
        
    }
    
    @objc func frameBtnClick(sender: UIButton) {
        
        
    }
    
    @objc func bgBtnClick(sender: UIButton) {
        
        
    }
    
    @objc func photoBtnClick(sender: UIButton) {
        
        
    }
    
    
    

}

extension PSkProfileMakerVC {
    func processRemoveImageBg() -> UIImage {
        
        let sourceImg = UIImage(named: "profile3.jpg")!
        
        
        if let img = sourceImg.segmentationDeepLabV3(), let cgImg = img.resize(size: sourceImg.size)?.cgImage {
            
            let filter = GraySegmentFilter()
            filter.inputImage = CIImage.init(cgImage: sourceImg.cgImage!)
            filter.maskImage = CIImage.init(cgImage: cgImg)
            let output = filter.value(forKey:kCIOutputImageKey) as! CIImage
            
            let ciContext = CIContext(options: nil)
            let cgImage = ciContext.createCGImage(output, from: output.extent)!
            let result = UIImage(cgImage: cgImage)
            
            return result
            
        } else {
            return sourceImg
        }
    }
}






class PSkProfileMakerBottomBtn: UIButton {
    var nameStr: String
    let nameLabel = UILabel()
    
    
    init(frame: CGRect, nameStr: String) {
        self.nameStr = nameStr
        super.init(frame: frame)
        setupView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {

        nameLabel
            .fontName(14, "AvenirNext-DemiBold")
            .color(UIColor(hexString: "#454C3D")!)
            .text(nameStr)
            .adjustsFontSizeToFitWidth()
            .adhere(toSuperview: self)
        nameLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-4)
            $0.width.height.greaterThanOrEqualTo(1)
        }
        
    }
    
    func isCurrentSelect(isSelect: Bool) {
        if isSelect == true {
            nameLabel
                .color(UIColor(hexString: "#454C3D")!)
            
        } else {
            nameLabel
                .color(UIColor(hexString: "#454C3D")!.withAlphaComponent(0.5))
            
        }
    }
    
}
