//
//  UIButton+LC.swift
//  Doctoor
//
//  Created byDevBatch on 06/10/2017.
//  Copyright © 2017DevBatch. All rights reserved.
//

import Foundation
import UIKit

private var handle: UInt8 = 0

extension UIButton {
    
    private var badgeLayer: CAShapeLayer? {
        if let b: AnyObject = objc_getAssociatedObject(self, &handle) as AnyObject? {
            return b as? CAShapeLayer
        } else {
            return nil
        }
    }
    
    func addBadge(number: Int, withOffset offset: CGPoint = CGPoint.zero, andColor color: UIColor = #colorLiteral(red: 0.8765643239, green: 0, blue: 0.2733098865, alpha: 1), andFilled filled: Bool = true, position: BadgePosition = .topRight) {
        //guard let view = self.value(forKey: "view") as? UIView else { return }
        
        badgeLayer?.removeFromSuperlayer()
        
        if number == 0 {
            return
        }
        
        // Initialize Badge
        let badge = CAShapeLayer()
        let radius = CGFloat(8)
        let label = CATextLayer()
        
        var location: CGPoint?
        
        switch position {
            
        case .topRight:
            location = CGPoint(x: self.frame.width - (radius + offset.x+2.0), y: (radius + offset.y+4.0))
            label.frame = CGRect(origin: CGPoint(x: (location?.x)! - 6.5, y: offset.y+5.0), size: CGSize(width: 12, height: 16))
            
        case .topLeft:
            location = CGPoint(x: 3.0, y: (radius + offset.y+2.0))
            label.frame = CGRect(origin: CGPoint(x: -3.0, y: 5.0), size: CGSize(width: 12, height: 16))
            
        case .left:
            location = CGPoint(x: self.frame.width - (radius + offset.x-5.0), y: (radius + offset.y-5.0))
            label.frame = CGRect(origin: CGPoint(x: (location?.x)! - 4, y: offset.y-5.0), size: CGSize(width: 12, height: 16))
            
        default: // right
            location = CGPoint(x: self.frame.width - (radius + offset.x-5.0), y: (radius + offset.y-5.0))
            label.frame = CGRect(origin: CGPoint(x: (location?.x)! - 4, y: offset.y-5.0), size: CGSize(width: 12, height: 16))
        }
        
        badge.drawCircleAtLocation(location: location!, withRadius: radius, andColor: #colorLiteral(red: 0.8765643239, green: 0, blue: 0.2733098865, alpha: 1), filled: filled)
        self.layer.addSublayer(badge)
        
        // Initialiaze Badge's label
        label.string = "\(number)"
        label.alignmentMode = CATextLayerAlignmentMode.center
        label.fontSize = 11
        label.foregroundColor = filled ? UIColor.white.cgColor : #colorLiteral(red: 0.8765643239, green: 0, blue: 0.2733098865, alpha: 1)
        label.backgroundColor = UIColor.clear.cgColor
        label.contentsScale = UIScreen.main.scale
        badge.addSublayer(label)
        
        // Save Badge as UIBarButtonItem property
        objc_setAssociatedObject(self, &handle, badge, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    func updateBadge(number: Int) {
        
        if number == 0 {
            badgeLayer?.isHidden = true
            return
        }
        
        if let text = badgeLayer?.sublayers?.filter({ $0 is CATextLayer }).first as? CATextLayer {
            text.string = "\(number)"
        }
    }
    
    func removeBadge() {
        badgeLayer?.removeFromSuperlayer()
    }
}
