//
//  STAT.swift
//  Pods
//
//  Created by Jemesl on 2019/11/10.
//

import Foundation
import UIKit
fileprivate struct AssociatedKeys {
    static var statKey: String = "StatKey"
}

public extension SaeSpace where Base: UIView {
    
    func setStatBlock<E>(defaultValue: E, block: @escaping (Base, E) -> ()) {
        typealias STATBE = STAT<Base, E>
        let stat = STATBE(e: defaultValue, block: block)
        objc_setAssociatedObject(self.base, &AssociatedKeys.statKey, stat, .OBJC_ASSOCIATION_RETAIN)
        
        block(self.base, defaultValue)
    }
    
    func setStat<E>(e: E) {
        typealias STATBE = STAT<Base, E>
        if var stat = objc_getAssociatedObject(self.base, &AssociatedKeys.statKey) as? STATBE {
            stat.block?(self.base, e)
            stat.e = e
            objc_setAssociatedObject(self.base, &AssociatedKeys.statKey, stat, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    func getStat<E>() -> E? {
        if let statBlock = objc_getAssociatedObject(self.base, &AssociatedKeys.statKey) as? STAT<Base, E> {
            return statBlock.e
        }
        return nil
    }
}

public struct STAT<Base, E> {
    typealias STATBLOCK = (Base, E) -> ()
    
    var block: STATBLOCK?
    var e: E?
    init(e: E?, block: STATBLOCK?) {
        self.block = block
        self.e = e
    }
}

