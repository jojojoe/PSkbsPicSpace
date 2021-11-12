//
//  PSkProfileFrameToolView.swift
//  PSkbsPicSpace
//
//  Created by JOJO on 2021/11/11.
//

import UIKit


struct PSkProfileFrameItem {
    var pixWidth: CGFloat
    var pixHeight: CGFloat
    var iconImgStr: String
    var titleStr: String
    
}



class PSkProfileFrameToolView: UIView {

    var backBtnClickBlock: (()->Void)?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadData()
        setupView()
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    func loadData() {
        
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
        let contentV = UIView()
            .backgroundColor(UIColor.black.withAlphaComponent(1))
            .adhere(toSuperview: self)
        contentV.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-330)
        }
        //
        let backBtn = UIButton(type: .custom)
        backBtn
            .image("")
            .backgroundColor(.darkGray)
            .adhere(toSuperview: contentV)
        backBtn.addTarget(self, action: #selector(backBtnClick(sender:)), for: .touchUpInside)
        backBtn.snp.makeConstraints {
            $0.top.equalTo(contentV.snp.top).offset(0)
            $0.right.equalTo(contentV.snp.right).offset(0)
            $0.left.equalTo(contentV.snp.left).offset(0)
            $0.height.equalTo(35)
        }
        
        //
        let frameTypeList: [] = []
        
        
        let pointPixLabel = UILabel()
        pointPixLabel
            .text("分辨率/尺寸")
            .color(UIColor.orange)
            .textAlignment(.left)
            .fontName(15, "AvenirNext-Regular")
            .adhere(toSuperview: contentV)
        pointPixLabel.snp.makeConstraints {
            $0.left.equalTo(contentV.snp.left).offset(30)
        }
        
    }
    
}

extension PSkProfileFrameToolView {
    @objc func backBtnClick(sender: UIButton) {
        backBtnClickBlock?()
    }
}






