//
//  PSSettingVC.swift
//  PSkbsPicSpace
//
//  Created by JOJO on 2021/12/10.
//

import UIKit
import MessageUI
import ZKProgressHUD

let APP_Id = ""
let infoForDictionary = Bundle.main.infoDictionary
func feefbackInfo(appName:String,appVersion:String,deviceModel:String,systemVersion:String,deviceName:String) -> String {
    return "<br /><br /><br /><br /><font color=\"#9F9F9F\" style=\"font-size: 13px;\"> <i>(\(appName) \(appVersion) on iPhone running with iOS \(systemVersion), device \(deviceName)</i>)</font>"
}
let feedbackDeviceInfoFormat = "<br /><br /><br /><br /><font color=\"#9F9F9F\" style=\"font-size: 13px;\"> <i>(%@ %@ on %@ running with iOS %@, device %@</i>)</font>"
let CurrentAppVersion = infoForDictionary?["CFBundleShortVersionString"] as? String
var AppName = infoForDictionary?["CFBundleDisplayName"] as? String ?? ""
var DeviceName = UIDevice.current.systemName

let emailAddress = ""
let ppUrl = ""
let touUrl = ""
//let appStoreUrl = "https://itunes.apple.com/app/id1583687807?mt=8#"
let ppUrl_cn = "https://docs.qq.com/doc/"
let touUrl_cn = "https://docs.qq.com/doc/"

class PSSettingVC: UIViewController, MFMailComposeViewControllerDelegate, UINavigationControllerDelegate {

    let backBtn = UIButton(type: .custom)
    let topTitleLabel = UILabel()
    let vipBtn = CUSettingToolBtn(frame: .zero, iconImgName: "ic_setting_full_accessicon", nameStr: "Go to Premium".localized())
    let termsBtn = CUSettingToolBtn(frame: .zero, iconImgName: "ic_setting_terms_of_useicon", nameStr: "Terms of Use".localized())
    let rateBtn = CUSettingToolBtn(frame: .zero, iconImgName: "ic_setting_rate_usicon", nameStr: "Rate Us".localized())
    let privacyBtn = CUSettingToolBtn(frame: .zero, iconImgName: "ic_setting_privacy_policyicon", nameStr: "Privacy Policy".localized())
    let feedbackBtn = CUSettingToolBtn(frame: .zero, iconImgName: "feedback_ic", nameStr: "Feedback".localized())
    let restoreBtn = CUSettingToolBtn(frame: .zero, iconImgName: "restore_ic", nameStr: "Restore Purchase".localized())
    let bottomBgView = UIView()
    //
    
    
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupToolBtns()
        addNoti()
    }
    
    func addNoti() {
        NotificationCenter.default.addObserver(self, selector: #selector(purchaseResultRefresh), name: Notification.Name.PurchaseSubscrtionStateChange , object: nil)
    }
    
    func setupView() {
        view.backgroundColor(UIColor(hexString: "#F5F7FE")!)
        view.clipsToBounds = true
        //
        backBtn
            .image(UIImage(named: "btn_photo_cleaning_returnbtn"))
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
            .fontName(17, "SFProText-Semibold")
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
                $0.height.equalTo(360)
            }
        } else {
            vipBtn.isHidden = false
            bottomBgView.snp.remakeConstraints {
                $0.left.equalTo(20)
                $0.top.equalTo(vipBtn.snp.bottom).offset(15)
                $0.centerX.equalToSuperview()
                $0.height.equalTo(360)
            }
        }
        self.view.layoutIfNeeded()
    }

    func setupToolBtns() {
        
        //
        
        vipBtn.adhere(toSuperview: view)
        vipBtn.addTarget(self, action: #selector(vipBtnClick(sender:)), for: .touchUpInside)
        vipBtn.snp.makeConstraints {
            $0.left.equalTo(20)
            $0.top.equalTo(backBtn.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(60)
        }
        //
        
        bottomBgView.layer.cornerRadius = 8
        bottomBgView
            .backgroundColor(UIColor.white)
            .adhere(toSuperview: view)
        bottomBgView.snp.makeConstraints {
            $0.left.equalTo(20)
            $0.top.equalTo(vipBtn.snp.bottom).offset(15)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(360)
        }
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
        purchaseResultRefresh()
        
    }
    
    

}

extension PSSettingVC {
    @objc func vipBtnClick(sender: UIButton) {
        let vc = PSStoreVC()
        vc.source = ""
        self.navigationController?.pushViewController(vc)
    }
     
    @objc func termsBtnClick(sender: UIButton) {
        var url = URL(string: touUrl)
        let lan = Locale.preferredLanguages.first ?? "en"
        debugPrint("preferredLanguages = \(Locale.preferredLanguages)")
        if lan.contains("zh") {
            url = URL(string: touUrl_cn)
        }
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
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
        
        
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
    @objc func feedbackBtnClick(sender: UIButton) {
        sendEmailAction()
    }
    @objc func restoreBtnClick(sender: UIButton) {
        PurchaseManager.share.restore {
            ZKProgressHUD.showSuccess()
            self.dismiss(animated: true, completion: nil)
        }
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
    var arrowImgV = UIImageView()
    var toolSwitch = UISwitch()
    
    var iconImgName: String
    var nameStr: String
    
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
            .fontName(16, "SFProText-Semibold")
            .color(UIColor(hexString: "#292D32")!)
            .textAlignment(.left)
            .adhere(toSuperview: self)
        nameLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(56)
            $0.width.height.greaterThanOrEqualTo(1)
        }
        
        arrowImgV
            .image("ic_home_next")
            .adhere(toSuperview: self)
        arrowImgV.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-10)
            $0.width.height.equalTo(10)
        }
        
        toolSwitch.isHidden = true
        toolSwitch.onTintColor = UIColor(hexString: "#3458E9")
        toolSwitch.thumbTintColor = UIColor.white
        toolSwitch.adhere(toSuperview: self)
        toolSwitch.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalTo(-15)
            $0.width.equalTo(40)
            $0.height.equalTo(22)
        }
        toolSwitch.addTarget(self, action: #selector(toolSwiftchClick(sender:)), for: .valueChanged)
        
        
    }
    
    @objc func toolSwiftchClick(sender: UISwitch) {
        switchBtnClickBlock?(sender.isOn)
    }
    
    
}




