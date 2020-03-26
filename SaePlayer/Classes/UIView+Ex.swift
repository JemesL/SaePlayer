//
//  UIView+Ex.swift
//  SaePlayerSample
//
//  Created by Jemesl on 2020/3/11.
//  Copyright © 2020 Jemesl. All rights reserved.
//

import Foundation
import UIKit
// MARK: - 基础frame相关属性
extension UIView {
    var width: CGFloat {
        get {
            return self.bounds.size.width
        }
        set(width) {
            self.frame.size = CGSize(width: width, height: self.frame.height)
        }
    }
    
    var height: CGFloat {
        get {
            return self.bounds.size.height
        }
        set(height) {
            self.frame.size = CGSize(width: self.frame.width, height: height)
        }
    }
    
    var origin: CGPoint {
        get {
            return self.frame.origin
        }
        set(origin) {
            self.frame.origin = origin
        }
    }
    
    var size: CGSize {
        get {
            return self.frame.size
        }
        set(size) {
            self.frame.size = size
        }
    }
    
    var centerX: CGFloat {
        get {
            return self.center.x
        }
        set(centerX) {
            self.center = CGPoint(x: centerX, y: self.center.y)
        }
    }
    
    var centerY: CGFloat {
        get {
            return self.center.y
        }
        set(centerY) {
            self.center = CGPoint(x: self.center.x, y: centerY)
        }
    }
    
    var left: CGFloat {
        get {
            return self.frame.origin.x
        }
        set(x) {
            self.frame = CGRect(x: x, y: self.frame.origin.y, width: self.width, height: self.height)
        }
    }
    
    var right: CGFloat {
        get {
            return self.frame.origin.x + self.width
        }
        set(right) {
            self.frame = CGRect(x: right - self.width, y: self.frame.origin.y, width: self.width, height: self.height)
        }
    }
    
    var top: CGFloat {
        get {
            return self.frame.origin.y
        }
        set(y) {
            self.frame = CGRect(x: self.frame.origin.x, y: y, width: self.width, height: self.height)
        }
    }
    
    var bottom: CGFloat {
        get {
            return self.frame.origin.y + self.height
        }
        set(bottom) {
            self.frame = CGRect(x: self.frame.origin.x, y: bottom - self.height, width: self.width, height: self.height)
        }
    }
}


// MARK: - 约束
public extension UIView {
    
