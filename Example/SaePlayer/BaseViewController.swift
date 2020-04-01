//
//  BaseViewController.swift
//  SaePlayer_Example
//
//  Created by Jemesl on 2020/3/30.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import Foundation
import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension BaseViewController {
}

extension BaseViewController: UINavigationControllerDelegate {
    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        
        /// 这里判断是否是当前代理控制器，如果是当前代理控制器的话，则是需要隐藏 navigationbar 的
        if viewController == self {
            navigationController.setNavigationBarHidden(true, animated: true)
        } else {
            /// 系统相册不能隐藏，所有就直接 return
            if navigationController.isKind(of: UIImagePickerController.self) {
                return
            }
            /// 不是当前代理控制器的话，显示真正的 navbar
            navigationController.setNavigationBarHidden(false, animated: true)
            /// 当不显示本页时，要么就 push 到下一页，要么就被 pop 了，那么就将 delegate 设置为 nil，防止出现 BAD ACCESS
            /// 之前将这段代码放在 viewDidDisappear 和 dealloc 中，这两种情况可能已经被 pop 了，self.navigationController 为 nil，这里采用手动持有 navigationController 的引用来解决
            if let delegate = navigationController.delegate, delegate === self {
                /// 如果 delegate 是自己才设置为 nil，因为 viewWillAppear 调用的比此方法较早，
                /// 其他 controller 如果设置了 delegate 就可能会被误伤
                navigationController.delegate = nil
            }
        }
    }
}

