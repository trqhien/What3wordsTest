//
//  UIEdgeInsets+Ext.swift
//  What3WordsTest
//
//  Created by Hien Tran on 22/10/2023.
//

import UIKit

extension UIEdgeInsets {
    static func all(_ value: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: value, left: value, bottom: value, right: value)
    }
}
