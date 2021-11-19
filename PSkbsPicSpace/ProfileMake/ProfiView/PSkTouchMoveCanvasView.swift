//
//  PSkTouchMoveCanvasView.swift
//  PSkbsPicSpace
//
//  Created by JOJO on 2021/11/18.
//

import UIKit

class PSkTouchMoveCanvasView: UIView {

    var moveV: UIView?
    var minScale: CGFloat = 0.1
    var maxScale: CGFloat = 1.5
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}

extension PSkTouchMoveCanvasView {
    func setupView() {
        
        self.backgroundColor(.white)
        
        
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
        guard let moveV_m = self.moveV else { return }
        
        if event?.allTouches?.count == 1 {
            if let touch = touches.first {
                let difx = touch.location(in: self).x - touch.previousLocation(in: self).x
                let dify = touch.location(in: self).y - touch.previousLocation(in: self).y
 
                let nPointx = moveV_m.center.x + difx
                let nPointy = moveV_m.center.y + dify
                moveV_m.center = CGPoint(x: nPointx, y: nPointy)
                

            }
        } else if event?.allTouches?.count == 2 {
        
            var touch1: UITouch?
            var touch2: UITouch?
            
            guard let touchesList = event?.allTouches?.enumerated() else { return }
            for (index, touch) in touchesList {
                if index == 0 {
                    touch1 = touch
                } else if index == 1 {
                    touch2 = touch
                }
            }
            
            if let touch1_m = touch1, let touch2_m = touch2 {
                let prevPoint1 = touch1_m.previousLocation(in: self)
                let prevPoint2 = touch2_m.previousLocation(in: self)
                let curPoint1 = touch1_m.location(in: self)
                let curPoint2 = touch2_m.location(in: self)
                
                
                let prevmidx = (prevPoint1.x + prevPoint2.x) / 2
                let prevmidy = (prevPoint1.y + prevPoint2.y) / 2
                
                let curmidx = (curPoint1.x + curPoint2.x) / 2
                let curmidy = (curPoint1.y + curPoint2.y) / 2
                
                let difx = curmidx - prevmidx
                let dify = curmidy - prevmidy
                
                // translation
                
                let nPointx = moveV_m.center.x + difx
                let nPointy = moveV_m.center.y + dify
                moveV_m.center = CGPoint(x: nPointx, y: nPointy)
                
                
                let prevDistance = distanceBetween(point1: prevPoint1, point2: prevPoint2)
                let newDistance = distanceBetween(point1: curPoint1, point2: curPoint2)
                let sizeDifference = newDistance / prevDistance
                
                
                //
                debugPrint("sizeDifference = \(sizeDifference)")
                
                // scale
                if moveV_m.frame.width <= self.frame.width * minScale || moveV_m.frame.width >= self.frame.width * maxScale {
                    
                } else {
                    moveV_m.transform = moveV_m.transform.scaledBy(x: sizeDifference, y: sizeDifference)
                }
                
                
                let prevAngle = angleBetween(point1: prevPoint1, point2: prevPoint2)
                let curAngle = angleBetween(point1: curPoint1, point2: curPoint2)
                let angleDifference = curAngle - prevAngle
                
                // rotate
                
                moveV_m.transform = moveV_m.transform.rotated(by: angleDifference)
                
            }
             
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        
    }
    
}

extension PSkTouchMoveCanvasView {
    
    func distanceBetween(point1: CGPoint, point2: CGPoint) -> CGFloat {
        let deltaX: CGFloat = abs(point1.x - point2.x)
        let deltaY: CGFloat = abs(point1.y - point2.y)
        let distance: CGFloat = sqrt((deltaY * deltaY) + (deltaX * deltaX))
        return distance
    }
    
    func angleBetween(point1: CGPoint, point2: CGPoint) -> CGFloat {
        let deltaY: CGFloat = point1.y - point2.y
        let deltaX: CGFloat = point1.x - point2.x
        let angle: CGFloat = atan2(deltaY, deltaX)
        return angle
    }
    
    
}
