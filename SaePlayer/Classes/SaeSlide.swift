//
//  SaeSlide.swift
//  SaePlayerSample
//
//  Created by Jemesl on 2020/3/14.
//  Copyright © 2020 Jemesl. All rights reserved.
//

import Foundation
import UIKit
fileprivate let SLIDER_X_BOUND: CGFloat = 30
fileprivate let SLIDER_Y_BOUND: CGFloat = 40

open class SaeSlide: UISlider {
    
    fileprivate var lastBounds: CGRect = CGRect.zero
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SaeSlide {
    func setupViews() {
        maximumValue = 1.0
        minimumValue = 0.0
        value        = 0.0
        maximumTrackTintColor = UIColor.white.withAlphaComponent(0.2)
        minimumTrackTintColor = UIColor.white.withAlphaComponent(0.7)
        setThumbImage(UIImage.imageResourcePath("progress_point_hightlight"), for: .highlighted)
        setThumbImage(UIImage.imageResourcePath("progress_point_normal"), for: .normal)
    }
}

extension SaeSlide {
    override open func thumbRect(forBounds bounds: CGRect, trackRect rect: CGRect, value: Float) -> CGRect {
        let result = super.thumbRect(forBounds: bounds, trackRect: rect, value: value)
        //记录下最终的frame
        lastBounds = result
        return result
    }
    
    override open func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let result = super.hitTest(point, with: event)
        if result != self {
            if point.y >= 15 && point.y < (lastBounds.size.height + SLIDER_Y_BOUND) && point.x >= 0 && point.x < bounds.width {
                return self
            }
        }
        return result
    }

    override open func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        var result = super.point(inside: point, with: event)
        if !result {
            if point.x >= (lastBounds.origin.x - SLIDER_X_BOUND) &&  point.x <= lastBounds.origin.x + lastBounds.size.width + SLIDER_X_BOUND {
                result = true
            }
        }
        return result
    }
}

