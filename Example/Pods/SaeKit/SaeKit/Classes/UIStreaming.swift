//
//  UIStreaming.swift
//  Pods
//
//  Created by Jemesl on 2019/11/10.
//

import Foundation
import UIKit

public extension SaeSpace where Base: UIView {
    func streaming(subs subviews: [UIView]) -> UIStreaming {
        return UIStreaming(subs: subviews, superView: self.base)
    }
}

fileprivate enum Direction {
    case horizontal
    case vertical
}

fileprivate struct UIStreamingConfig {
    // 水平/垂直
    var direction: Direction?
    // 水平方向与父视图等宽
    var isFillHor: Bool = false
    // 水平方向与父视图等宽
//    var isFillHorAbsolute: Bool = false
    // 水平方向撑满 可能小于父视图的宽度
    var isLessFillHor: Bool = false
    // 垂直方向填满
    var isFillVer: Bool = false
    // 是否换行
    var isMul: Bool = false
    var lineCount: Int?
    // 等分
    //    var dividedCount: Int?
    var isEqualWidth: Bool = false
    var isEqualHeight: Bool = false
    var hMargin: CGFloat = 0
    var vMargin: CGFloat = 0
    var hasHeight: Bool = false
    var hasWidth: Bool = false
    var width: CGFloat?
    var height: CGFloat?
    var padding: UIEdgeInsets = UIEdgeInsets.zero
    var superWidth: CGFloat?
    
}

public class UIStreaming {
    var subs: [UIView] = []
    var superView: UIView?
    
    private var config = UIStreamingConfig()
    
    public var horizontal: UIStreaming {
        get {
            self.config.direction = .horizontal
            return self
        }
    }
    
    public var vertical: UIStreaming {
        get {
            self.config.direction = .vertical
            return self
        }
    }
    
    public var horizontalMul: UIStreaming {
        get {
            self.config.direction = .horizontal
            self.config.isMul = true
            return self
        }
    }
    
    public func horizontalMulWithCount(_ v: Int) -> UIStreaming {
        self.config.direction = .horizontal
        self.config.isMul = true
        self.config.lineCount = v
        return self
    }
    
    public func lineCount(_ count: Int) -> UIStreaming {
        if count > 0 {
            self.config.lineCount = count
        }
        return self
    }
    
    public var equalWidth: UIStreaming {
        get {
            self.config.isEqualWidth = true
            return self
        }
    }
    
    public var equalHeight: UIStreaming {
        get {
            self.config.isEqualHeight = true
            return self
        }
    }
    
    public var isFillHor: UIStreaming {
        get {
            config.isFillHor = true
            return self
        }
    }
    
    public var isLessFillHor: UIStreaming {
        get {
            config.isLessFillHor = true
            return self
        }
    }
    
    public var isFillVer: UIStreaming {
        get {
            config.isFillVer = true
            return self
        }
    }
    
    public func hMargin(_ h: CGFloat) -> UIStreaming {
        self.config.hMargin = h
        return self
    }
    
    public func vMargin(_ v: CGFloat) -> UIStreaming {
        self.config.vMargin = v
        return self
    }
    
    public var hasHeight: UIStreaming {
        self.config.hasHeight = true
        return self
    }
    
    public var hasWidth: UIStreaming {
        self.config.hasWidth = true
        return self
    }
    
    public func superWidth(_ v: CGFloat) -> UIStreaming {
        self.config.superWidth = v
        return self
    }
    
    public func width(_ w: CGFloat) -> UIStreaming {
        self.config.width = w
        return self
    }
    
    public func height(_ h: CGFloat) -> UIStreaming {
        self.config.height = h
        return self
    }
    
    public func padding(_ p: UIEdgeInsets) -> UIStreaming {
        self.config.padding = p
        return self
    }
    
    public func leftPadding(_ v: CGFloat) -> UIStreaming {
        var tmp = self.config.padding
        tmp.left = v
        self.config.padding = tmp
        return self
    }
    
    public func rightPadding(_ v: CGFloat) -> UIStreaming {
        var tmp = self.config.padding
        tmp.right = v
        self.config.padding = tmp
        return self
    }
    
    public func topPadding(_ v: CGFloat) -> UIStreaming {
        var tmp = self.config.padding
        tmp.top = v
        self.config.padding = tmp
        return self
    }
    
    public func bottomPadding(_ v: CGFloat) -> UIStreaming {
        var tmp = self.config.padding
        tmp.bottom = v
        self.config.padding = tmp
        return self
    }
    
    public func makeConstraints() {
        guard let direction = config.direction else { return }
        if direction == .vertical {
            makeVerticalConstraints()
            return
        }
        if direction == .horizontal && config.isMul && config.lineCount != nil {
            makeMulLineWithCountHorizontalConstraints()
            return
        }
        if direction == .horizontal && config.isMul {
            makeMulLineHorizontalConstraints()
            return
        }
        if direction == .horizontal {
            makeHorizontalConstraints()
            return
        }
    }
    
    init(subs: [UIView], superView: UIView) {
        self.subs = subs
        self.superView = superView
    }
}

