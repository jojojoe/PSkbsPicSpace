//
//  PSPopupStoreView.swift
//  PSkbsPicSpace
//
//  Created by Joe on 2022/11/5.
//

import UIKit
import ZKProgressHUD


class PSPopupStoreView: UIView, SubscriptionBaseProtocol {

    let vipBtn = PSSettingVipCard()
    var cancelBlock: (()->Void)?
    var buySuccessBlock: (()->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupContent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupContent() {
        backgroundColor = UIColor.white.withAlphaComponent(0)
        
        //
        let blurEffect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(blurView)
        blurView.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        
        let backBtn = UIButton()
        addSubview(backBtn)
        backBtn.backgroundColor(.white)
        backBtn.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(5)
            $0.left.equalToSuperview().offset(20)
            $0.width.height.equalTo(44)
        }
        backBtn.setImage(UIImage(named: "i_all_close"), for: .normal)
        backBtn.addTarget(self, action: #selector(backBtnClick(sender: )), for: .touchUpInside)
        backBtn.layer.cornerRadius = 8
        //
        vipBtn
            .adhere(toSuperview: self)
        vipBtn.addTarget(self, action: #selector(vipBtnClick(sender:)), for: .touchUpInside)
        vipBtn.snp.makeConstraints {
            $0.left.equalTo(20)
            $0.centerY.equalToSuperview().offset(-50)
            $0.centerX.equalToSuperview()
            $0.height.equalTo((364/634) * (UIScreen.width - 20 * 2))
        }
        
        
    }
    
    @objc func backBtnClick(sender: UIButton) {
        cancelBlock?()
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
            ZKProgressHUD.showSuccess("Subscription successful!".localized(), maskStyle: nil, onlyOnceFont: nil, autoDismissDelay: 1.5, completion: nil)
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .buy, object: nil)
                NotificationCenter.default.post(name: .PurchaseSubscrtionStateChange, object: nil)
                self.buySuccessBlock?()
            }

        }
    }

}
