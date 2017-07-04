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

open class AssistiveTouchDelegate: AssistiveTouchViewControllerDelegate {
    
    /// Assistive touch position.
    open let assistiveTouchPosition: AssistiveTouchPosition
    
    open let assistiveTouchView: AssistiveTouchView = AssistiveTouchView()
    
    open var endPosition: CGPoint = .zero
    open var shrinkSize: CGSize { return CGSize(width: 60, height: 60) }
    
    public init(assistiveTouchPosition: AssistiveTouchPosition = AssistiveTouchPosition()) {
        self.assistiveTouchPosition = assistiveTouchPosition
    }
    
    open func viewDidLoad(_ controller: AssistiveTouchViewController) {
        controller.contentView.addSubview(assistiveTouchView)
        assistiveTouchView.frame = CGRect(origin: .zero, size: shrinkSize)
    }
    
    open func shrink(_ controller: AssistiveTouchViewController) {
        
    }
    
    open func spread(_ controller: AssistiveTouchViewController) {
        
    }
    
    open func assistiveTouch(_ controller: AssistiveTouchViewController, beganDragFromPosition position: CGPoint) {
        controller.contentView.alpha = 1
    }
    
    open func assistiveTouch(_ controller: AssistiveTouchViewController, draggingToPosition position: CGPoint) {
        
    }
    
    open func assistiveTouch(_ controller: AssistiveTouchViewController, didEndDragToPosition position: CGPoint) {
        controller.contentView.alpha = 0.5
        endPosition = CGPoint(x: position.x - shrinkSize.width / 2, y: position.y - shrinkSize.height / 2)
        
        /// Adsorption to static point.
        UIView.animate(withDuration: 0.3) {
            controller.window?.frame.origin = self.assistiveTouchPosition.adsorption(currentFrame: CGRect(origin: self.endPosition,
                                                                                                          size: controller.contentView.frame.size),
                                                                                     inSize: UIScreen.main.bounds.size)
        }
    }
}