extension UIStreaming {
    private func makeVerticalConstraints() {
        guard let superView = superView else { return }
        guard let firstView = subs.first else { return }
        var lastView = superView
        let count = subs.count
        for (index, view) in subs.enumerated() {
            superView.addSubview(view)
            view.consLeft(config.padding.left)
            if let width = config.width {
                view.consWidth(width)
            } else if config.hasWidth {
                view.consWidth(view.width)
            }
            if config.isFillHor {
                view.consRight(-config.padding.right)
            } else if config.isLessFillHor {
                view.consRight(-config.padding.right, relatedBy: .lessThanOrEqual)
            }
            
            if let height = config.height {
                view.consHeight(height)
            } else if config.hasHeight {
                view.consHeight(view.height)
            } else if config.isEqualHeight {
                if index > 0 {
                    view.consHeight(0, toItem: firstView, destAttri: .height)
                }
            }
            if index == 0 {
                view.consTop(config.padding.top)
            } else {
                view.consTop(config.vMargin, toItem: lastView, destAttri: .bottom, priority: .defaultHigh)
            }
            if config.isFillVer, index == count - 1 {
                view.consBottom(-config.padding.bottom)
            }
            lastView = view
        }
    }
    
    private func makeHorizontalConstraints() {
        guard let superView = superView else { return }
        var lastView = superView
        let count = subs.count
        
        for (index, view) in subs.enumerated() {
            superView.addSubview(view)
            view.consTop(0)
            if let width = config.width {
                view.consWidth(width)
            } else if config.hasWidth {
                view.consWidth(view.width)
            } else if config.isEqualWidth {
                if index > 0 {
                    view.consWidth(0, toItem: lastView, destAttri: .width)
                }
            }
            if config.isFillHor, index == count - 1 {
                view.consRight(-config.padding.right)
            } else if config.isLessFillHor, index == count - 1 {
                view.consRight(-config.padding.right, relatedBy: .lessThanOrEqual)
            }
            
            if let height = config.height {
                view.consHeight(height)
            } else if config.hasHeight {
                view.consHeight(view.height)
            }
            if config.isFillVer {
                view.consBottom(-config.padding.bottom, relatedBy: .lessThanOrEqual)
            }
            
            if index == 0 {
                view.consLeft(config.padding.left)
            } else {
                view.consLeft(config.hMargin, toItem: lastView, destAttri: .right)
            }
            lastView = view
        }
    }
    
    // 换行: 父视图有宽度, 元素高度必须一致
    private func makeMulLineHorizontalConstraints() {
        guard let superView = superView else { return }
        let count = subs.count
        var left: CGFloat = config.padding.left
        var widthMax: CGFloat = 0
        var lastLine = superView
        if let superWidth = config.superWidth {
            widthMax = superWidth
        } else {
            widthMax = superView.width
        }
        if widthMax == 0 { return }
        // 当前行数
        var curLineCount = 1
        for (index, view) in subs.enumerated() {
            superView.addSubview(view)
            
            let curViewWidth = getCurViewWidth(v: view)
            let curViewHeight = getCurViewHeight(v: view)
            
            if left + view.width > widthMax {
                // 换行
                left = config.padding.left
                curLineCount += 1
                if (index - 1) >= 0 {
                    lastLine = subs[index - 1]
                }
            }
            view.consWidth(curViewWidth)
            if curViewHeight != 0 {
                view.consHeight(curViewHeight)
            }
            if curLineCount == 1 {
                view.consTop(config.padding.top)
            } else {
                view.consTop(config.vMargin, toItem: lastLine, destAttri: .bottom)
            }
            view.consLeft(left)
            left += config.hMargin + curViewWidth
            if config.isFillVer, index == (count - 1) {
                view.consBottom(-config.padding.bottom)
            }
        }
    }
    
    // 水平换行并且可以限制个数(基本就是等宽的 不支持 haswidth属性)
    // 父视图有宽度 则等分
    // 父视图没有宽度, 则通过width()来设置(等宽) 再设置 isFillHor
    private func makeMulLineWithCountHorizontalConstraints() {
        guard let superView = superView else { return }
        var lastLine = superView
        var lineCount: Int = 0
        if let lc = config.lineCount {
            lineCount = lc
        }
        let count = subs.count
        for (index, view) in subs.enumerated() {
            superView.addSubview(view)
            let curViewWidth = getCurViewWidth(v: view)
            let curViewHeight = getCurViewHeight(v: view)
            
            let col: Int = index % lineCount
            if index < lineCount {
                view.consTop(config.padding.top)
            } else {
                view.consTop(config.vMargin, toItem: lastLine, destAttri: .bottom)
            }
            
            if config.isEqualWidth {// 等分
                let widthOffset: CGFloat = (config.padding.left + config.padding.right + 2 * config.hMargin) / CGFloat(lineCount)
                view.consWidth(-widthOffset, toItem: superView, destAttri: .width, dividedBy: CGFloat(lineCount))
            } else if curViewWidth != 0 {
                view.consWidth(curViewWidth)
            }
            
            if curViewHeight != 0 {
                view.consHeight(curViewHeight)
            }

            if col == 0 {
                view.consLeft(config.padding.left)
            } else if (index - 1) >= 0 {
                let leftView = subs[index - 1]
                view.consLeft(config.hMargin, toItem: leftView, destAttri: .right)
            }
            
            let isLastCol = col == (lineCount - 1)
            if config.isFillHor && isLastCol {
                view.consRight(-config.padding.right)
            }
            
            if config.isFillVer, index == count - 1 {
                view.consBottom(-config.padding.bottom)
            }
            col == lineCount - 1 ? lastLine = view : nil
        }
    }
    
    // 换行: 父视图有宽度, 添加一层bg
    private func makeMulLineHorizontalConstraints2() {
        // TODO
    }
    
    private func getCurViewWidth(v: UIView) -> CGFloat {
        if let width = config.width {
            return width
        } else if config.hasWidth {
            return v.width
        }
        return 0
    }
    
    private func getCurViewHeight(v: UIView) -> CGFloat {
        if let height = config.height {
            return height
        } else if config.hasHeight {
            return v.height
        }
        return 0
    }
}

