//
//  PSkVipAlertView.swift
//  PSkbsPicSpace
//
//  Created by Joe on 2022/1/20.
//

import UIKit
import SwiftyStoreKit

class PSkVipAlertView: UIView, SubscriptionBaseProtocol {

    var backBtnClickBlock: (()->Void)?
    var subscribeSuccessBlock: ((PurchaseDetails?)->Void)?
    
 
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupView() {
        backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
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
        
        let vipBtn = PSSettingVipCard()
        vipBtn
            .adhere(toSuperview: self)
        vipBtn.addTarget(self, action: #selector(vipBtnClick(sender:)), for: .touchUpInside)
        vipBtn.snp.makeConstraints {
            $0.left.equalTo(20)
            
            $0.center.equalToSuperview()
             
            $0.height.equalTo((364/634) * (UIScreen.width - 20 * 2))
        }
        
        
        
    }
    
   
    
    @objc func backBtnClick(sender: UIButton) {
        backBtnClickBlock?()
    }
    
    @objc func vipBtnClick(sender: UIButton) {
        startSubscribeBtnClick()
    }
    
    func startSubscribeBtnClick() {
        //
        let currentSubscribeType: SubscriptionType = .month
        buySubscription(type: currentSubscribeType, source: "", page: "") {
            //
            [weak self] purchseDetail in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                self.subscribeSuccessBlock?(purchseDetail)
                NotificationCenter.default.post(name: .buy, object: nil)
                NotificationCenter.default.post(name: .PurchaseSubscrtionStateChange, object: nil)
            }

        }
    }

}
