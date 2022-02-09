//
//  PSStoreVC.swift
//  PSkbsPicSpace
//
//  Created by JOJO on 2021/12/10.
//

import UIKit
import ZKProgressHUD
import DeviceKit
import ShimmerSwift

let yearPriceDefault: Double = 35.99
let monthPriceDefault: Double = 6.99
let weekPriceDefault: Double = 3.99
//
/*
 ¥22
 ¥46
 ￥384
 */


class PSStoreVC: UIViewController {

    var source = ""
    var purchase_page = "store_a"
    let backBtn = UIButton(type: .custom)
    
    
    let topTitleLabel = UILabel()
    let monthBtn = CUSubscribePriceBtn()
    let yearBtn = CUSubscribePriceBtn()
    let weekBtn = CUSubscribePriceBtn()
    
    var currentSubscribeType = SubscriptionType.year
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        
#if DEBUG
        PurchaseManager.share.test = true
        NotificationCenter.default.post(name: .PurchaseSubscrtionStateChange, object: nil)
#endif
    }
    
}

extension PSStoreVC {
    func setupView() {
        view.backgroundColor(UIColor(hexString: "#FFFFFF")!)
        view.clipsToBounds = true
        
        //
        let bgImgV = UIImageView()
        bgImgV
            .backgroundColor(UIColor.blue)
            .image("bg_vip")
            .contentMode(.scaleAspectFill)
            .adhere(toSuperview: view)
        bgImgV.snp.makeConstraints {
            $0.left.right.top.equalToSuperview()
            $0.height.equalTo(240)
        }
        //
        backBtn
            .image(UIImage(named: "btn_back_white"))
            .backgroundColor(UIColor.clear)
            .adhere(toSuperview: view)
        backBtn.snp.makeConstraints {
            $0.left.equalTo(10)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.width.height.equalTo(44)
        }
        backBtn.addTarget(self, action: #selector(backBtnClick(sender:)), for: .touchUpInside)
        //
        topTitleLabel
            .fontName(19, "SFProText-Semibold")
            .color(UIColor.white)
            .text("Member Centre".localized())
            .textAlignment(.center)
            .adhere(toSuperview: view)
        topTitleLabel
            .snp.makeConstraints {
                $0.centerY.equalTo(backBtn)
                $0.centerX.equalToSuperview()
                $0.width.height.greaterThanOrEqualTo(1)
            }
        //
        
        //
        let topTitleImgV = UIImageView()
        topTitleImgV
            .contentMode(.scaleAspectFit)
            .image("bg_vip_card")
            .adhere(toSuperview: view)
        
        //
        let bottomBgView = UIView()
        bottomBgView.layer.cornerRadius = 10
        bottomBgView
            .backgroundColor(UIColor.white)
            .adhere(toSuperview: view)
        bottomBgView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(backBtn.snp.bottom).offset(138)
        }
        
        //
        
        topTitleImgV.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(bottomBgView.snp.top).offset(10)
            $0.width.equalTo(702 / 2)
            $0.height.equalTo(260 / 2)
            
        }
        let titleLabel1 = UILabel()
        titleLabel1
            .fontName(24, "SFProText-Bold")
            .text("Photo Cleaner".localized())
            .color(UIColor(hexString: "#F6C398")!)
            .adhere(toSuperview: view)
        titleLabel1.snp.makeConstraints {
            $0.left.equalTo(topTitleImgV.snp.left).offset(25)
            $0.top.equalTo(topTitleImgV.snp.top).offset(27)
            $0.width.height.greaterThanOrEqualTo(1)
        }
        //
        let titleLabel2 = UILabel()
        titleLabel2
            .fontName(14, "SFProText-Medium")
            .text("Unlock Unlimited Access".localized())
            .color(UIColor(hexString: "#F6C398")!)
            .adhere(toSuperview: view)
        titleLabel2.snp.makeConstraints {
            $0.left.equalTo(titleLabel1.snp.left)
            $0.top.equalTo(titleLabel1.snp.bottom).offset(11)
            $0.width.height.greaterThanOrEqualTo(1)
        }
        //
        let vipLabel = UILabel()
        vipLabel
            .fontName(16, "SFProText-Bold")
            .text("Member's Privilege".localized())
            .color(UIColor.black)
            .adhere(toSuperview: bottomBgView)
        vipLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(bottomBgView.snp.top).offset(40)
            $0.width.height.greaterThanOrEqualTo(1)
        }
        if Device.current.diagonal == 4.7 || Device.current.diagonal >= 6.9 {
            vipLabel.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.top.equalTo(bottomBgView.snp.top).offset(20)
                $0.width.height.greaterThanOrEqualTo(1)
            }
        }
        let vipLeftV = UIView()
        vipLeftV
            .backgroundColor(UIColor(hexString: "#D9D9D9")!)
            .adhere(toSuperview: bottomBgView)
        vipLeftV.snp.makeConstraints {
            $0.centerY.equalTo(vipLabel)
            $0.right.equalTo(vipLabel.snp.left).offset(-20)
            $0.width.equalTo(37)
            $0.height.equalTo(0.5)
        }
        let vipRightV = UIView()
        vipRightV
            .backgroundColor(UIColor(hexString: "#D9D9D9")!)
            .adhere(toSuperview: bottomBgView)
        vipRightV.snp.makeConstraints {
            $0.centerY.equalTo(vipLabel)
            $0.left.equalTo(vipLabel.snp.right).offset(20)
            $0.width.equalTo(37)
            $0.height.equalTo(0.5)
        }
        
        //
        let infolabel1 = CUsubscribeInfoView(frame: .zero, iconStr: "ic_vip_smart_cleaning", nameStr: "Smart cleaning".localized())
        infolabel1.adhere(toSuperview: bottomBgView)
        let infolabel2 = CUsubscribeInfoView(frame: .zero, iconStr: "ic_vip_photo_video_cleaning", nameStr: "Photo and video cleaning".localized())
        infolabel2.adhere(toSuperview: bottomBgView)
        let infolabel3 = CUsubscribeInfoView(frame: .zero, iconStr: "ic_vip_cleanup_plan", nameStr: "Cleanup plan".localized())
        infolabel3.adhere(toSuperview: bottomBgView)
        
        infolabel2.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(vipLabel.snp.bottom).offset(34)
            $0.width.equalTo(110)
            $0.height.equalTo(93)
        }
        if Device.current.diagonal == 4.7 || Device.current.diagonal >= 6.9 {
            infolabel2.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.top.equalTo(vipLabel.snp.bottom).offset(14)
                $0.width.equalTo(110)
                $0.height.equalTo(93)
            }
        }
        infolabel1.snp.makeConstraints {
            $0.right.equalTo(infolabel2.snp.left).offset(-10)
            $0.top.equalTo(infolabel2)
            $0.width.equalTo(110)
            $0.height.equalTo(93)
        }
        infolabel3.snp.makeConstraints {
            $0.left.equalTo(infolabel2.snp.right).offset(10)
            $0.top.equalTo(infolabel2)
            $0.width.equalTo(110)
            $0.height.equalTo(93)
        }
        
        //
        let bottomPriceBgView = UIView()
        bottomPriceBgView
            .backgroundColor(UIColor.white)
            .adhere(toSuperview: view)
        bottomPriceBgView.snp.makeConstraints {
            $0.top.equalTo(infolabel1.snp.bottom)
            $0.left.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.width.equalTo(1)
        }
        
        let termBtn = UIButton(type: .custom)
        let privacyBtn = UIButton(type: .custom)
        termBtn
            .title("Terms of Use".localized())
            .titleColor(UIColor(hexString: "#C4C4C4")!)
            .font(12, "SFProText-Medium")
            .adhere(toSuperview: view)
        termBtn.snp.makeConstraints {
            $0.bottom.equalTo(bottomPriceBgView.snp.bottom).offset(-10)
            $0.centerX.equalTo(view.snp.centerX)
            $0.width.greaterThanOrEqualTo(1)
            $0.height.equalTo(15)
        }
        termBtn.addTarget(self, action: #selector(termBtnClick(sender:)), for: .touchUpInside)
        //
        privacyBtn
            .title("Privacy Policy".localized())
            .titleColor(UIColor(hexString: "#C4C4C4")!)
            .font(12, "SFProText-Medium")
            .adhere(toSuperview: view)
        privacyBtn.snp.makeConstraints {
            $0.bottom.equalTo(bottomPriceBgView.snp.bottom).offset(-10)
            $0.left.equalTo(termBtn.snp.right).offset(5)
            $0.width.greaterThanOrEqualTo(1)
            $0.height.equalTo(15)
        }
        privacyBtn.addTarget(self, action: #selector(privacyBtnClick(sender:)), for: .touchUpInside)
        //
        let termcenterLine = UIView()
        termcenterLine.backgroundColor(UIColor(hexString: "#C4C4C4")!)
            .adhere(toSuperview: view)
        termcenterLine.snp.makeConstraints {
            $0.left.equalTo(termBtn.snp.right).offset(2)
            $0.centerY.equalTo(privacyBtn)
            $0.width.equalTo(1)
            $0.height.equalTo(13)
        }
        //
        let restoreBtn = UIButton(type: .custom)
        restoreBtn
            .title("Restore Purchase".localized())
            .titleColor(UIColor(hexString: "#C4C4C4")!)
            .font(12, "SFProText-Medium")
            .adhere(toSuperview: view)
        restoreBtn.snp.makeConstraints {
            $0.bottom.equalTo(bottomPriceBgView.snp.bottom).offset(-10)
            $0.right.equalTo(termBtn.snp.left).offset(-5)
            $0.width.greaterThanOrEqualTo(1)
            $0.height.equalTo(15)
        }
        restoreBtn.addTarget(self, action: #selector(restoreButtonClick(button:)), for: .touchUpInside)
        //
        let restoreCenterLine = UIView()
        restoreCenterLine.backgroundColor(UIColor(hexString: "#C4C4C4")!)
            .adhere(toSuperview: view)
        restoreCenterLine.snp.makeConstraints {
            $0.right.equalTo(termBtn.snp.left).offset(-2)
            $0.centerY.equalTo(privacyBtn)
            $0.width.equalTo(1)
            $0.height.equalTo(13)
        }
        //
        
        let shimmerView = ShimmeringView()
        self.view.addSubview(shimmerView)
        shimmerView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(bottomPriceBgView.snp.centerY).offset(30)
            $0.width.equalTo(305)
            $0.height.equalTo(60)
        }
        
        //
        let startSubscribeBtn = UIButton(type: .custom)
        startSubscribeBtn.backgroundColor(UIColor(hexString: "#CFA765")!)
            .title("Subscribe Now".localized())
            .font(18, "SFProText-Semibold")
            .titleColor(UIColor.white)
            .adhere(toSuperview: shimmerView)
        shimmerView.contentView = startSubscribeBtn
        startSubscribeBtn.layer.cornerRadius = 30
        startSubscribeBtn.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(bottomPriceBgView.snp.centerY).offset(30)
            $0.width.equalTo(305)
            $0.height.equalTo(60)
        }
        startSubscribeBtn.addTarget(self, action: #selector(startSubscribeBtnClick(sender:)), for: .touchUpInside)
        
        //
        // Start shimmering
        shimmerView.isShimmering = true
        
        //
        monthBtn.updateSelectStatus(isSele: false)
        monthBtn
            .adhere(toSuperview: view)
        
        if Device.current.diagonal == 4.7 || Device.current.diagonal >= 6.9 {
            monthBtn.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.bottom.equalTo(startSubscribeBtn.snp.top).offset(-40)
                $0.width.equalTo(100)
                $0.height.equalTo(122)
            }
        } else {
            monthBtn.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.bottom.equalTo(startSubscribeBtn.snp.top).offset(-55)
                $0.width.equalTo(100)
                $0.height.equalTo(122)
            }
        }
        monthBtn.addTarget(self, action: #selector(monthBtnClick(sender:)), for: .touchUpInside)
        //

        yearBtn.updateSelectStatus(isSele: true)
        yearBtn
            .adhere(toSuperview: view)
        yearBtn.snp.makeConstraints {
            $0.right.equalTo(monthBtn.snp.left).offset(-14)
            $0.centerY.equalTo(monthBtn.snp.centerY)
            $0.width.equalTo(100)
            $0.height.equalTo(122)
        }
        yearBtn.addTarget(self, action: #selector(yearBtnClick(sender:)), for: .touchUpInside)
        
        //
        
        weekBtn.updateSelectStatus(isSele: false)
        weekBtn
            .adhere(toSuperview: view)
        weekBtn.snp.makeConstraints {
            $0.left.equalTo(monthBtn.snp.right).offset(14)
            $0.centerY.equalTo(monthBtn.snp.centerY)
            $0.width.equalTo(100)
            $0.height.equalTo(122)
        }
        weekBtn.addTarget(self, action: #selector(weekBtnClick(sender:)), for: .touchUpInside)
        
        //
        let free3DayView = UIImageView()
        free3DayView
            .image("ic_vip_oneyear")
            .adhere(toSuperview: view)
        free3DayView.snp.makeConstraints {
            $0.centerX.equalTo(yearBtn.snp.centerX)
            $0.centerY.equalTo(yearBtn.snp.top)
            $0.width.equalTo(172/2)
            $0.height.equalTo(48/2)
        }
        let free3DayLabel = UILabel()
        free3DayLabel
            .fontName(13, "SFProText-Medium")
            .textAlignment(.center)
            .text("3-day Free Trial".localized())
            .color(UIColor.white)
            .adjustsFontSizeToFitWidth()
            .adhere(toSuperview: free3DayView)
        free3DayLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.left.equalTo(9)
            $0.top.equalToSuperview()
        }
        //
        prepareData()
        
    }
    
    
    func prepareData() {
        weekBtn.timeLabel.text = "XX Week".localized().replacingOccurrences(of: "XX", with: "1")
        monthBtn.timeLabel.text = "XX Month".localized().replacingOccurrences(of: "XX", with: "1")
        yearBtn.timeLabel.text = "XX Year".localized().replacingOccurrences(of: "XX", with: "1")
        
        
        if let cacheIapMonthInfo = UserDefaults.standard.value(forKey: cacheIapInfoMonthKey) as? [String: Any] {
            let localizedPrice = cacheIapMonthInfo["localizedPrice"] as? String ?? ""
            let symbol = cacheIapMonthInfo["currencySymbol"] as? String ?? ""
            let price = cacheIapMonthInfo["price"] as? Double ?? 0
            self.monthBtn.priceLabel.text = "\(localizedPrice)"
            self.monthBtn.weekPriceLabel.text = "\("XX per week".localized().replacingOccurrences(of: "XX", with: "\(String(format: "%@%.2f", symbol,price/4))"))"
        } else {
            monthBtn.priceLabel.text = "$\(monthPriceDefault)"
            let monthPerWeekPrice: String = String(format: "%.2f", monthPriceDefault/4)
            monthBtn.weekPriceLabel.text = "\("XX per week".localized().replacingOccurrences(of: "XX", with: "\("$\(monthPerWeekPrice)")"))"
        }
        if let cacheIapWeekInfo = UserDefaults.standard.value(forKey: cacheIapInfoWeekKey) as? [String: Any] {
            let localizedPrice = cacheIapWeekInfo["localizedPrice"] as? String ?? ""
            let symbol = cacheIapWeekInfo["currencySymbol"] as? String ?? ""
            let price = cacheIapWeekInfo["price"] as? Double ?? 0
            
            self.weekBtn.priceLabel.text = "\(localizedPrice)"
            self.weekBtn.weekPriceLabel.text = "\("XX per week".localized().replacingOccurrences(of: "XX", with: "\(String(format: "%@%.2f", symbol,price))"))"
        } else {
            weekBtn.priceLabel.text = "$\(weekPriceDefault)"
            weekBtn.weekPriceLabel.text = "\("XX per week".localized().replacingOccurrences(of: "XX", with: "\("$\(weekPriceDefault)")"))"
        }
        if let cacheIapYearInfo = UserDefaults.standard.value(forKey: cacheIapInfoYearKey) as? [String: Any] {
            let localizedPrice = cacheIapYearInfo["localizedPrice"] as? String ?? ""
            let symbol = cacheIapYearInfo["currencySymbol"] as? String ?? ""
            let price = cacheIapYearInfo["price"] as? Double ?? 0
            
            self.yearBtn.priceLabel.text = "\(localizedPrice)"
            self.yearBtn.weekPriceLabel.text = "\("XX per week".localized().replacingOccurrences(of: "XX", with: "\(String(format: "%@%.2f", symbol,price/52))"))"
        } else {
            yearBtn.priceLabel.text = "$\(yearPriceDefault)"
            let yearPerWeekPrice: String = String(format: "%.2f", yearPriceDefault/52)
            yearBtn.weekPriceLabel.text = "\("XX per week".localized().replacingOccurrences(of: "XX", with: "\("$\(yearPerWeekPrice)")"))"
        }
        
        getSubscriptionData {[weak self] models in
            guard let `self` = self else {return}
            //
            let week = models.filter{$0.iapType == .week}.first
            if let week = week {
                self.weekBtn.priceLabel.text = "\(week.localizedPrice)"
                self.weekBtn.weekPriceLabel.text = "\("XX per week".localized().replacingOccurrences(of: "XX", with: "\(String(format: "%@%.2f", week.currencySymbol,week.price))"))"
                
                
            }
            //
            let year = models.filter{$0.iapType == .year}.first
            if let year = year {
                self.yearBtn.priceLabel.text = "\(year.localizedPrice)"
                self.yearBtn.weekPriceLabel.text = "\("XX per week".localized().replacingOccurrences(of: "XX", with: "\(String(format: "%@%.2f", year.currencySymbol,year.price/52))"))"
            }
            //
            let month = models.filter{$0.iapType == .month}.first
            if let month = month {
                self.monthBtn.priceLabel.text = "\(month.localizedPrice)"
                self.monthBtn.weekPriceLabel.text = "\("XX per week".localized().replacingOccurrences(of: "XX", with: "\(String(format: "%@%.2f", month.currencySymbol,month.price/4))"))"
            }
        }
    }
    
    @objc func monthBtnClick(sender: UIButton) {
        currentSubscribeType = .month
        monthBtn.updateSelectStatus(isSele: true)
        yearBtn.updateSelectStatus(isSele: false)
        weekBtn.updateSelectStatus(isSele: false)
    }
    
    @objc func yearBtnClick(sender: UIButton) {
        currentSubscribeType = .year
        yearBtn.updateSelectStatus(isSele: true)
        monthBtn.updateSelectStatus(isSele: false)
        weekBtn.updateSelectStatus(isSele: false)
    }
    
    @objc func weekBtnClick(sender: UIButton) {
        currentSubscribeType = .week
        weekBtn.updateSelectStatus(isSele: true)
        monthBtn.updateSelectStatus(isSele: false)
        yearBtn.updateSelectStatus(isSele: false)
    }
    
    @objc func privacyBtnClick(sender: UIButton) {
        let url = URL(string: ppUrl)
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
    @objc func termBtnClick(sender: UIButton) {
        let url = URL(string: touUrl)
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
}

extension PSStoreVC {
    @objc func backBtnClick(sender: UIButton) {
        //TODO: 是否取消扫描
        if self.navigationController != nil {
            self.navigationController?.popViewController()
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func startSubscribeBtnClick(sender: UIButton) {
        //
//        buySubscription(type: currentSubscribeType, source: self.source, page: self.purchase_page) {
//            //
//            [weak self] in
//            guard let `self` = self else {return}
//            DispatchQueue.main.async {
//                self.backBtnClick(sender: self.backBtn)
//                NotificationCenter.default.post(name: .buy, object: nil)
//            }
//
//        }
    }
    
    @objc func restoreButtonClick(button: UIButton) {
        PurchaseManager.share.restore {
            ZKProgressHUD.showSuccess()
            NotificationCenter.default.post(name: .buy, object: nil)
            NotificationCenter.default.post(name: .PurchaseSubscrtionStateChange, object: nil)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
}



class CUsubscribeInfoView: UIView {
    
    let iconImgV = UIImageView()
    let nameLabel = UILabel()
    var iconStr: String
    var nameStr: String
    
    init(frame: CGRect, iconStr: String, nameStr: String) {
        self.iconStr = iconStr
        self.nameStr = nameStr
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // 63
    func setupView() {
        clipsToBounds = false
        
        //
        iconImgV
            .image(iconStr)
            .contentMode(.scaleAspectFit)
            .adhere(toSuperview: self)
        iconImgV.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview()
            $0.width.height.equalTo(84/2)
        }
        //
        nameLabel
            .fontName(16, "SFProText-Medium")
            .numberOfLines(3)
            .color(UIColor(hexString: "#4A4948")!)
            .textAlignment(.center)
            .adjustsFontSizeToFitWidth()
            .text(nameStr)
            .adhere(toSuperview: self)
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(iconImgV.snp.bottom).offset(10)
            $0.bottom.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.height.greaterThanOrEqualTo(1)
            $0.width.equalToSuperview()
        }
        
        
    }
    
    
    
}



class CUSubscribePriceBtn: UIButton {
    let timeLabel = UILabel()
    let priceLabel = UILabel()
    let weekPriceLabel = UILabel()
    var isSele: Bool = false
    
    func updateSelectStatus(isSele: Bool) {
        self.isSele = isSele
        if isSele {
            self.layer.borderWidth = 2
            self.layer.borderColor = UIColor(hexString: "#CFA765")?.cgColor
            self
                .backgroundColor(UIColor(hexString: "#FBF7F2")!)
            
        } else {
            self.layer.borderWidth = 0.5
            self.layer.borderColor = UIColor(hexString: "#F9FAFB")?.cgColor
            self
                .backgroundColor(UIColor(hexString: "#F9FAFB")!)
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        self.layer.cornerRadius = 8
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor(hexString: "#F9FAFB")?.cgColor
        self
            .backgroundColor(UIColor(hexString: "#F9FAFB")!)
        
        //
        priceLabel
            .fontName(22, "DINAlternate-Bold")
            .color(UIColor(hexString: "#FC685C")!)
            .textAlignment(.center)
            .adhere(toSuperview: self)
        priceLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.height.greaterThanOrEqualTo(1)
        }
        
        //
        timeLabel
            .fontName(18, "SFProText-Semibold")
            .color(UIColor.black)
            .textAlignment(.center)
            .adhere(toSuperview: self)
        timeLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.height.greaterThanOrEqualTo(1)
            $0.bottom.equalTo(priceLabel.snp.top).offset(-4)
        }
        //
        let weekPriceBgView = UIView()
        weekPriceBgView
            .backgroundColor(UIColor.white)
            .adhere(toSuperview: self)
        //
        weekPriceLabel
            .fontName(14, "DINAlternate-Bold")
            .color(UIColor(hexString: "#CFA765")!)
            .textAlignment(.center)
            .adjustsFontSizeToFitWidth()
            .adhere(toSuperview: self)
        weekPriceLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.left.equalTo(16)
            $0.height.greaterThanOrEqualTo(1)
            $0.top.equalTo(priceLabel.snp.bottom).offset(10)
        }
        //
        weekPriceBgView.snp.makeConstraints {
            $0.center.equalTo(weekPriceLabel)
            $0.left.equalTo(weekPriceLabel.snp.left).offset(-8)
            $0.height.equalTo(24)
        }
        weekPriceBgView.layer.cornerRadius = 12
        weekPriceBgView.layer.borderColor = UIColor(hexString: "#FFDEA8")?.cgColor
        weekPriceBgView.layer.borderWidth = 0.5
        
        
        
    }
     
}


extension PSStoreVC: SubscriptionBaseProtocol {}
