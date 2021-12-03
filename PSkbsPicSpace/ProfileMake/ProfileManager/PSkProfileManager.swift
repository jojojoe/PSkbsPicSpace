//
//  PSkProfileManager.swift
//  PSkbsPicSpace
//
//  Created by JOJO on 2021/11/17.
//

import Foundation
import UIKit
import YUCIHighPassSkinSmoothing

struct PSkProfileFrameItem {
    var itemId: String
    var pixWidth: CGFloat
    var pixHeight: CGFloat
    var iconImgStr: String
    var titleStr: String
    
}

class ProfilePhotoItem: NSObject {
    
    var bgColor: UIColor?
    var originImg: UIImage?
    var smartImg: UIImage?
    var isSkinBeauty: Bool?
    var isRemoveBg: Bool?
    var isMirror: Bool?
    
}


class PSkProfileManager: NSObject {
    
    static let `default` = PSkProfileManager()
    
    var profileMakeFrameItems: [PSkProfileFrameItem] = []
    var profileBgColors: [String] = []
    
    var currentItem: ProfilePhotoItem?
    var photoItemList: [ProfilePhotoItem] = []
    
    var bgColorPhotoItem = ProfilePhotoItem()
    var addNewPhotoItem = ProfilePhotoItem()
    
    var userPhotosItem: [ProfilePhotoItem] = []
    
    var currentCanvasWidth: CGFloat?
    var currentCanvasHeight: CGFloat?
    
    override init() {
        super.init()
        loadData()
        
    }
    
    func loadData() {
        
        let item1 = PSkProfileFrameItem(itemId: "0", pixWidth: 1000, pixHeight: 1000, iconImgStr: "", titleStr: "Custom")
        let item2 = PSkProfileFrameItem(itemId: "1", pixWidth: 600, pixHeight: 600, iconImgStr: "", titleStr: "1x1")
        let item3 = PSkProfileFrameItem(itemId: "2", pixWidth: 300, pixHeight: 400, iconImgStr: "", titleStr: "一寸")
        let item4 = PSkProfileFrameItem(itemId: "3", pixWidth: 700, pixHeight: 900, iconImgStr: "", titleStr: "两寸")
        
        
        profileMakeFrameItems = [item1, item2, item3, item4]
        
        
        profileBgColors = ["#FFFFFF", "#9E0000", "#163AB8", "#1190EF", "#1D9265", "#D2A647", "#D87B22", "#00BDA6", "#602BB9"]
    }
    
    func setupTestPhotoItemList() {
        
        bgColorPhotoItem.bgColor = UIColor.white
        photoItemList = [bgColorPhotoItem, addNewPhotoItem]
         
    }
    
    func processUserPhotosItemList() {
        
        if PSkProfileManager.default.userPhotosItem.count == 3 {
            PSkProfileManager.default.photoItemList = [PSkProfileManager.default.bgColorPhotoItem]
            PSkProfileManager.default.photoItemList.append(contentsOf: PSkProfileManager.default.userPhotosItem)
        } else {
            PSkProfileManager.default.photoItemList = [PSkProfileManager.default.bgColorPhotoItem]
            PSkProfileManager.default.photoItemList.append(contentsOf: PSkProfileManager.default.userPhotosItem)
            PSkProfileManager.default.photoItemList.append(PSkProfileManager.default.addNewPhotoItem)
        }
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
    
    func processSkinBeautyFilterImageBg(originImg: UIImage) -> UIImage {
        guard let originImgcg = originImg.cgImage else {
            return originImg
        }
        let context = CIContext(options: [CIContextOption.workingColorSpace: CGColorSpaceCreateDeviceRGB()])
        let filter = YUCIHighPassSkinSmoothing()
        let inputCIImage = CIImage(cgImage: originImgcg)
        
        
        filter.inputImage = inputCIImage
        filter.inputAmount = NSNumber(value: 0.7) //self.amountSlider.value as NSNumber
        filter.inputRadius = 7.0 * inputCIImage.extent.width/750.0 as NSNumber
        let outputCIImage = filter.outputImage!
        
        let outputCGImage = context.createCGImage(outputCIImage, from: outputCIImage.extent)
        let outputUIImage = UIImage(cgImage: outputCGImage!, scale: originImg.scale, orientation: originImg.imageOrientation)
        
        
        return outputUIImage
        
    }
    
}



