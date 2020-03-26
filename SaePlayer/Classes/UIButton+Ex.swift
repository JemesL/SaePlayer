//
//  UIButton+Ex.swift
//  SaePlayerSample
//
//  Created by Jemesl on 2020/3/23.
//  Copyright © 2020 Jemesl. All rights reserved.
//

import Foundation
import UIKit

extension UIButton{
    
    // 改进写法【推荐】
    private struct RuntimeKey {
        static let clickEdgeInsets = UnsafeRawPointer.init(bitPattern: "clickEdgeInsets".hashValue)
        /// ...其他Key声明
    }
    /// 需要扩充的点击边距
    public var clickEdgeInsets: UIEdgeInsets? {
        set {
            objc_setAssociatedObject(self, UIButton.RuntimeKey.clickEdgeInsets!, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY)
        }
        get {
            return objc_getAssociatedObject(self, UIButton.RuntimeKey.clickEdgeInsets!) as? UIEdgeInsets ?? UIEdgeInsets.zero
        }
    }
    // 重写系统方法修改点击区域
    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        super.point(inside: point, with: event)
        var bounds = self.bounds
        if (clickEdgeInsets != nil) {
            let x: CGFloat = -(clickEdgeInsets?.left ?? 0)
            let y: CGFloat = -(clickEdgeInsets?.top ?? 0)
            let width: CGFloat = bounds.width + (clickEdgeInsets?.left ?? 0) + (clickEdgeInsets?.right ?? 0)
            let height: CGFloat = bounds.height + (clickEdgeInsets?.top ?? 0) + (clickEdgeInsets?.bottom ?? 0)
            bounds = CGRect(x: x, y: y, width: width, height: height) //负值是方法响应范围
        }
        return bounds.contains(point)
    }
}
