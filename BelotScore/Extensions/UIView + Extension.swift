//
//  UIView + Extension.swift
//  BelotScore
//
//  Created by Borna Ungar on 14.11.2021..
//

import Foundation
import UIKit
extension UIView {
    
    func addSubviews(views: UIView...) {
        for view in views {
            addSubview(view)
        }
    }
}
