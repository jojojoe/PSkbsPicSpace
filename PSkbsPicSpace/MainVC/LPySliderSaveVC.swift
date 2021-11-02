//
//  LPySliderSaveVC.swift
//  LpymLpost
//
//  Created by JOJO on 2021/11/2.
//

import UIKit

class LPySliderSaveVC: UIViewController {

    let backBtn = UIButton(type: .custom)
    var shareBtn = UIButton(type: .custom)
    
    
    var images: [UIImage]
    init(images: [UIImage]) {
        self.images = images
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
    }
    
    func setupView() {
        view.backgroundColor(.white)
        
        backBtn
            .image(UIImage(named: "editor_arrow_left"))
            .adhere(toSuperview: view)
        backBtn.addTarget(self, action: #selector(backBtnClick(sender: )), for: .touchUpInside)
        backBtn.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.left.equalTo(10)
            $0.width.height.equalTo(44)
        }
        
        //
        shareBtn
            .image(UIImage(named: "editor_share"))
            .adhere(toSuperview: view)
        shareBtn.addTarget(self, action: #selector(backBtnClick(sender: )), for: .touchUpInside)
        shareBtn.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.right.equalTo(-10)
            $0.width.height.equalTo(44)
        }
        
        
    }
    
    @objc func backBtnClick(sender: UIButton) {
        
        if self.navigationController != nil {
            self.navigationController?.popViewController()
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
