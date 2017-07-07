//
//  AssistiveTouchView.swift
//
//  Copyright (c) 2017 Jack
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import UIKit

/// Default assistive touch view whitch same as system.
open class AssistiveTouchView: UIView {
    
    /// Background effective view.
    open let effectiveView: UIVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
    open let shrinkLayer: CALayer = CALayer()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        effectiveView.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        effectiveView.layer.cornerRadius = 12
        effectiveView.layer.masksToBounds = true
        addSubview(effectiveView)
        
        shrinkLayer.addSublayer(createCircle(center: CGPoint(x: 30, y: 30), radius: 22, alpha:0.2))
        shrinkLayer.addSublayer(createCircle(center: CGPoint(x: 30, y: 30), radius: 18, alpha:0.5))
        shrinkLayer.addSublayer(createCircle(center: CGPoint(x: 30, y: 30), radius: 14, alpha:0.8))
        
        effectiveView.layer.addSublayer(shrinkLayer)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Create cycyle layer.
    ///
    /// - Parameters:
    ///   - center: Circle center
    ///   - radius: Circle radius
    ///   - alpha: Layer alpha
    /// - Returns: CAShapeLayer
    private func createCircle(center: CGPoint, radius: CGFloat, alpha: CGFloat) -> CAShapeLayer {
        let layer = CAShapeLayer()
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0.0, endAngle: CGFloat(2 * Double.pi), clockwise: true)
        
        layer.path = path.cgPath
        layer.fillColor = UIColor(white: 1, alpha: alpha).cgColor
        layer.lineWidth = 1
        layer.strokeColor = UIColor(white: 0, alpha: 0.3 * alpha).cgColor
        return layer
    }
}
