//
//  SpaceTest.swift
//  SaePlayer_Example
//
//  Created by Jemesl on 2020/4/10.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
//import SaeKit

public protocol SaeSpacable {
    associatedtype CompatibleType
    static var saeplayer: SaeSpace<CompatibleType>.Type { get }
    var saeplayer: SaeSpace<CompatibleType> { get }
}

extension SaeSpacable {
    public static var saeplayer: SaeSpace<Self>.Type {
        get {
            return SaeSpace<Self>.self
        }
    }
    public var saeplayer: SaeSpace<Self> {
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


public extension SaeSpace where Base: UITableView {
    func haha() {
        print("hha")
    }
}
