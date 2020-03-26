//
//  KVOEnhance.swift
//  Pods
//
//  Created by Jemesl on 2019/11/10.
//

import Foundation

fileprivate struct AssociatedKeys {
    static var handleListKeyOfKVO: String = "HandleListKeyOfKVO"
}

public protocol KVOEnhanceProtocol {
    
    var handleListOfKVO: [NSKeyValueObservation] { get }
    
    func addKVOHandle(handle: NSKeyValueObservation)
}

public extension KVOEnhanceProtocol {
    var handleListOfKVO: [NSKeyValueObservation] {
        get {
            if let list: [NSKeyValueObservation] = objc_getAssociatedObject(self, &AssociatedKeys.handleListKeyOfKVO) as? [NSKeyValueObservation] {
                return list
            }
            return []
        }
    }
    
    func addKVOHandle(handle: NSKeyValueObservation) {
        var list = handleListOfKVO
        list.append(handle)
        objc_setAssociatedObject(self, &AssociatedKeys.handleListKeyOfKVO, list, .OBJC_ASSOCIATION_RETAIN)
    }
}

extension NSObject: KVOEnhanceProtocol {}

public extension SaeSpace where Base: NSObject {
    
    func observe<Value>(_ keyPath: KeyPath<Base, Value>, options: NSKeyValueObservingOptions, changeHandler: @escaping (Base, NSKeyValueObservedChange<Value>) -> Void) {
        let handle = self.base.observe(keyPath, options: options, changeHandler: changeHandler)
        self.base.addKVOHandle(handle: handle)
    }
}



