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

/// Confirm this delegate to custom views and actions.
public protocol AssistiveTouchViewControllerDelegate: class {
    
    /// Size for shrink status.
    var shrinkSize: CGSize { get }
    
    /// Asks for delegate when AssistiveTouchViewController viewDidLoad.
    ///
    /// - Parameter controller: AssistiveTouchViewController
    func viewDidLoad(_ controller: AssistiveTouchViewController)
    
    /// Asks for delegate to shrink
    ///
    /// - Parameter controller: AssistiveTouchViewController
    func shrink(_ controller: AssistiveTouchViewController)
    
    /// Asks for delegate to spread
    ///
    /// - Parameter controller: AssistiveTouchViewController
    func spread(_ controller: AssistiveTouchViewController)
    
    /// Asks for delegate when began drag assistive touch.
    ///
    /// - Parameters:
    ///   - controller: AssistiveTouchViewController.
    ///   - position: From position.
    func assistiveTouch(_ controller: AssistiveTouchViewController, beganDragFromPosition position: CGPoint)
    
    /// Asks for delegate for dragging to position.
    ///
    /// - Parameters:
    ///   - controller: AssistiveTouchViewController.
    ///   - position: The new position.
    func assistiveTouch(_ controller: AssistiveTouchViewController, draggingToPosition position: CGPoint)
    
    /// Asks for delegate for end drag to position.
    ///
    /// - Parameters:
    ///   - controller: AssistiveTouchViewController.
    ///   - position: End position.
    func assistiveTouch(_ controller: AssistiveTouchViewController, didEndDragToPosition position: CGPoint)
}

public extension AssistiveTouchViewControllerDelegate {
    func shrink(_ controller: AssistiveTouchViewController) {}
    func spread(_ controller: AssistiveTouchViewController) {}
    func assistiveTouch(_ controller: AssistiveTouchViewController, beganDragFromPosition position: CGPoint) {}
    func assistiveTouch(_ controller: AssistiveTouchViewController, draggingToPosition position: CGPoint) {}
    func assistiveTouch(_ controller: AssistiveTouchViewController, didEndDragToPosition position: CGPoint) {}
}

open class AssistiveTouchViewController: UIViewController {
    
    open private(set) var status: AssistiveTouchStatus = .shrink
    
    /// AssistiveTouchViewController will retain delegate until AssistiveTouchViewController deinit.
    open var delegate: AssistiveTouchViewControllerDelegate = AssistiveTouchDelegate()
    
    /// Root section for assistive touch.
    open internal(set) var rootSection: AssistiveTouchSection = AssistiveTouchSection(items: [])
    
    /// AssistiveTouch key windown.
    open weak var window: UIWindow? = nil
    
    /// Sub view need to `addSubview` into `contentView` instead of `view`.
    open let contentView: UIView = UIView()
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        
        contentView.frame.size = delegate.shrinkSize
        contentView.backgroundColor = .clear
        view.addSubview(contentView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tap(_ :)))
        let dragGesture = UIPanGestureRecognizer(target: self, action: #selector(drag(_:)))
        view.addGestureRecognizer(tapGesture)
        contentView.addGestureRecognizer(dragGesture)
        
        delegate.viewDidLoad(self)
    }
    
    open func shrink() {
        status = !status
        delegate.shrink(self)
    }
    
    open func spread() {
        status = !status
        delegate.spread(self)
    }
    
    @objc private func tap(_ gesture: UITapGestureRecognizer) {
        status == .shrink ? spread() : shrink()
    }
    
    @objc private func drag(_ gesture: UIPanGestureRecognizer) {
        /// Only useful in shrink status.
        guard status == .shrink else { return }
        
        window?.frame = UIScreen.main.bounds
        let position = gesture.location(in: nil)
        
        switch gesture.state {
        case .began:
            
            contentView.center = position
            
            delegate.assistiveTouch(self, beganDragFromPosition: position)
        case .changed:
            
            contentView.center = position
            
            delegate.assistiveTouch(self, draggingToPosition: position)
        case .ended, .cancelled, .failed:
            
            window?.frame.size = delegate.shrinkSize
            window?.center = position
            contentView.frame.origin = .zero
            
            delegate.assistiveTouch(self, didEndDragToPosition: position)
        case .possible: break
        }
    }
}
