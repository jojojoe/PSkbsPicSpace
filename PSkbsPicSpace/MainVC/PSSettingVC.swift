//
//  PSSettingVC.swift
//  PSkbsPicSpace
//
//  Created by JOJO on 2021/12/10.
//

import UIKit
import MessageUI
import ZKProgressHUD

let APP_Id = "1607282610"
let infoForDictionary = Bundle.main.infoDictionary
func feefbackInfo(appName:String,appVersion:String,deviceModel:String,systemVersion:String,deviceName:String) -> String {
    return "<br /><br /><br /><br /><font color=\"#9F9F9F\" style=\"font-size: 13px;\"> <i>(\(appName) \(appVersion) on iPhone running with iOS \(systemVersion), device \(deviceName)</i>)</font>"
}
let feedbackDeviceInfoFormat = "<br /><br /><br /><br /><font color=\"#9F9F9F\" style=\"font-size: 13px;\"> <i>(%@ %@ on %@ running with iOS %@, device %@</i>)</font>"
let CurrentAppVersion = infoForDictionary?["CFBundleShortVersionString"] as? String
var AppName = infoForDictionary?["CFBundleDisplayName"] as? String ?? ""
var DeviceName = UIDevice.current.systemName

let emailAddress = "zx804463232@163.com"
//let ppUrl = "https://pages.flycricket.io/picpli/privacy.html"
//let touUrl = "https://pages.flycricket.io/picpli/terms.html"

let ppUrl = "https://www.app-privacy-policy.com/live.php?token=jwAReDY4Y4nfoPnGs37282qWS0V37gAs"
let touUrl = "https://www.app-privacy-policy.com/live.php?token=AqVmDkXgSdwJLa17ScmYEQ9bDwp2bl17"

//
//


let purhcasepUrl = "PurchaseNotice"
//let appStoreUrl = "https://itunes.apple.com/app/id1583687807?mt=8#"
let ppUrl_cn = "https://www.app-privacy-policy.com/live.php?token=jwAReDY4Y4nfoPnGs37282qWS0V37gAs"
let touUrl_cn = "https://www.app-privacy-policy.com/live.php?token=AqVmDkXgSdwJLa17ScmYEQ9bDwp2bl17"
let purhcasepUrl_cn = "PurchaseNotice"
class PSSettingVC: UIViewController, MFMailComposeViewControllerDelegate, SubscriptionBaseProtocol, UINavigationControllerDelegate {

    let backBtn = UIButton(type: .custom)
    let topTitleLabel = UILabel()
    let vipBtn = PSSettingVipCard()
    let termsBtn = CUSettingToolBtn(frame: .zero, iconImgName: "ic_setting_terms_of_useicon", nameStr: "Terms of Use".localized())
    let rateBtn = CUSettingToolBtn(frame: .zero, iconImgName: "ic_setting_rate_usicon", nameStr: "Rate Us".localized())
    let privacyBtn = CUSettingToolBtn(frame: .zero, iconImgName: "ic_setting_privacy_policyicon", nameStr: "Privacy Policy".localized())
    let feedbackBtn = CUSettingToolBtn(frame: .zero, iconImgName: "feedback_ic", nameStr: "Feedback".localized())
    let restoreBtn = CUSettingToolBtn(frame: .zero, iconImgName: "restore_ic", nameStr: "Restore Purchase".localized())
    let purchaseLinkBtn = CUSettingToolBtn(frame: .zero, iconImgName: "restore_ic", nameStr: "Purchase Notice".localized())
    let bottomBgView = UIView()
    
    
    
    //
    
