//
//  AssistiveTouchShrinkViewController.swift
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

/// Abstract shrink view
public typealias AssistiveTouchAbstractShrinkView = UIView

/// Default assistive touch view whitch same as system.
open class AssistiveTouchNormalShrinkView: AssistiveTouchAbstractShrinkView {
    
    /// Background effective view.
    open let effectiveView: UIVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
    open let shrinkLayer: CALayer = CALayer()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        effectiveView.frame = bounds
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

/// Abstract shrink rule
open class AssistiveTouchAbstractShrinkRule {
    /// Default position for first display assistive touch.
    open var defaultPosition: CGPoint { return CGPoint(x: 2, y: (UIScreen.main.bounds.size.height - shrinkSize.height) / 2) }
    /// Shrink size.
    open var shrinkSize: CGSize { return CGSize(width: 60, height: 60) }
    
    /// Adsorption rule.
    open func adsorption(currentFrame current: CGRect,
                         inSize size: CGSize,
                         minX: CGFloat = 2,
                         minY: CGFloat = 2,
                         adsorptionX: CGFloat = 60,
                         adsorptionY: CGFloat = 60) -> CGPoint {
        
        var adsorptionPoint: CGPoint = .zero
        
        /// Adsorption Y
        if current.origin.y < minY {
            adsorptionPoint.y = minY
        } else if current.origin.y > size.height - current.size.height - minY {
            adsorptionPoint.y = size.height - current.size.height - minY
        } else {
            adsorptionPoint.y = current.origin.y
        }
        
        /// Adsorption X
        if current.origin.x <= size.width / 2 - current.size.width / 2 {
            adsorptionPoint.x = minX
        } else {
            adsorptionPoint.x = size.width - current.size.width - minX
        }
        
        return adsorptionPoint
    }
    
    public required init() {
    }
}

/// Generic shrink view controller
open class AssistiveTouchShrinkViewController<ShrinkView: AssistiveTouchAbstractShrinkView, ShrinkRule: AssistiveTouchAbstractShrinkRule>: AssistiveTouchViewController {
    
    /// Container view whitch container shrinkView
    open let containerView = UIView()
    
    /// Shrink view
    open var shrinkView: ShrinkView?
    
    /// Shrink rule
    open let shrinkRule: ShrinkRule = ShrinkRule()
    
    open let defaultTransitionDelegate = AssistiveTouchTransition()
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        view.addSubview(containerView)
        
        containerView.backgroundColor = .clear
        containerView.alpha = 0.5
        containerView.frame = CGRect(origin: shrinkRule.defaultPosition, size: shrinkRule.shrinkSize)
        
        
        shrinkView = ShrinkView(frame: CGRect(origin: .zero, size: shrinkRule.shrinkSize))
        containerView.addSubview(shrinkView!)
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tap(_ :)))
        let dragGesture = UIPanGestureRecognizer(target: self, action: #selector(drag(_:)))
        containerView.addGestureRecognizer(tapGesture)
        containerView.addGestureRecognizer(dragGesture)
    }
    
    @discardableResult
    public override func spread() -> Bool {
        guard super.spread() else { return false }
        present(assistiveTouch!.spreadViewController)
        return true
    }
    
    open func present(_ controller: AssistiveTouchSpreadViewController) {
        let toController = UINavigationController(rootViewController: controller)
        toController.transitioningDelegate = defaultTransitionDelegate
        toController.modalPresentationStyle = .custom
        present(toController, animated: true, completion: nil)
    }
    
    //MARK: - Private
    
    @objc private func tap(_ gesture: UITapGestureRecognizer) {
        spread()
    }
    
    @objc private func drag(_ gesture: UIPanGestureRecognizer) {
        /// Only useful in shrink status.
        guard status == .shrink else { return }
        
        let position = gesture.location(in: nil)
        
        switch gesture.state {
        case .began:
            containerView.center = gesture.location(in: nil)
            containerView.alpha = 1
        case .changed:
            containerView.center = position
        case .ended, .cancelled, .failed:
            let endOrigin = shrinkRule.adsorption(currentFrame: CGRect(origin: CGPoint(x: position.x - shrinkRule.shrinkSize.width / 2,
                                                                                       y: position.y - shrinkRule.shrinkSize.height / 2),
                                                                       size: shrinkRule.shrinkSize),
                                                  inSize: UIScreen.main.bounds.size)
            
            UIView.animate(withDuration: 0.25, animations: {
                self.containerView.frame.origin = endOrigin
            }) { (_) in
                self.containerView.alpha = 0.5
            }
        case .possible: break
        }
    }
}
