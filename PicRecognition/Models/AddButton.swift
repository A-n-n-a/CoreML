//
//  AddButton.swift
//  PicRecognition
//
//  Created by Anna on 8/26/18.
//  Copyright © 2018 Anna. All rights reserved.
//

import UIKit

@IBDesignable

class AddButton: UIButton {

    override func draw(_ rect: CGRect) {
        let path = UIBezierPath(ovalIn: rect)
        UIColor.green.setFill()
        path.fill()
        
        // Horizontal Line
        let plusWidth: CGFloat = min(bounds.width, bounds.height) * Constants.plusButtonScale
        let halfPlusWidth = plusWidth / 2
        let plusPath = UIBezierPath()
        plusPath.lineWidth = Constants.plusLineWidth
        plusPath.move(to: CGPoint(
            x: halfWidth - halfPlusWidth + Constants.halfPointShift,
            y: halfHeight + Constants.halfPointShift))
        plusPath.addLine(to: CGPoint(
            x: halfWidth + halfPlusWidth + Constants.halfPointShift,
            y: halfHeight + Constants.halfPointShift))
        
        //Vertical Line
        plusPath.move(to: CGPoint(
            x: halfWidth + Constants.halfPointShift,
            y: halfHeight - halfPlusWidth + Constants.halfPointShift))
        
        plusPath.addLine(to: CGPoint(
            x: halfWidth + Constants.halfPointShift,
            y: halfHeight + halfPlusWidth + Constants.halfPointShift))

        UIColor.white.setStroke()
        plusPath.stroke()

    }
    
    private struct Constants {
        static let plusLineWidth: CGFloat = 3.0
        static let plusButtonScale: CGFloat = 0.6
        static let halfPointShift: CGFloat = 0.5
    }
    
    private var halfWidth: CGFloat {
        return bounds.width / 2
    }
    
    private var halfHeight: CGFloat {
        return bounds.height / 2
    }
}



