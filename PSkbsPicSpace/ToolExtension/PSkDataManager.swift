//
//  PSkDataManager.swift
//  PSkbsPicSpace
//
//  Created by JOJO on 2021/11/3.
//

import Foundation
import UIKit

struct PSkProfileFrameItem {
    var itemId: String
    var pixWidth: CGFloat
    var pixHeight: CGFloat
    var iconImgStr: String
    var titleStr: String
    
}


class PSkDataManager: NSObject {
    static let `default` = PSkDataManager()
    
    var profileMakeFrameItems: [PSkProfileFrameItem] = []
    
    
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
    }
    
    
    
}