    let contentBgScrollV = UIScrollView()
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupToolBtns()
        addNoti()
    }
    
    func addNoti() {
        NotificationCenter.default.addObserver(self, selector: #selector(purchaseResultRefresh), name: Notification.Name.PurchaseSubscrtionStateChange , object: nil)
        
//        NotificationCenter.default.addObserver(self, selector: #selector(purchaseResultRefresh), name: Notification.Name.buy , object: nil)
        
            
    }
    
    func setupView() {
        view.backgroundColor(UIColor(hexString: "#F4F4F4")!)
        view.clipsToBounds = true
        //
        backBtn
            .image(UIImage(named: "i_back"))
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
            .fontName(17, "Montserrat-Bold")
            .color(UIColor.black)
            .text("Setting".localized())
            .textAlignment(.center)
            .adhere(toSuperview: view)
        topTitleLabel
            .snp.makeConstraints {
                $0.centerY.equalTo(backBtn)
                $0.centerX.equalToSuperview()
                $0.width.height.greaterThanOrEqualTo(1)
            }
    }
    
    @objc func purchaseResultRefresh() {
        if PurchaseManager.share.inSubscription {
            vipBtn.isHidden = true
            bottomBgView.snp.remakeConstraints {
                $0.left.equalTo(20)
                $0.top.equalTo(vipBtn.snp.top)
                $0.centerX.equalToSuperview()
                $0.height.equalTo(430)
            }
            contentBgScrollV.contentSize = CGSize(width: UIScreen.width, height: 430 + 60)
        } else {
            vipBtn.isHidden = false
            bottomBgView.snp.remakeConstraints {
                $0.left.equalTo(20)
                $0.top.equalTo(vipBtn.snp.bottom).offset(15)
                $0.centerX.equalToSuperview()
                $0.height.equalTo(430)
            }
            contentBgScrollV.contentSize = CGSize(width: UIScreen.width , height: (180/320) * UIScreen.width + 430 + 60)
        }
        self.view.layoutIfNeeded()
    }

    func setupToolBtns() {
        
        //
        
        contentBgScrollV.backgroundColor(.clear)
            .adhere(toSuperview: view)
        contentBgScrollV.snp.makeConstraints {
            $0.left.equalToSuperview().offset(0)
            $0.right.equalToSuperview().offset(0)
            $0.top.equalTo(backBtn.snp.bottom)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        contentBgScrollV.contentSize = CGSize(width: UIScreen.width, height: (180/320) * UIScreen.width + 430 + 60)
        
        //
        vipBtn
            .adhere(toSuperview: contentBgScrollV)
        vipBtn.addTarget(self, action: #selector(vipBtnClick(sender:)), for: .touchUpInside)
        vipBtn.snp.makeConstraints {
            $0.left.equalTo(20)
            $0.top.equalTo(contentBgScrollV.snp.top).offset(15)
            $0.centerX.equalToSuperview()
             
            $0.height.equalTo((364/634) * (UIScreen.width - 20 * 2))
        }
        
        //
        
        bottomBgView.layer.cornerRadius = 15
        bottomBgView
            .backgroundColor(UIColor.white)
            .adhere(toSuperview: contentBgScrollV)
        bottomBgView.snp.makeConstraints {
            $0.left.equalTo(20)
            $0.top.equalTo(vipBtn.snp.bottom).offset(15)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(430)
        }
        bottomBgView.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        bottomBgView.layer.shadowOffset = CGSize(width: 0, height: 2)
        bottomBgView.layer.shadowOpacity = 0.5
        bottomBgView.layer.shadowRadius = 8
        //
        
        termsBtn.adhere(toSuperview: bottomBgView)
        termsBtn.addTarget(self, action: #selector(termsBtnClick(sender:)), for: .touchUpInside)
        termsBtn.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(bottomBgView.snp.top).offset(10)
            $0.height.equalTo(60)
        }
        
        //
        
        rateBtn.adhere(toSuperview: bottomBgView)
        rateBtn.addTarget(self, action: #selector(rateusBtnClick(sender:)), for: .touchUpInside)
        rateBtn.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(termsBtn.snp.bottom).offset(10)
            $0.height.equalTo(60)
        }
        //
        
        privacyBtn.adhere(toSuperview: bottomBgView)
        privacyBtn.addTarget(self, action: #selector(privacyBtnClick(sender:)), for: .touchUpInside)
        privacyBtn.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(rateBtn.snp.bottom).offset(10)
            $0.height.equalTo(60)
        }
        //
        
        feedbackBtn.adhere(toSuperview: bottomBgView)
        feedbackBtn.addTarget(self, action: #selector(feedbackBtnClick(sender:)), for: .touchUpInside)
        feedbackBtn.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(privacyBtn.snp.bottom).offset(10)
            $0.height.equalTo(60)
        }
        //
        
        restoreBtn.adhere(toSuperview: bottomBgView)
        restoreBtn.addTarget(self, action: #selector(restoreBtnClick(sender:)), for: .touchUpInside)
        restoreBtn.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(feedbackBtn.snp.bottom).offset(10)
            $0.height.equalTo(60)
        }
        
        //
        purchaseLinkBtn.adhere(toSuperview: bottomBgView)
        purchaseLinkBtn.addTarget(self, action: #selector(purchaseLinkBtnClick(sender:)), for: .touchUpInside)
        purchaseLinkBtn.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(restoreBtn.snp.bottom).offset(10)
            $0.height.equalTo(60)
        }
        purchaseLinkBtn.line.isHidden = true
        
        //
        purchaseResultRefresh()
        
    }
    
    

}

extension PSSettingVC {
    @objc func vipBtnClick(sender: UIButton) {
        startSubscribeBtnClick()
    }
     
    @objc func termsBtnClick(sender: UIButton) {
        var url = URL(string: touUrl)
        let lan = Locale.preferredLanguages.first ?? "en"
        debugPrint("preferredLanguages = \(Locale.preferredLanguages)")
        if lan.contains("zh") {
            url = URL(string: touUrl_cn)
        }
//        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        let vc = PSkWebLinkVC(contentUrl: url, nil, "Terms of Use".localized())
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func rateusBtnClick(sender: UIButton) {
        rateusAction()
    }
    @objc func privacyBtnClick(sender: UIButton) {
        var url = URL(string: ppUrl)
        let lan = Locale.preferredLanguages.first ?? "en"
        debugPrint("preferredLanguages = \(Locale.preferredLanguages)")
        if lan.contains("zh") {
            url = URL(string: ppUrl_cn)
        }
        
        let vc = PSkWebLinkVC(contentUrl: url, nil, "Privacy Policy".localized())
        self.navigationController?.pushViewController(vc, animated: true)
//        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
    @objc func feedbackBtnClick(sender: UIButton) {
        sendEmailAction()
    }
    @objc func restoreBtnClick(sender: UIButton) {
        restoreButtonClick()
    }
    
    @objc func purchaseLinkBtnClick(sender: UIButton) {
//        if let purPath = Bundle.main.path(forResource: purhcasepUrl, ofType: nil) {
//            do {
//                let purchaseNoticeStr = try String(contentsOfFile: purPath, encoding: .utf8)
//                let vc = PSkWebLinkVC(contentUrl: nil)
//                vc.webView.loadHTMLString(purchaseNoticeStr, baseURL: nil)
//                self.navigationController?.pushViewController(vc, animated: true)
//            } catch {
//
//            }
//
//        }
        
        let vc = PSkWebLinkVC(contentUrl: nil, purhcasepUrl, "Purchase Notice".localized())
        self.navigationController?.pushViewController(vc, animated: true)
        
        
        
//        let purl = purhcasepUrl
//        var url = URL(string: purl)
//        let lan = Locale.preferredLanguages.first ?? "en"
//        debugPrint("preferredLanguages = \(Locale.preferredLanguages)")
//        if lan.contains("zh") {
//            let purl_cn = Bundle.main.path(forResource: purhcasepUrl_cn, ofType: nil)
//            url = URL(string: purl_cn)
//        }
        
    }
    
    
    //
    func showSetNotificationSuccessAlert() {
        ZKProgressHUD.showSuccess("Set Success".localized(), autoDismissDelay: 2)
    }
    func showLocalNotiDeniedAlert() {
        let alert = UIAlertController(title: "No Permission".localized(), message: "You have declined notification. To give permission tap on Go Setting button.".localized(), preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Go setting".localized(), style: .default, handler: { (goSettingAction) in
            DispatchQueue.main.async {
                let url = URL(string: UIApplication.openSettingsURLString)!
                UIApplication.shared.open(url, options: [:])
            }
        })
        let cancelAction = UIAlertAction(title: "Cancel".localized(), style: .cancel)
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true)
    }
    
    
}

extension PSSettingVC {
    @objc func backBtnClick(sender: UIButton) {
        //TODO: 是否取消扫描
        if self.navigationController != nil {
            self.navigationController?.popViewController()
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func rateusAction() {
        let appId = APP_Id
        let rateUrlStr = "itms-apps://itunes.apple.com/app/id\(appId)?action=write-review"
        if let url = URL(string: rateUrlStr) {
            UIApplication.shared.openURL(url: url)
        }
       
    }
    
    func sendEmailAction() {
        if MFMailComposeViewController.canSendMail() {
            //注意这个实例要写在if block里，否则无法发送邮件时会出现两次提示弹窗（一次是系统的）
            let mailComposeViewController = configuredMailComposeViewController()
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            showSendMailErrorAlert()
        }
    }
    
    func restoreButtonClick() {
        
        restoreFunc {
            ZKProgressHUD.showSuccess("Subscription successful!".localized(), maskStyle: nil, onlyOnceFont: nil, autoDismissDelay: 1.5, completion: nil)
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .buy, object: nil)
                NotificationCenter.default.post(name: .PurchaseSubscrtionStateChange, object: nil)
            }
        }
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
            }

        }
    }
}

