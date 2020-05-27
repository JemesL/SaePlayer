//
//  ControlView.swift
//  SaePlayerSample
//
//  Created by Jemesl on 2020/3/14.
//  Copyright © 2020 Jemesl. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

// 播放器的状态
public enum PlayStatus {
    // 准备播放
    case readyToPlay
    // 正在播放
    case playing
    // 暂停
    case pause
    // 用户手动暂停
    case userPause
    // 缓冲
    case buffering
    // 缓冲结束
    case bufferFinished
    // 播放结束
    case playedToTheEnd
    // 播放结束
    case ended
    //
    case none
}

// 用于外部调用 更新/获取 control 状态的协议
// 自己遵守 外部传入调用
public protocol PlayControlProtocol: class {
    // 获取当前时间
    func getCurrentTime()
    // 设置当前播放状态
    func setPlayStatus(_ status: PlayStatus)
    // 设置当前的时间
    func setCurrentTime(_ cur: TimeInterval)
    // 设置总的时间
    func setTotalTime(_ total: TimeInterval)
    // 重置某些设置
    func resetControl()
    // 设置封面
    func setCoverUrl(_ url: String, default: String)
}

// 他人遵守, 接受控制面板的各种事件
public protocol PlayControlDelegate: class {
    
    // call when control view choose a definition
    func controlView(controlView: PlayControlProtocol, didChooseDefinition index: Int)
    
    // call when control view pressed an button
    func controlView(controlView: PlayControlProtocol, didPressButton button: UIButton)
    
    // call when slider action trigged
    func controlView(controlView: PlayControlProtocol, slider: UISlider, onSliderEvent event: UIControl.Event)
    
    // call when needs to change playback rate
    func controlView(controlView: PlayControlProtocol, didChangeVideoPlaybackRate rate: Float)
    
    
    func controlViewPause(controlView: PlayControlProtocol)
    
    func controlViewPlay(controlView: PlayControlProtocol)
    
    func controlViewSeek(controlView: PlayControlProtocol, toTime: TimeInterval)
    
    func controlViewPanGesture(controlView: PlayControlProtocol, pan: UIPanGestureRecognizer)
}

// ControlView 通过 delegate 给 player
open class ControlView: BaseControlView {
    fileprivate let edge = UIEdgeInsets(top: 15, left: LEFT_RIGHT_MARGIN, bottom: 15, right: LEFT_RIGHT_MARGIN)
    
//    var delegate: SaePlayerLayerProtocol? = nil
    
    
    // 控制组件状态
    fileprivate var isSimple: Bool = true
    // 简版控制组件
    fileprivate var simpleView: UIView!
    // 进度条 - 简版
    fileprivate var progressTime: UIView!
    // 进度条的约束
    fileprivate var progressWidthCons: NSLayoutConstraint? = nil
    
    // 完整版控制组件
    fileprivate var fullView: UIView!
    // 滑动条 - 完整版
    fileprivate var slide: SaeSlide!
    // 时间 - 完整版
    fileprivate var time: UILabel!
    // 播放按钮 - 完整版
    fileprivate var playBtn: BaseButton!
    
    // 封面
    fileprivate var cover: UIImageView!
    // 封面连接
    fileprivate var url: String? = nil
    
    // 播放状态
    fileprivate var status: PlayStatus = .none
    fileprivate var isBuffering: Bool = false
    // 用户正在拖拽
    fileprivate var isDragSliding: Bool = false
    // 总的播放时间
    open var totalDuration: TimeInterval = 0
    // 当前的播放时间
    open var currentTime: TimeInterval = 0
    
    // 手势
    /// Gesture used to show / hide control view
    open var tapGesture: UITapGestureRecognizer!
    open var doubleTapGesture: UITapGestureRecognizer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("ControlView")
    }
}

extension ControlView: PlayControlProtocol {
    
    public func setCoverUrl(_ url: String, default defaultCover: String) {
        if url != self.url {
            self.cover.kf.setImage(with: URL(string: url), placeholder: UIImage(named: defaultCover))
            self.url = url
        }
    }
    
    public func resetControl() {
        switchControlView(isSimple: true)
    }
    
    
    public func setTotalTime(_ total: TimeInterval) {
        totalDuration = total
        updateTime()
        updateSlide()
        updateSimpleProgress()
    }
    
    public func getCurrentTime() {
        
    }
    
    public func setPlayStatus(_ status: PlayStatus) {
        self.status = status
//        print("status: \(status)")
        switch status {
        case .playing:
            coverHidden()
            playBtn.isSelected = true
            break
        case .pause:
            coverShow()
            playBtn.isSelected = false
            break
        case .ended:
            playBtn.isSelected = false
            break
        case .none:
            playBtn.isSelected = false
            break
        case .buffering:
            // loading 动画
            
            // 隐藏封面
            coverHidden()
            // 播放状态
            playBtn.isSelected = true
            break
        case .readyToPlay:
            break
        case .userPause:
            playBtn.isSelected = false
            break
        case .bufferFinished:
            break
        case .playedToTheEnd:
            break
        }
    }
    
    public func setCurrentTime(_ cur: TimeInterval) {
        currentTime = cur
        updateTime()
        updateSlide()
    }
    
    func updateSlide() {
        guard totalDuration > 0 && isDragSliding == false else { return }
        slide.value = Float(currentTime / totalDuration)
    }
    
    // 更新简版进度条
    func updateSimpleProgress() {
        guard totalDuration > 0 && isDragSliding == false else { return }
        let value = Float(currentTime / totalDuration)

        if let cons = progressWidthCons {
            cons.isActive = false
            progressTime.removeConstraint(cons)
        }
        progressWidthCons = progressTime.getConsWidth(0, toItem: nil, destAttri: .width, dividedBy: CGFloat(1 / value), relatedBy: .equal)
    }
    
