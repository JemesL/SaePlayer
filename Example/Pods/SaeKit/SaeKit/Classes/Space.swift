//
//  Space.swift
//  Pods
//
//  Created by Jemesl on 2019/11/10.
//

import Foundation
import UIKit

// ************************** sae 命名空间 **************************
public protocol SaeSpacable {
    associatedtype CompatibleType
    static var sae: SaeSpace<CompatibleType>.Type { get }
    var sae: SaeSpace<CompatibleType> { get }
}

extension SaeSpacable {
    public static var sae: SaeSpace<Self>.Type {
        get {
            return SaeSpace<Self>.self
        }
    }
    public var sae: SaeSpace<Self> {
        get {
            return SaeSpace(self)
        }
    }
}

public struct SaeSpace<Base> {
    public let base: Base
    
    public init(_ base: Base) {
        self.base = base
    }
}

extension NSObject: SaeSpacable {}

