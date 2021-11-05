//
//  UIImage+Segmentation.swift
//  PSkbsPicSpace
//
//  Created by JOJO on 2021/11/5.
//

import Foundation
import CoreML
import UIKit

extension UIImage {
    public func segmentationDeepLabV3() -> UIImage? {
        do {
            let config = MLModelConfiguration()
            config.computeUnits = .all
            //DeepLabV3FP16
           let model = try DeepLabV3(configuration: config)
            if let pixelBufferRef = self.pixelBuffer(width: 513, height: 513) {
                if let output = try? model.prediction(image: pixelBufferRef) {
                    
                    if let image_i = output.semanticPredictions.image(min: 0, max: 1, channel: nil, axes: nil) {
                        return image_i
                    }
                    return nil
                }
                return nil
            }
            return nil
        } catch {
            return nil
        }
    }
    
    func resize(size: CGSize!) -> UIImage? {
        let rect = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(rect.size)
        self.draw(in:rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
}

 
