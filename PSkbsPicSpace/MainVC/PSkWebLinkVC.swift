//
//  PSkWebLinkVC.swift
//  PSkbsPicSpace
//
//  Created by Joe on 2022/1/19.
//

import UIKit
import SafariServices
import WebKit
import ZKProgressHUD

typealias NETWORKERRORBLOCK = () -> Void

class PSkWebLinkVC: UIViewController {

//    var sfSaferiVC: SFSafariViewController?
    var networkCallBack: NETWORKERRORBLOCK?
    var webViewDismissed: NETWORKERRORBLOCK?
    
    
    var requstURL:URL?
    var locationUrlName: String?
    var titleNameStr: String = ""
    
    
    let configurations = [
        "ShareMessageHandler"
    ]
    
    let topBanner = UIView()
    var webViewConfiguration: WKWebViewConfiguration {
        let preferences = WKPreferences()
//        preferences.javaScriptEnabled = true
//        preferences.javaScriptCanOpenWindowsAutomatically = true
        
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        configuration.preferences = preferences
        configuration.userContentController = WKUserContentController()
        configuration.websiteDataStore = WKWebsiteDataStore.default()
//        let javascript = "document.documentElement.style.webkitTouchCallout='none';"
//        let noneSelectScript = WKUserScript(source: javascript, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
//        configuration.userContentController.addUserScript(noneSelectScript)

        configurations.forEach {
            configuration.userContentController.add(self, name: $0)
        }
        return configuration
    }
    
    lazy var webView: WKWebView = {
        
        var webView = WKWebView(frame: self.view.bounds, configuration: webViewConfiguration)
        
        webView.scrollView.alwaysBounceVertical = true
        webView.scrollView.bounces = false
        webView.navigationDelegate = self

        return webView
    }()
    
    init(contentUrl:URL?, _ locationUrlName: String? = nil, _ titleNameStr: String = "") {
        self.requstURL = contentUrl
        self.locationUrlName = locationUrlName
        self.titleNameStr = titleNameStr
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
     
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11.0, *) {
            webView.scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            self.edgesForExtendedLayout = UIRectEdge.all
        }
        
    
        self.view.addSubview(webView)
        loadRequst()
        self.view.backgroundColor  = .white
         
        //
        
        topBanner.backgroundColor(.white)
            .adhere(toSuperview: view)
        topBanner.snp.makeConstraints {
            $0.left.right.top.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).offset(50)
        }
        //
        let backBtn = UIButton()
        backBtn
            .image("i_back")
            .adhere(toSuperview: view)
        backBtn.snp.makeConstraints {
            $0.left.equalTo(18)
            $0.bottom.equalTo(topBanner.snp.bottom)
            $0.height.equalTo(44)
            $0.width.equalTo(44)
        }
        backBtn.addTarget(self, action: #selector(backBtnClick(sender: )), for: .touchUpInside)
        
        //
        let topTitleLabel = UILabel()
        topTitleLabel
            .fontName(17, "Montserrat-Bold")
            .color(UIColor.black)
            .text(titleNameStr)
            .textAlignment(.center)
            .adhere(toSuperview: view)
        topTitleLabel
            .snp.makeConstraints {
                $0.centerY.equalTo(backBtn)
                $0.centerX.equalToSuperview()
                $0.width.height.greaterThanOrEqualTo(1)
            }
        
        
        
    }
    @objc func backBtnClick(sender: UIButton) {
        if self.navigationController != nil {
            self.navigationController?.popViewController()
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
     
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.webView.frame = CGRect(x: 0, y: self.topBanner.frame.maxY, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.size.height)
    }


}

extension PSkWebLinkVC {
    func loadRequst() {
        if let reqURL = self.requstURL {
            var request = URLRequest(url: reqURL)
            request.timeoutInterval = 30
            if let cookies = HTTPCookieStorage.shared.cookies(for: reqURL) {
                request.allHTTPHeaderFields = HTTPCookie.requestHeaderFields(with: cookies)
            }
            webView.load(request)
        } else if let locationName = self.locationUrlName {
//            let fileURL = Bundle.main.url(forResource: locationName, withExtension: "html" )
//            webView.loadFileURL(fileURL!,allowingReadAccessTo:Bundle.main.bundleURL);
            
            //
            
            do {
                if let path = Bundle.main.path(forResource: locationName, ofType: "html") {
                    let purchaseNoticeStr = try String(contentsOfFile: path, encoding: .utf8)
                    webView.loadHTMLString(purchaseNoticeStr, baseURL: nil)
                }
            } catch {
                
            }
            
            
            
        }
        
    }
    
    func close() {
        self.presentingViewController?.dismiss(animated: true, completion: {
            
        })
    }
}

extension PSkWebLinkVC {
   static func clearWebViewCache(timestamp:TimeInterval = 0) {
        let types = [WKWebsiteDataTypeMemoryCache, WKWebsiteDataTypeDiskCache]
        let websiteDataTypes = Set<AnyHashable>(types)
        let dateFrom = Date(timeIntervalSince1970: timestamp)
        if let websiteDataTypes = websiteDataTypes as? Set<String> {
            WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes,  modifiedSince: dateFrom, completionHandler: { })
        }
    }
    
    func executeLogic(callback: String?, functionName: String?, parameters: [String: Any]?) {
        if let callback = callback, let functionName = functionName{
            let jsonObject:[String : Any] = [
                "type": functionName,
                "params": parameters ?? []
            ]
            if let data = try? JSONSerialization.data(withJSONObject: jsonObject, options: []), let dataString = String(data: data, encoding: .utf8) {
                
            }
        }
    }
}


extension PSkWebLinkVC:WKScriptMessageHandler  {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        debugPrint(message.body)
        if let body = message.body as? [String: Any] {
            
        }
    }
}

extension PSkWebLinkVC: WKNavigationDelegate {
      
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        ZKProgressHUD.dismiss()
         
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {

    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        
        self.networkCallBack?()
        ZKProgressHUD.dismiss()
    }
    
    func dismissVC() {
        self.dismiss(animated: true) {
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        webViewDismissed?()
    }
    
}

