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

import Foundation

public enum AssistiveTouchStatus {
    case systole
    case expansion
}

public protocol AssistiveTouchItemConvertable {
    func item() -> AssistiveTouchItem
}

open class AssistiveTouch {
    
    open static let `default`: AssistiveTouch = AssistiveTouch()
    
    open let window: UIWindow = UIWindow(frame: CGRect(origin: .zero, size: CGSize(width: 60, height: 60)))
    open let controller: AssistiveTouchViewController = AssistiveTouchViewController()
    open var rootSection: AssistiveTouchSection?
    
    private init() {
        window.rootViewController = controller
        window.isHidden = true
        window.makeKeyAndVisible()
    }
}