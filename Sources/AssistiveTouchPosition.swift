//
//  AssistiveTouchPosition.swift
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

open class AssistiveTouchPosition {
    
    open static var defaultPosition: CGPoint { return CGPoint(x: 2, y: 2) }
    
    open func adsorption(currentFrame current: CGRect, inSize size: CGSize, minX: CGFloat = 2, minY: CGFloat = 2, adsorptionX: CGFloat = 60, adsorptionY: CGFloat = 60) -> CGPoint {
        
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
}
