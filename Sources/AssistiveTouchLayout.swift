//
//  AssistiveTouchLayout.swift
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

/// Layout for assistive touch section view.
///
/// -------------
/// | 0 | 1 | 2 |
/// -------------
/// | 3 | 4 | 5 |
/// -------------
/// | 6 | 7 | 8 |
/// -------------
///
open class AssistiveTouchLayout {
    
    public var layoutSize: CGSize { return CGSize(width: 300, height: 300) }
    public var itemSize: CGSize { return CGSize(width: 60, height: 60) }
    
    open let numberOfItems: Int
    open let totalItems: Int
    
    public init(_ numberOfItems: Int,
                totalItems: Int = 9) {
        self.numberOfItems = numberOfItems
        self.totalItems = totalItems
    }
    
    open func frame(forIdentifier identifer: AssistiveTouchItem.Identifier) -> CGRect {
        return CGRect(origin: CGPoint(x: CGFloat(identifer % 3) * 90 + 30,
                                      y: CGFloat(identifer / 3) * 90 + 30),
                      size: itemSize)
    }
}
