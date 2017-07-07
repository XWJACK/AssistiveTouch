//
//  AssistiveTouchItem.swift
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

/// Confirm this protocol to convert any type to AssistiveTouchItem
public protocol AssistiveTouchItemConvertable {
    func item() -> AssistiveTouchItem
}

/// Assistive touch item.
open class AssistiveTouchItem {
    public typealias Identifier = Int
    
    /// Identifer for each item, only union in one section.
    open let identifier: Int
    open let icon: UIImage?
    open let title: String?
    
    /// Action for Item.
    open var action: (() -> ())?
    /// Associate section
    open let section: AssistiveTouchSection?
    
    public init(identifier: Identifier,
                icon: UIImage? = nil,
                title: String? = nil,
                action: (() -> ())? = nil,
                section: AssistiveTouchSection? = nil) {
        self.identifier = identifier
        self.icon = icon
        self.title = title
        self.section = section
        self.action = action
    }
}

open class AssistiveTouchBackItem: AssistiveTouchItem {
    
}