    func updateTime() {
        let curText = formatSecondsToString(currentTime)
        let allText = formatSecondsToString(totalDuration)
        time.text = "\(curText) / \(allText)"
    }
    
    // 切换完整版和简版控制组件
    func switchControlView(isSimple: Bool) {
        self.isSimple = isSimple
        fullView.isHidden = isSimple
        simpleView.isHidden = !isSimple
    }
    
    // 重置控制组件的状态
    func resetInitStatus() {
        switchControlView(isSimple: true)
    }
    
    @objc open func onTapGestureTapped(_ gesture: UITapGestureRecognizer) {
//        if playerLastState == .playedToTheEnd {
//            return
//        }
//        controlViewAnimation(isShow: !isMaskShowing)
        isSimple = !isSimple
        switchControlView(isSimple: isSimple)
    }
    
    func coverShow() {
        cover.isHidden = false
        if self.cover.isHidden == false && cover.alpha == 1 {
            return
        }
        self.cover.isHidden = false
        UIView.animate(withDuration: 0.25, animations: { [weak self] in
            self?.cover.alpha = 1
        }) { isEnd in

        }
    }
    
    func coverHidden() {
//        cover.isHidden = true
//        print("cover isHidden: \(cover.isHidden)")
//        self.cover.isHidden = false
//        self.cover.alpha = 1

        if cover.isHidden == true && cover.alpha == 0 {
            return
        }
        UIView.animate(withDuration: 0.25, animations: { [weak self] in
            self?.cover.alpha = 0
        }) { isEnd in
        }
    }

}

extension ControlView {
    func setData() {
    }
    
    @objc func switchPlayerStatus() {
        playBtn.isSelected = !playBtn.isSelected
        if playBtn.isSelected {
            delegate?.controlViewPlay(controlView: self)
        } else {
            delegate?.controlViewPause(controlView: self)
        }
//        playBtn.isSelected ? delegate?.play() : delegate?.pause()
    }
    
    @objc func sliderTouchBegan(_ sender: UISlider) {
        isDragSliding = true
    }

    @objc func sliderValueChanged(_ sender: UISlider) {

    }

    @objc func sliderTouchEnded(_ sender: UISlider) {
        let currentTime = Double(sender.value) * totalDuration
//        delegate?.seekTo(currentTime)
        delegate?.controlViewSeek(controlView: self, toTime: currentTime)
        isDragSliding = false
    }
}

extension ControlView {
    func setupViews() {
        translatesAutoresizingMaskIntoConstraints = false
        
        cover = UIImageView()
        cover.contentMode = .scaleAspectFill
        cover.clipsToBounds = true
        cover.isHidden = false
        
        simpleView = getSimpleView()
        fullView = getFullView()
        
        addSubview(cover)
        addSubview(simpleView)
        addSubview(fullView)
        
        cover.consEdge(UIEdgeInsets.zero)
        simpleView.consEdge(UIEdgeInsets.zero)
        fullView.consEdge(UIEdgeInsets.zero)
        
        switchControlView(isSimple: true)
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTapGestureTapped(_:)))
        addGestureRecognizer(tapGesture)
    }
    
    func getSimpleView() -> UIView {
        let v = UIView()
        
        progressTime = UIView()
        progressTime.backgroundColor = .orange
        
        v.addSubview(progressTime)
        
        return v
    }
    
    func getFullView() -> UIView {
        let v = UIView()
        
        slide = SaeSlide()
        slide.addTarget(self, action: #selector(sliderTouchBegan(_:)), for: .valueChanged)
        slide.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .touchDown)
        slide.addTarget(self, action: #selector(sliderTouchEnded(_:)), for: [.touchUpInside, .touchCancel, .touchUpOutside])
        
        time = UILabel()
        time.textColor = .white
        time.font = .systemFont(ofSize: 12)
        time.text = "00:00|00:00"
        
        playBtn = BaseButton(type: .custom)
        playBtn.setImage(imageResourcePath("player_play"), for: .normal)
        playBtn.setImage(imageResourcePath("player_pause"), for: .selected)
        playBtn.addTarget(self, action: #selector(switchPlayerStatus), for: .touchUpInside)
        playBtn.clickEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        v.addSubview(playBtn)
        v.addSubview(slide)
        v.addSubview(time)
        return v
    }
    
    func setupConstraints() {
        playBtn.consLeft(10)
        playBtn.consBottom(-10)
        
        slide.consLeft(10, toItem: playBtn, destAttri: .right)
        slide.consCenterY(toItem: playBtn, destAttri: .centerY)

        time.consCenterY(toItem: slide, destAttri: .centerY)
        time.consLeft(10, toItem: slide, destAttri: .right)
        time.consRight(-10)
        
        progressTime.consLeft(0)
        progressTime.consBottom(0)
        progressTime.consHeight(2)
        progressWidthCons = progressTime.getConsWidth(0, toItem: nil, destAttri: .width, dividedBy: 100, relatedBy: .equal)
    }
}

func imageResourcePath(_ fileName: String) -> UIImage? {
    guard var bundleURL = Bundle(for: SaePlayer.self).resourceURL else { return  nil }
//    return UIImage(named: fileName, in: bundle, compatibleWith: nil)
    
//    let frameworkBundle = NSBundle(forClass: XDWebViewController.self)
    bundleURL.appendPathComponent("SaePlayer.bundle")
    let resourceBundle = Bundle(url: bundleURL)
//    let bundleURL = bundle.resourceURL?.URLByAppendingPathComponent("XDCoreLib.bundle")
//    let resourceBundle = NSBundle(URL: bundleURL!)
    return UIImage(named: fileName, in: resourceBundle, compatibleWith: nil)
}
