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
    // 相关一些配置
    public struct Config {
        // 视频全屏时 内容显示模式
        var gravityInFullScreen: AVLayerVideoGravity = .resizeAspectFill
        // 视频在原视图时 内容显示模式
        var gravityInOriginScreen: AVLayerVideoGravity = .resizeAspectFill
        // 视频尺寸
        var videoSize: CGSize? = nil
    }
    
    fileprivate let edge = UIEdgeInsets(top: 15, left: LEFT_RIGHT_MARGIN, bottom: 15, right: LEFT_RIGHT_MARGIN)
    
    public typealias ControlType = BaseControlView & PlayControlProtocol
    // 控制器视图
    fileprivate var controlView: ControlType!
    // 视频内容视图
    fileprivate var layerView: SaePlayerLayer!
    
    // 控制器和视频展示视频的父视图, 方便进入全屏
    fileprivate var bg: UIView!
    
    // 代理
    public weak var delegate: SaePlayerDelegate? = nil
    
    public var config: Config? = nil
    public init(custom: ControlType? = nil, config: Config? = nil) {
        super.init(frame: CGRect.zero)
        self.controlView = custom ?? ControlView()
        self.config = config ?? Config()
        setupViews()
    }
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        self.controlView = ControlView()
//        setupViews()
//    }

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
        
        bg = UIView()
        bg.backgroundColor = .clear
        layerView = SaePlayerLayer()
        controlView.delegate = self
        layerView.delegate = self
        
        addSubview(bg)
        bg.addSubview(layerView)
        bg.addSubview(controlView)
        layerView.consEdge(UIEdgeInsets.zero)
        controlView.consEdge(UIEdgeInsets.zero)
        
        bg.consEdge(UIEdgeInsets.zero)
        
    }
    
    func isFullScreenlandscape() -> Bool {
        guard let size = config?.videoSize else { return false }
        return size.width > size.height
    }
    
    // 进入全屏 landscape: 横屏
    func enterFullView(landscape: Bool = false) {
        guard let config = config else { return }
        guard let keyWindow = UIWindow.getKeyWindow() else { return }
        // 计算 视频视频在 window 上的 frame
        let rectInWindow = self.convert(self.bounds, to: keyWindow)
        // 从父视图移除, 删除约束
        bg.removeFromSuperview()
        bg.removeCons()
        // 添加到 keywindow, 重新布局
        keyWindow.addSubview(bg)
        bg.consTop(rectInWindow.minY)
        bg.consLeft(rectInWindow.minX)
        bg.consWidth(rectInWindow.width)
        bg.consHeight(rectInWindow.height)
        keyWindow.layoutIfNeeded()
        // 设置全屏时的显示样式
        layerView.setFullScreenStyle(gravity: config.gravityInFullScreen)
        // 隐藏状态栏
        UIApplication.shared.keyWindow?.windowLevel = .statusBar
        // 动画
        UIView.animate(withDuration: 0.2) {
            self.bg.removeCons()
            if landscape { // 全屏模式为横屏时的最终布局
                // 横屏旋转90度, 宽高约束对调
                self.bg.transform = self.bg.transform.rotated(by: .pi / 2)
                self.bg.consSuperCenterX()
                self.bg.consSuperCenterY()
                self.bg.consWidth(0, toItem: keyWindow, destAttri: .height)
                self.bg.consHeight(0, toItem: keyWindow, destAttri: .width)
            } else { // 全屏模式为竖屏时的最终布局
                self.bg.consEdge(UIEdgeInsets.zero)
            }
            keyWindow.layoutIfNeeded()
        } completion: { sss in
            
        }
    }
    
    // 退出全屏 landscape: 横屏
    func exitFullView(landscape: Bool = false) {
        guard let config = config else { return }
        guard let keyWindow = UIWindow.getKeyWindow() else { return }
        // 计算 视频视频在 window 上的 frame
        let rectInWindow = self.convert(self.bounds, to: keyWindow)
        // 设置全屏时的显示样式
        layerView.setFullScreenStyle(gravity: config.gravityInOriginScreen)
        // 显示状态栏
        UIApplication.shared.keyWindow?.windowLevel = .normal
        // 动画
        UIView.animate(withDuration: 0.2) {
            if landscape { // 当前为横屏时, 逆90度转回来
                self.bg.transform = self.bg.transform.rotated(by: -.pi / 2)
            }
            // 重新布局为全屏前的尺寸大小
            self.bg.removeCons()
            self.bg.consTop(rectInWindow.minY)
            self.bg.consLeft(rectInWindow.minX)
            self.bg.consWidth(rectInWindow.width)
            self.bg.consHeight(rectInWindow.height)
            keyWindow.layoutIfNeeded()
        } completion: { sss in
            // 动画结束后, 把视频层放回原父视图, 重新布局
            self.bg.removeFromSuperview()
            self.bg.removeCons()
            self.addSubview(self.bg)
            self.bg.consEdge(UIEdgeInsets.zero)
        }
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
    
    public func saeLayer(layer: SaePlayerLayer, seekIsCompleted: Bool) {
        controlView.setSeekStatus(isCompleted: seekIsCompleted)
    }
    
    public func saeLayer(layer: SaePlayerLayer, item: AVPlayerItem, newRanges loadedTimeRanges: [NSValue]) {
        controlView.setLoadedTimeRanges(range: loadedTimeRanges)
    }
    
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
    
    public func saeLayer(layer: SaePlayerLayer, videoSize: CGSize) {
        config?.videoSize = videoSize
    }
    
}

extension SaePlayer: PlayControlDelegate {
    
    public func controlView(controlView: PlayControlProtocol, fullScreen: Bool) {
        if fullScreen {
            // 进入全屏
            enterFullView(landscape: isFullScreenlandscape())
        } else {
            // 退出全屏
            exitFullView(landscape: isFullScreenlandscape())
        }
    }
    
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
