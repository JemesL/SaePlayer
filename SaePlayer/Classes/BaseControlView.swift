//
//  BaseControlView.swift
//  SaePlayerSample
//
//  Created by Jemesl on 2020/3/14.
//  Copyright © 2020 Jemesl. All rights reserved.
//

import Foundation
import UIKit

// 基础控制视图, 主要提供一些基础计算
open class BaseControlView: UIView {
    fileprivate let edge = UIEdgeInsets(top: 15, left: LEFT_RIGHT_MARGIN, bottom: 15, right: LEFT_RIGHT_MARGIN)
//    weak var delegate: SaePlayerLayerProtocol? = nil
    public weak var delegate: PlayControlDelegate? = nil
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BaseControlView {
    public func formatSecondsToString(_ seconds: TimeInterval) -> String {
        if seconds.isNaN {
            return "00:00"
        }
        let min = Int(seconds / 60)
        let sec = Int(seconds.truncatingRemainder(dividingBy: 60))
        return String(format: "%02d:%02d", min, sec)
    }
}
