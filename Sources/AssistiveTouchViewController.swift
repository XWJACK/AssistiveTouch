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

public protocol AssistiveTouchViewControllerDelegate: class {
    var shrinkSize: CGSize { get }
    func viewDidLoad(_ controller: AssistiveTouchViewController)
    
    func shrink(_ controller: AssistiveTouchViewController)
    func spread(_ controller: AssistiveTouchViewController)
    
    func assistiveTouch(_ controller: AssistiveTouchViewController, beganDragFromPosition position: CGPoint)
    func assistiveTouch(_ controller: AssistiveTouchViewController, draggingToPosition position: CGPoint)
    func assistiveTouch(_ controller: AssistiveTouchViewController, didEndDragToPosition position: CGPoint)
}

public extension AssistiveTouchViewControllerDelegate {
    func assistiveTouch(_ controller: AssistiveTouchViewController, beganDragFromPosition position: CGPoint) {}
    func assistiveTouch(_ controller: AssistiveTouchViewController, draggingToPosition position: CGPoint) {}
    func assistiveTouch(_ controller: AssistiveTouchViewController, didEndDragToPosition position: CGPoint) {}
}

open class AssistiveTouchViewController: UIViewController {
    
    open private(set) var status: AssistiveTouchStatus = .shrink
    
    /// AssistiveTouchViewController will retain delegate until AssistiveTouchViewController deinit.
    open var delegate: AssistiveTouchViewControllerDelegate = AssistiveTouchDelegate()
    
    /// AssistiveTouch key windown.
    open weak var window: UIWindow? = nil
    
    /// Sub view need to `addSubview` into `contentView` instead of `view`.
    open let contentView: UIView = UIView()
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        contentView.frame.size = delegate.shrinkSize
        view.addSubview(contentView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tap(_ :)))
        let dragGesture = UIPanGestureRecognizer(target: self, action: #selector(drag(_:)))
        
        view.addGestureRecognizer(tapGesture)
        view.addGestureRecognizer(dragGesture)
        
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
            
            window?.frame = CGRect(origin: .zero, size: delegate.shrinkSize)
            window?.center = position
            contentView.frame.origin = .zero
            
            delegate.assistiveTouch(self, didEndDragToPosition: position)
        case .possible: break
        }
    }
}
