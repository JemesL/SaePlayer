//
//  UIWindow+Ex.swift
//  SaePlayer
//
//  Created by Jemesl on 2020/7/9.
//

import Foundation
extension UIWindow {
    static func getKeyWindow() -> UIWindow? {
        return UIApplication.shared.windows.filter({ $0.isKeyWindow }).last
    }
}
