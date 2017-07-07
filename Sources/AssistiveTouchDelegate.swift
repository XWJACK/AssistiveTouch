//
//  AssistiveTouchDelegate.swift
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

/// Delegate for AssistiveTouchViewControllerDelegate
open class AssistiveTouchDelegate: AssistiveTouchViewControllerDelegate {
    
    /// Assistive touch position.
    open let assistiveTouchPosition: AssistiveTouchPosition
    
    /// Assistive touch view.
    open let assistiveTouchView: AssistiveTouchView = AssistiveTouchView()
    
    /// End position when did end drag assistive touch.
    open var endPosition: CGPoint = AssistiveTouchPosition.defaultPosition
    
    open var shrinkSize: CGSize { return CGSize(width: 60, height: 60) }
    
    /// Current section.
    open var currentSection: AssistiveTouchSection = AssistiveTouchSection(items: [])
    
    private var reuseItems: [UIButton] = []
    private var currentItems: [UIButton] = []
    
    public init(assistiveTouchPosition: AssistiveTouchPosition = AssistiveTouchPosition()) {
        self.assistiveTouchPosition = assistiveTouchPosition
    }
    
    /// Add item into AssistiveTouchViewController contentView when viewDidLoad.
    ///
    /// - Parameters:
    ///   - view: contentView in AssistiveTouchViewController
    ///   - section: currentSection
    open func addItems(inView view: UIView,
                       withSection section: AssistiveTouchSection) {
        
        section.items.forEach { item in
            let button = reuseItems.last == nil ? UIButton(type: .custom) : reuseItems.popLast()!
            button.alpha = 0
            button.tag = item.value.identifier
            button.setImage(item.value.icon, for: .normal)
            button.setTitle(item.value.title, for: .normal)
            button.addTarget(self, action: #selector(itemAction(sender:)), for: .touchUpInside)
            currentItems.append(button)
            view.addSubview(button)
        }
    }
    
    open func removeItems(fromSection section: AssistiveTouchSection) {
        
    }
    
    @objc private func itemAction(sender: UIButton) {
        currentSection.items[sender.tag]?.action?()
    }
    
    //MARK: - AssistiveTouchViewControllerDelegate
    
    open func viewDidLoad(_ controller: AssistiveTouchViewController) {
        currentSection = controller.rootSection
        
        controller.contentView.addSubview(assistiveTouchView)
        assistiveTouchView.frame = CGRect(origin: .zero, size: shrinkSize)
    }
    
    open func shrink(_ controller: AssistiveTouchViewController) {
        currentSection = currentSection.rootSection()
        
        UIView.animate(withDuration: 0.25, animations: {
            self.assistiveTouchView.shrinkLayer.opacity = 1
//            self.assistiveTouchView.shrinkLayer.position = .zero
            self.assistiveTouchView.effectiveView.frame.size = self.shrinkSize
            self.assistiveTouchView.frame.size = self.shrinkSize
            controller.contentView.frame = CGRect(origin: self.endPosition, size: self.shrinkSize)
            
            self.currentItems.forEach{
                $0.frame.origin = .zero
                $0.alpha = 0
            }
        }, completion: { _ in
            controller.window?.frame = CGRect(origin: self.endPosition, size: self.shrinkSize)
            controller.contentView.frame.origin = .zero
            
            self.currentItems.forEach{
                self.reuseItems.append($0)
                $0.removeFromSuperview()
            }
            self.currentItems.removeAll()
        })
    }
    
    open func spread(_ controller: AssistiveTouchViewController) {
        
        addItems(inView: controller.contentView,
                 withSection: currentSection)
        
        controller.contentView.alpha = 1
        controller.window?.frame = UIScreen.main.bounds
        controller.contentView.frame.origin = endPosition
        
        UIView.animate(withDuration: 0.25) {
            let frame = CGRect(x: (UIScreen.main.bounds.width - 300) / 2,
                               y: (UIScreen.main.bounds.height - 300) / 2,
                               width: 300,
                               height: 300)
            controller.contentView.frame = frame
            self.assistiveTouchView.shrinkLayer.opacity = 0
//            self.assistiveTouchView.shrinkLayer.position = CGPoint(x: 300 / 2 - self.shrinkSize.width / 2,
//                                                                   y: 300 - self.shrinkSize.height)
            self.assistiveTouchView.frame.size = frame.size
            self.assistiveTouchView.effectiveView.frame.size = frame.size
            
            self.currentItems.forEach{
                $0.frame = self.currentSection.layout.frame(forIdentifier: $0.tag)
                $0.alpha = 1
            }
        }
    }
    
    open func assistiveTouch(_ controller: AssistiveTouchViewController, beganDragFromPosition position: CGPoint) {
        controller.contentView.alpha = 1
    }
    
    open func assistiveTouch(_ controller: AssistiveTouchViewController, draggingToPosition position: CGPoint) {
        
    }
    
    open func assistiveTouch(_ controller: AssistiveTouchViewController, didEndDragToPosition position: CGPoint) {
        
        controller.contentView.alpha = 0.5
        
        endPosition = self.assistiveTouchPosition.adsorption(currentFrame: CGRect(origin: CGPoint(x: position.x - shrinkSize.width / 2,
                                                                                                  y: position.y - shrinkSize.height / 2),
                                                                                  size: controller.contentView.frame.size),
                                                             inSize: UIScreen.main.bounds.size)
        UIView.animate(withDuration: 0.3, animations: {
            controller.window?.frame.origin = self.endPosition
        })
    }
}
