//
//  PSkDataManager.swift
//  PSkbsPicSpace
//
//  Created by JOJO on 2021/11/3.
//

import Foundation
class PSkDataManager: NSObject {
    static let `default` = PSkDataManager()
    
    var profileMakeFrameItems: [PSkProfileFrameItem] = []
    
    
    override init() {
        super.init()
        
        
    }
}
