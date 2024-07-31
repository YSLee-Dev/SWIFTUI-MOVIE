//
//  NavigationView+.swift
//  SWIFTUI_Movie
//
//  Created by 이윤수 on 7/31/24.
//

import SwiftUI
import UIKit

extension UINavigationController: UINavigationControllerDelegate, UIGestureRecognizerDelegate {
    open override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }
    
    open func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
            viewControllers.count > 1
        }
}