extension PSSettingVC {
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertController(title: "Unable to send mail", message: "Your device has not set up a mailbox. Please set it in the Mail app before attempting to send it.", preferredStyle: .alert)
        sendMailErrorAlert.addAction(UIAlertAction(title: "OK".localized(), style: .default) { _ in })
        self.present(sendMailErrorAlert, animated: true) {
        }
    }

    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let deviceInfo = feefbackInfo(appName: AppName, appVersion: CurrentAppVersion ?? "", deviceModel: UIDevice.current.model, systemVersion: UIDevice.current.systemVersion, deviceName: DeviceName)
        let mailComposeVC = MFMailComposeViewController()
        mailComposeVC.mailComposeDelegate = self
        mailComposeVC.delegate = self

        mailComposeVC.setToRecipients([emailAddress])
        mailComposeVC.setSubject("\(AppName)_Feedback")
        mailComposeVC.setMessageBody(deviceInfo, isHTML: true)
        return mailComposeVC

    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {

        self.dismiss(animated: true, completion: nil)
    }
    
}


class CUSettingToolBtn: UIButton {
    
    var iconImgV = UIImageView()
    var nameLabel = UILabel()
    
    
    var iconImgName: String
    var nameStr: String
    let line = UIView()
    var switchBtnClickBlock: ((Bool)->Void)?
    
    
    init(frame: CGRect, iconImgName: String, nameStr: String) {
        self.iconImgName = iconImgName
        self.nameStr = nameStr
        
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        backgroundColor(UIColor.white)
        layer.cornerRadius = 8
        //
        iconImgV
            .image(iconImgName)
            .contentMode(.scaleAspectFit)
            .adhere(toSuperview: self)
        iconImgV.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(17)
            $0.width.height.equalTo(30)
        }
        //
        nameLabel
            .text(nameStr)
            .fontName(16, "Montserrat-Medium")
            .color(UIColor(hexString: "#292D32")!)
            .textAlignment(.left)
            .adhere(toSuperview: self)
        nameLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(56)
            $0.width.height.greaterThanOrEqualTo(1)
        }
        
        //
        line.backgroundColor(UIColor(hexString: "#F4F4F4")!.withAlphaComponent(1))
            .adhere(toSuperview: self)
        line.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.right.equalToSuperview().offset(-20)
            $0.left.equalToSuperview().offset(60)
            $0.height.equalTo(1)
        }
        line.layer.cornerRadius = 0.5
        
    }
    
     
}


