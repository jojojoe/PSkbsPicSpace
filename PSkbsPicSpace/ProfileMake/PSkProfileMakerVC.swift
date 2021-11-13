//
//  PSkProfileMakerVC.swift
//  PSkbsPicSpace
//
//  Created by JOJO on 2021/11/4.
//

import UIKit

class PSkProfileMakerVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        processRemoveImageBg()
        
    }
    

     

}

extension PSkProfileMakerVC {
    func setupView() {
        view.backgroundColor(.white)
        //
        
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

