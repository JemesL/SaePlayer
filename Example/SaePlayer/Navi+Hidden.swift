//
//  Navi+Hidden.swift
//  SaePlayer_Example
//
//  Created by Jemesl on 2020/3/30.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
//fileprivate struct AssociatedKeys {
//    static var navigationBarHidden: String = "NavigationBarHidden"
//    static var willAppearInjectBlock: String = "WillAppearInjectBlock"
//    static var navigationBarAppearanceEnabled: String = "NavigationBarAppearanceEnabled"
//}


//extension UIViewController {
//    fileprivate struct AssociatedKeys {
//        static var navigationBarHidden: String = "NavigationBarHidden"
//        static var willAppearInjectBlock: String = "WillAppearInjectBlock"
//        static var navigationBarAppearanceEnabled: String = "NavigationBarAppearanceEnabled"
//    }
//    typealias WillAppearInjectBlock = (_ vc: UIViewController, _ animated: Bool) -> ()
//    var isNavigationHidden: Bool {
//        get {
//            return objc_getAssociatedObject(self, &AssociatedKeys.navigationBarHidden) as? Bool ?? false
//        }
//    }
//
//    func setNavigationHidden(_ status: Bool) {
//        objc_setAssociatedObject(self, &AssociatedKeys.navigationBarHidden, status, .OBJC_ASSOCIATION_RETAIN)
//    }
//
//    var injectBlock: WillAppearInjectBlock? {
//        get {
//            return objc_getAssociatedObject(self, &AssociatedKeys.willAppearInjectBlock) as? WillAppearInjectBlock
//        }
//    }
//
//    func setInjectBlock(_ block: @escaping WillAppearInjectBlock) {
//        objc_setAssociatedObject(self, &AssociatedKeys.willAppearInjectBlock, block, .OBJC_ASSOCIATION_RETAIN)
//    }
//}
//
//extension UIViewController {
//    @_dynamicReplacement(for: viewWillAppear(_:))
//    dynamic func hookViewWillAppdear(_ animated: Bool) {
//        self.hookViewWillAppdear(animated)
//        if let block = self.injectBlock {
//            block(self, animated)
//        }
//    }
//}
//
//extension UINavigationController {
//    var navigationBarAppearanceEnabled: Bool {
//        get {
//            if let enable: Bool = objc_getAssociatedObject(self, &AssociatedKeys.navigationBarAppearanceEnabled) as? Bool {
//                return enable
//            } else {
//                self.setNavigationBarAppearanceEnabled(true)
//                return true
//            }
//        }
//    }
//
//    func setNavigationBarAppearanceEnabled(_ status: Bool) {
//        objc_setAssociatedObject(self, &AssociatedKeys.navigationBarAppearanceEnabled, status, .OBJC_ASSOCIATION_RETAIN)
//    }
//}
//
//extension UINavigationController {
//
//    @_dynamicReplacement(for: pushViewController(_:animated:))
//    dynamic func hookPushViewControll(vc: UIViewController, animated: Bool) {
//        print("hookPushViewControll: name-, hash-> \(vc.hash)")
//        self.setupVCBasedNavigationBarAppearanceIfNeed(appearingViewController: vc)
//        self.hookPushViewControll(vc: vc, animated: animated)
////        self.pushViewController(vc, animated: animated)
//    }
//
//    @_dynamicReplacement(for: setViewControllers(_:animated:))
//    dynamic func hookSetViewControllers(viewControllers: [UIViewController], animated: Bool) {
//
//        for vc in viewControllers {
//            self.setupVCBasedNavigationBarAppearanceIfNeed(appearingViewController: vc)
//        }
//        self.hookSetViewControllers(viewControllers: viewControllers, animated: animated)
//    }
//
//    func setupVCBasedNavigationBarAppearanceIfNeed(appearingViewController: UIViewController) {
//        if !self.navigationBarAppearanceEnabled {
//            return
//        }
//        let block: (_ vc: UIViewController, _ animated: Bool) -> () = { [weak self] (vc, animated) in
//            self?.setNavigationBarHidden(vc.isNavigationHidden, animated: animated)
//        }
//        appearingViewController.setInjectBlock(block)
//
//        if let disappearVC = self.viewControllers.last, disappearVC.injectBlock == nil {
//            disappearVC.setInjectBlock(block)
//        }
//    }
//}