class PSSettingVipCard: UIButton, SubscriptionBaseProtocol {
    
    let priceLabel = UILabel()
    let monthPriceDefault: String = "9.99"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        prepareData()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        
        layer.masksToBounds = true
        //
        let bgImgV = UIImageView()
        bgImgV.image("i_s_vipBgView")
            .contentMode(.scaleAspectFill)
            .adhere(toSuperview: self)
        bgImgV.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        //
        let vipLabel = UILabel()
        vipLabel.fontName(14, "Montserrat-Bold")
            .color(UIColor(hexString: "#BAA867")!)
            .text("VIP")
            .textAlignment(.center)
            .adhere(toSuperview: self)
        vipLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(30)
            $0.right.equalToSuperview().offset(-30)
            $0.width.height.greaterThanOrEqualTo(1)
        }
        
        //
        let nowTryLabel = UILabel()
        nowTryLabel.fontName(14, "Montserrat-Bold")
            .color(UIColor(hexString: "#BAA867")!)
            .backgroundColor(UIColor.white)
            .text("Try Now".localized())
            .textAlignment(.center)
            .adhere(toSuperview: self)
        nowTryLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-28)
            $0.width.equalTo(130)
            $0.height.equalTo(32)
        }
        nowTryLabel.layer.cornerRadius = 6
        nowTryLabel.layer.masksToBounds = true
        
        //
        let info1Label = UILabel()
        info1Label.fontName(18, "Montserrat-Bold")
            .color(UIColor(hexString: "#FFFFFF")!)
            .text("Unlimited Save Photos".localized())
            .textAlignment(.center)
            .adhere(toSuperview: self)
        info1Label.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(self.snp.centerY).offset(-26)
            $0.left.equalTo(40)
            $0.height.greaterThanOrEqualTo(30)
        }
        //
        //
        
        priceLabel
            .fontName(16, "Montserrat-Medium")
            .textAlignment(.center)
            .text("$2.99/\("Month".localized())")
            .color(UIColor.white)
            .adjustsFontSizeToFitWidth()
            .adhere(toSuperview: self)
        priceLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(info1Label.snp.bottom).offset(12)
            $0.width.height.greaterThanOrEqualTo(20)
        }
        
        
        //
        let free3DayLabel = UILabel()
        free3DayLabel
            .fontName(12, "Montserrat-Regular")
            .textAlignment(.center)
            .text("3-day Free Trial".localized())
            .color(UIColor.white)
            .adjustsFontSizeToFitWidth()
            .adhere(toSuperview: self)
        free3DayLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(nowTryLabel.snp.top).offset(-5)
            $0.width.height.greaterThanOrEqualTo(20)
        }
        
       
        //
        let cancelLabel = UILabel()
        cancelLabel
            .fontName(10, "Montserrat-Regular")
            .textAlignment(.center)
            .text("Cancel anytime".localized())
            .color(UIColor.white)
            .adjustsFontSizeToFitWidth()
            .adhere(toSuperview: self)
        cancelLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(nowTryLabel.snp.bottom).offset(2)
            $0.width.height.greaterThanOrEqualTo(20)
        }
        
    }
    
    
    func prepareData() {
        if let cacheIapMonthInfo = UserDefaults.standard.value(forKey: cacheIapInfoMonthKey) as? [String: Any] {
            let localizedPrice = cacheIapMonthInfo["localizedPrice"] as? String ?? ""
            let _ = cacheIapMonthInfo["currencySymbol"] as? String ?? ""
            let _ = cacheIapMonthInfo["price"] as? Double ?? 0
            
            self.priceLabel.text("\(localizedPrice)/\("Month".localized())")
            
        } else {
            
            self.priceLabel.text("\("$\(monthPriceDefault)")/\("Month".localized())")
        }
        
        getSubscriptionData {[weak self] models in
            guard let `self` = self else {return}
            //
            let month = models.filter{$0.iapType == .month}.first
            if let month = month {
                self.priceLabel.text("\("\(month.localizedPrice)")/\("Month".localized())")
                 
            }
            //
//            let week = models.filter{$0.iapType == .week}.first
//            if let week = week {
//                self.weekBtn.priceLabel.text = "\(week.localizedPrice)"
//                self.weekBtn.weekPriceLabel.text = "\("XX per week".localized().replacingOccurrences(of: "XX", with: "\(String(format: "%@%.2f", week.currencySymbol,week.price))"))"
//
//
//            }
//            //
//            let year = models.filter{$0.iapType == .year}.first
//            if let year = year {
//                self.yearBtn.priceLabel.text = "\(year.localizedPrice)"
//                self.yearBtn.weekPriceLabel.text = "\("XX per week".localized().replacingOccurrences(of: "XX", with: "\(String(format: "%@%.2f", year.currencySymbol,year.price/52))"))"
//            }
            
        }
        
    }
    
    
    
}