    func consWidth(_ width: CGFloat) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: width))
    }
    
    func consWidth(_ margin: CGFloat, toItem: UIView? = nil, destAttri: NSLayoutConstraint.Attribute? = nil, dividedBy: CGFloat = 1, relatedBy: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required) {
        consSide(margin, toItem: toItem, attribute: .width, destAttri: destAttri ?? .width, dividedBy: dividedBy, relatedBy: relatedBy, priority: priority)
    }
    
    func consHeight(_ height: CGFloat) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: height))
    }
    
    func consHeight(_ margin: CGFloat, toItem: UIView? = nil, destAttri: NSLayoutConstraint.Attribute? = nil, dividedBy: CGFloat = 1, relatedBy: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required) {
        consSide(margin, toItem: toItem, attribute: .height, destAttri: destAttri ?? .height, dividedBy: dividedBy, relatedBy: relatedBy, priority: priority)
    }
    
    func consTop(_ margin: CGFloat, toItem: UIView? = nil, destAttri: NSLayoutConstraint.Attribute? = nil, dividedBy: CGFloat = 1, relatedBy: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required) {
        consSide(margin, toItem: toItem, attribute: .top, destAttri: destAttri ?? .top, dividedBy: dividedBy, relatedBy: relatedBy, priority: priority)
    }
    
    func consLeft(_ margin: CGFloat, toItem: UIView? = nil, destAttri: NSLayoutConstraint.Attribute? = nil, dividedBy: CGFloat = 1, relatedBy: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required) {
        consSide(margin, toItem: toItem, attribute: .left, destAttri: destAttri ?? .left, dividedBy: dividedBy, relatedBy: relatedBy, priority: priority)
    }

    func consRight(_ margin: CGFloat, toItem: UIView? = nil, destAttri: NSLayoutConstraint.Attribute? = nil, dividedBy: CGFloat = 1, relatedBy: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required) {
        consSide(margin, toItem: toItem, attribute: .right, destAttri: destAttri ?? .right, dividedBy: dividedBy, relatedBy: relatedBy, priority: priority)
    }

    func consBottom(_ margin: CGFloat, toItem: UIView? = nil, destAttri: NSLayoutConstraint.Attribute? = nil, dividedBy: CGFloat = 1, relatedBy: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required) {
        consSide(margin, toItem: toItem, attribute: .bottom, destAttri: destAttri ?? .bottom, dividedBy: dividedBy, relatedBy: relatedBy, priority: priority)
    }
    
    func consSuperCenterY() {
        consCenterY(destAttri: .centerY)
    }
    
    func consCenterY(_ margin: CGFloat = 0, toItem: UIView? = nil, destAttri: NSLayoutConstraint.Attribute? = nil, dividedBy: CGFloat = 1, relatedBy: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required) {
        consSide(margin, toItem: toItem, attribute: .centerY, destAttri: destAttri ?? .bottom, dividedBy: dividedBy, relatedBy: relatedBy, priority: priority)
    }
    
    func consSuperCenterX() {
        consCenterX(destAttri: .centerX)
    }
    
    func consCenterX(_ margin: CGFloat = 0, toItem: UIView? = nil, destAttri: NSLayoutConstraint.Attribute? = nil, dividedBy: CGFloat = 1, relatedBy: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required) {
        consSide(margin, toItem: toItem, attribute: .centerX, destAttri: destAttri ?? .bottom, dividedBy: dividedBy, relatedBy: relatedBy, priority: priority)
    }
    
    func consSide(_ margin: CGFloat, toItem: UIView? = nil, attribute: NSLayoutConstraint.Attribute, destAttri: NSLayoutConstraint.Attribute, dividedBy: CGFloat = 1, relatedBy: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required) {
        let _ = getConsSide(margin, toItem: toItem, attribute: attribute, destAttri: destAttri, dividedBy: dividedBy, relatedBy: relatedBy, priority: priority)
    }
    
    func getConsSide(_ margin: CGFloat, toItem: UIView? = nil, attribute: NSLayoutConstraint.Attribute, destAttri: NSLayoutConstraint.Attribute, dividedBy: CGFloat = 1, relatedBy: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required) -> NSLayoutConstraint? {
        self.translatesAutoresizingMaskIntoConstraints = false
        if let superView = superview {
            let cons = NSLayoutConstraint(item: self, attribute: attribute, relatedBy: relatedBy, toItem: toItem ?? superView, attribute: destAttri, multiplier: 1 / dividedBy, constant: margin)
            cons.priority = priority
            superView.addConstraint(cons)
            return cons
        }
        return nil
    }
    
    func getConsWidth (_ width: CGFloat) -> NSLayoutConstraint? {
        self.translatesAutoresizingMaskIntoConstraints = false
        let cons = NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: width)
        self.addConstraint(cons)
        return cons
    }
    
    func getConsWidth(_ margin: CGFloat, toItem: UIView? = nil, destAttri: NSLayoutConstraint.Attribute? = nil, dividedBy: CGFloat = 1, relatedBy: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required) -> NSLayoutConstraint? {
        return getConsSide(margin, toItem: toItem, attribute: .width, destAttri: destAttri ?? .width, dividedBy: dividedBy, relatedBy: relatedBy, priority: priority)
    }
    
    func consEdge(_ edge: UIEdgeInsets) {
        consTop(edge.top)
        consLeft(edge.left)
        consRight(-edge.right)
        consBottom(-edge.bottom)
    }
}

class BaseView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        let formatHash = String(format: "%12d", self.hash)
        print("hash: \(formatHash) ->   init: \(self.className)")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        let formatHash = String(format: "% 12d", self.hash)
        print("hash: \(formatHash) -> deinit: \(self.className)")
    }
}
