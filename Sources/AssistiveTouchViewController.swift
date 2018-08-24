//
//  AssistiveTouchViewController.swift
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

/// Base assistive touch view controller
open class AssistiveTouchViewController: UIViewController {
    
    /// Same as AssistiveTouch status
    public final private(set) var status: AssistiveTouchStatus {
        get {
            return assistiveTouch?.status ?? .shrink
        } set {
            assistiveTouch?.status = newValue
        }
    }
    
    /// Same as AssistiveTouch window
    public final var window: UIWindow? { return assistiveTouch?.window }
    
    /// AssistiveTouch
    open weak var assistiveTouch: AssistiveTouch?
    
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    @discardableResult
    public func shrink() -> Bool {
        guard status == .spread else { return false }
        status = .shrink
        return true
    }
    
    @discardableResult
    public func spread() -> Bool {
        guard status == .shrink else { return false }
        status = .spread
        return true
    }
}
