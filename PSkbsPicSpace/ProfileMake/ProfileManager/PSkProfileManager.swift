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
        
        let item1 = PSkProfileFrameItem(itemId: "0", pixWidth: 300, pixHeight: 400, iconImgStr: "i_profile_size1_n", titleStr: "i_profile_size1_s")
        let item2 = PSkProfileFrameItem(itemId: "1", pixWidth: 800, pixHeight: 1200, iconImgStr: "i_profile_size2_n", titleStr: "i_profile_size2_s")
        let item3 = PSkProfileFrameItem(itemId: "2", pixWidth: 800, pixHeight: 800, iconImgStr: "i_profile_size3_n", titleStr: "i_profile_size3_s")
        let item4 = PSkProfileFrameItem(itemId: "2", pixWidth: 1600, pixHeight: 1600, iconImgStr: "i_profile_size4_n", titleStr: "i_profile_size4_s")
        let item5 = PSkProfileFrameItem(itemId: "3", pixWidth: 800, pixHeight: 400, iconImgStr: "i_profile_size5_n", titleStr: "i_profile_size5_s")
        let item6 = PSkProfileFrameItem(itemId: "3", pixWidth: 2000, pixHeight: 1200, iconImgStr: "i_profile_size6_n", titleStr: "i_profile_size6_s")
        
        profileMakeFrameItems = [item3, item1, item5, item4, item2, item6]
        
        
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
    
    func clearPhotosListData() {
        PSkProfileManager.default.photoItemList = []
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



