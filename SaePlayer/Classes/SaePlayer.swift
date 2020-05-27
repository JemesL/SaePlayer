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
import SaeKit

let LEFT_RIGHT_MARGIN: CGFloat = 15

public protocol SaePlayerDelegate: class {
    func saeplayer(player: SaePlayer, status: PlayStatus)
}

extension SaePlayerDelegate {
    func saeplayer(player: SaePlayer, status: PlayStatus) {}
}

open class SaePlayer: UIView {
    fileprivate let edge = UIEdgeInsets(top: 15, left: LEFT_RIGHT_MARGIN, bottom: 15, right: LEFT_RIGHT_MARGIN)
    
    public typealias ControlType = BaseControlView & PlayControlProtocol
    // 控制器视图
    fileprivate var controlView: ControlType!
    // 视频内容视图
    fileprivate var layerView: SaePlayerLayer!
    
    // 代理
    public weak var delegate: SaePlayerDelegate? = nil
    
    public init(custom: ControlType? = nil) {
        super.init(frame: CGRect.zero)
        if let control = custom {
            self.controlView = control
        } else {
            self.controlView = ControlView()
        }
        setupViews()
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
        // 释放 layer
        layerView.clean()
    }
}

// 一些actions
extension SaePlayer {
    public func setData(url: String, cover: String, defaultCover: String) {
        
        self.controlView.setCoverUrl(cover, default: defaultCover)
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
        
        controlView.delegate = self
        layerView.delegate = self
        
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

extension SaePlayer: PlayerlayerDelegate {
    
    public func saeLayer(layer: SaePlayerLayer, playerStateDidChange state: PlayStatus) {
        controlView.setPlayStatus(state)
        delegate?.saeplayer(player: self, status: state)
    }
    
    public func saeLayer(layer: SaePlayerLayer, loadedTimeDidChange loadedDuration: TimeInterval, totalDuration: TimeInterval) {
//        controlView.setCurrentTime(loadedDuration)
//        controlView.setTotalTime(totalDuration)
    }
    
    public func saeLayer(layer: SaePlayerLayer, playTimeDidChange currentTime: TimeInterval, totalTime: TimeInterval) {
        controlView.setCurrentTime(currentTime)
        controlView.setTotalTime(totalTime)
    }
    
    public func saeLayer(layer: SaePlayerLayer, playerIsPlaying playing: Bool) {
        
    }
    
}

extension SaePlayer: PlayControlDelegate {
    public func controlViewPanGesture(controlView: PlayControlProtocol, pan: UIPanGestureRecognizer) {
        switch pan.state {
        case .began:
            layerView.autoRepeat(false)
            break
        case .ended:
            layerView.autoRepeat(true)
            break
        default:
            break
        }
    }
    
    public func controlView(controlView: PlayControlProtocol, didChooseDefinition index: Int) {
        
    }
    
    public func controlView(controlView: PlayControlProtocol, didPressButton button: UIButton) {
        
    }
    
    public func controlView(controlView: PlayControlProtocol, slider: UISlider, onSliderEvent event: UIControl.Event) {
        
    }
    
    public func controlView(controlView: PlayControlProtocol, didChangeVideoPlaybackRate rate: Float) {
        
    }
    
    // 等同用户暂停
    public func controlViewPause(controlView: PlayControlProtocol) {
        layerView.pause(isUser: true)
    }
    
    public func controlViewPlay(controlView: PlayControlProtocol) {
        layerView.play()
    }
    
    public func controlViewSeek(controlView: PlayControlProtocol, toTime time: TimeInterval) {
        layerView.seekTo(time)
    }
}
