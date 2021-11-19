//
//  PSkProfileManager.swift
//  PSkbsPicSpace
//
//  Created by JOJO on 2021/11/17.
//

import Foundation
import UIKit

class ProfilePhotoItem: NSObject {
    
    var bgColor: UIColor?
    var originImg: UIImage?
    var smartImg: UIImage?
    var isSkinBeauty: Bool?
    var isRemoveBg: Bool?
    var isMirror: Bool?
    
}


class PSkProfileManager {
    
    static let `default` = PSkProfileManager()
    
    var currentItem: ProfilePhotoItem?
    var photoItemList: [ProfilePhotoItem] = []
    
    func setupTestPhotoItemList() {
        
        let item1 = ProfilePhotoItem()
        item1.bgColor = UIColor.purple
        
        let item2 = ProfilePhotoItem()
        item2.bgColor = nil
        
        item2.originImg = UIImage(named: "profile3.jpg")
        if let img1 = UIImage(named: "profile3.jpg") {
            item2.smartImg = PSkProfileManager.default.processRemoveImageBg(originImg: img1)
        }
        
        item2.isRemoveBg = true
        item2.isMirror = true
        item2.isSkinBeauty = true
        
        let item3 = ProfilePhotoItem()
        item3.bgColor = nil
        item3.originImg = UIImage(named: "profile3.jpg")
        if let img1 = UIImage(named: "profile3.jpg") {
            item3.smartImg = PSkProfileManager.default.processRemoveImageBg(originImg: img1)
        }
        item3.isRemoveBg = true
        item3.isMirror = false
        item3.isSkinBeauty = true
        
        let item4 = ProfilePhotoItem()
        item4.bgColor = nil
        item4.originImg = UIImage(named: "profile3.jpg")
        if let img1 = UIImage(named: "profile3.jpg") {
            item4.smartImg = PSkProfileManager.default.processRemoveImageBg(originImg: img1)
        }
        item4.isRemoveBg = false
        item4.isMirror = true
        item4.isSkinBeauty = true
        
        let item5 = ProfilePhotoItem()
        
        photoItemList = [item1, item2, item3, item4, item5]
        
    }
    
    func processRemoveImageBg(originImg: UIImage) -> UIImage {
        
        let sourceImg = originImg
        
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



