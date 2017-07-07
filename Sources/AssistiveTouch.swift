//
//  AssistiveTouch.swift
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

public enum AssistiveTouchStatus {
    case shrink
    case spread
    
    static public prefix func !(_ status: AssistiveTouchStatus) -> AssistiveTouchStatus {
        return status == .shrink ? .spread : .shrink
    }
}

/// Assistive touch
open class AssistiveTouch {
    
    /// Default assistive touch with default `AssistiveTouchViewController`.
    open static let `default`: AssistiveTouch = AssistiveTouch()
    
    /// Assistive touch window
    open let window: UIWindow
    
    public init(controller: AssistiveTouchViewController = AssistiveTouchViewController(),
                defaultPosition: CGPoint = AssistiveTouchPosition.defaultPosition) {
        
        window = UIWindow(frame: CGRect(origin: defaultPosition,
                                        size: controller.delegate.shrinkSize))
        window.backgroundColor = .clear
        window.windowLevel = UIWindowLevelStatusBar + 1
        window.rootViewController = controller
        
        controller.window = window
    }
    
    /// This config need config only once.
    ///
    /// - Parameter section: AssistiveTouchSection.
    /// - Returns: AssistiveTouch
    open func config(withSection section: AssistiveTouchSection) -> Self {
        (window.rootViewController as! AssistiveTouchViewController).rootSection = section
        return self
    }
    
    /// Display assistive touch
    open func show() {
        window.isHidden = false
        window.makeKeyAndVisible()
    }
    
    /// Hide assistive touch
    open func hide() {
        window.isHidden = true
    }
}
