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
//    func assistiveTouch(_ controller: AssistiveTouchViewController)
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
    
    open weak var delegate: AssistiveTouchViewControllerDelegate? = nil
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tap(_ :)))
        let dragGesture = UIPanGestureRecognizer(target: self, action: #selector(drag(_:)))
        
        view.addGestureRecognizer(tapGesture)
        view.addGestureRecognizer(dragGesture)
    }
    
    @objc private func tap(_ gesture: UITapGestureRecognizer) {
        
        status = !status
    }
    
    @objc private func drag(_ gesture: UIPanGestureRecognizer) {
        /// Only useful in shrink status.
        guard status == .shrink else { return }
        
        let position = gesture.location(in: view)
        view.center = position
        
        switch gesture.state {
        case .began: delegate?.assistiveTouch(self, beganDragFromPosition: position)
        case .changed: delegate?.assistiveTouch(self, draggingToPosition: position)
        case .ended, .cancelled, .failed: delegate?.assistiveTouch(self, didEndDragToPosition: position)
        case .possible: break
        }
    }
}
