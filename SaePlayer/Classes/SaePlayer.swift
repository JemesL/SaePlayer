//
//  SaePlayer.swift
//  SaePlayerSample
//
//  Created by Jemesl on 2020/3/11.
//  Copyright © 2020 Jemesl. All rights reserved.
//

import Foundation
import UIKit
import AVKit
import Kingfisher
import SaeKit

let LEFT_RIGHT_MARGIN: CGFloat = 15

open class SaePlayer: UIView {
    fileprivate let edge = UIEdgeInsets(top: 15, left: LEFT_RIGHT_MARGIN, bottom: 15, right: LEFT_RIGHT_MARGIN)
    
    
    public typealias ControlType = BaseControlView & PlayControlProtocol
    // 控制器视图
    fileprivate var controlView: ControlType!
    // 视频内容视图
    fileprivate var layerView: SaePlayerLayer!
    
    public init(custom: ControlType? = nil) {
        super.init(frame: CGRect.zero)
        if let control = custom {
            self.controlView = control
        } else {
            self.controlView = ControlView()
        }
        setupViews()
        let formatHash = String(format: "%12d", self.hash)
        print("hash: \(formatHash) ->   init: \(self.className)")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.controlView = ControlView()
        setupViews()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        let formatHash = String(format: "% 12d", self.hash)
        print("hash: \(formatHash) -> deinit: \(self.className)")
        // 释放 layer
        layerView.clean()
    }
}

// 一些actions
extension SaePlayer {
    public func setData(url: String, cover: String) {
        
        self.controlView.setCoverUrl(cover)
        self.layerView.setData(url: url, cover: cover)
    }
    
    public func resetControlView() {
        controlView.resetControl()
    }
}

// 布局
extension SaePlayer {
    
    func setupViews() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        
        layerView = SaePlayerLayer()
        
        controlView.delegate = layerView
        layerView.delegate = controlView
        
        addSubview(layerView)
        addSubview(controlView)
        layerView.consEdge(UIEdgeInsets.zero)
        controlView.consEdge(UIEdgeInsets.zero)
    }
}

// 外界调用SaePlayer的方法
extension SaePlayer {

    public func play() {
        layerView.play()
    }

    public func pause() {
        layerView.pause()
    }
}
