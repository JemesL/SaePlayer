//
//  SaePlayerLayer.swift
//  SaePlayerSample
//
//  Created by Jemesl on 2020/3/23.
//  Copyright © 2020 Jemesl. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

// 视频内容 代理
public protocol SaePlayerLayerProtocol: class {
    // 暂停
    func pause(isUser: Bool)
    // 播放
    func play()
    // 跳转
    func seekTo(_ time: TimeInterval)
    // 开启关闭自动循环播放
    func autoRepeat(_ isAuto: Bool)
}

// 他人遵守, 接受视频层的各种事件
public protocol PlayerlayerDelegate: class {
    func saeLayer(layer: SaePlayerLayer, playerStateDidChange state: PlayStatus)
    func saeLayer(layer: SaePlayerLayer, loadedTimeDidChange loadedDuration: TimeInterval, totalDuration: TimeInterval)
    func saeLayer(layer: SaePlayerLayer, item: AVPlayerItem, newRanges loadedTimeRanges: [NSValue])
    func saeLayer(layer: SaePlayerLayer, playTimeDidChange currentTime: TimeInterval, totalTime: TimeInterval)
    func saeLayer(layer: SaePlayerLayer, playerIsPlaying playing: Bool)
    func saeLayer(layer: SaePlayerLayer, videoSize: CGSize)
    func saeLayer(layer: SaePlayerLayer, seekIsCompleted: Bool)
}

open class CustomPlayer: AVPlayer {
    public override init() {
        super.init()
        let formatHash = String(format: "%12d", self.hash)
        print("hash: \(formatHash) ->   init: \(self.className)")
    }
    
    deinit {
        let formatHash = String(format: "% 12d", self.hash)
        print("hash: \(formatHash) -> deinit: \(self.className)")
    }
}

open class SaePlayerLayer: UIView {
    fileprivate let edge = UIEdgeInsets(top: 15, left: LEFT_RIGHT_MARGIN, bottom: 15, right: LEFT_RIGHT_MARGIN)
    
    var player: CustomPlayer? = nil
    var playerItem: AVPlayerItem? = nil
    var playerLayer: AVPlayerLayer? = nil
    fileprivate var periodicTimeObserver: Any? = nil
    fileprivate var needChangeItem: Bool = false
    var autoRepeat: Bool =  true
    
    // 封面
    var cover: UIImageView!
    var url: String? = nil
    
//    weak var delegate: PlayControlProtocol? = nil
    weak var delegate: PlayerlayerDelegate? = nil
    
    // 逻辑播放状态(只有播放/暂停,只用于内部部分判断)
    fileprivate var shouldStatus: PlayStatus = .none
    // 流媒体播放状态
    fileprivate var status: PlayStatus = .none {
        didSet {
//            print("status: \(status)")
//            delegate?.setPlayStatus(status)
            delegate?.saeLayer(layer: self, playerStateDidChange: status)
        }
    }
    
    var isWaitingBuffered: Bool = false
    // 是否是用户在暂停
    var isUserPause: Bool = false
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupActions()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        self.playerLayer?.frame = self.bounds
    }
    
    deinit {
        clean()
    }
}

extension SaePlayerLayer {
    
    func clean() {
        self.shouldStatus = .pause
        self.player?.pause()
        if let ob = periodicTimeObserver {
            self.player?.removeTimeObserver(ob)
        }
        self.player?.currentItem?.cancelPendingSeeks()
        self.player?.currentItem?.asset.cancelLoading()
        self.player?.replaceCurrentItem(with: nil)
        self.playerItem = nil
        if let urlStr = url, let url = URL(string: urlStr) {
            VideoAssetManager.shared.remove(url: url)
        }
        self.player = nil
    }
    
    func setData(url: String, cover: String) {
        if url != self.url {
            needChangeItem = true
            self.url = url
            // TODO: 需更新进度条
//            updateControlProgress(urlStr: url)
        }
    }
    
    func updateControlProgress(urlStr: String) {
        guard let url = URL(string: urlStr) else { return }
        let asset = VideoAssetManager.shared.getAsset(with: url)
        let playerItem = AVPlayerItem(asset: asset)
        debugPrint("URL: \(urlStr)")
        debugPrint("curTime: \(TimeInterval(playerItem.currentTime().value))")
        let totalTime = playerItem.duration
        let curTime = playerItem.currentTime()
        delegate?.saeLayer(layer: self, playTimeDidChange: TimeInterval(curTime.value), totalTime: TimeInterval(totalTime.value))
    }
    
    func initAndPlay() {
        if !needChangeItem {
            self.player?.play()
            return
        }
        guard let urlStr = url, let url = URL(string: urlStr) else { return }
//        let asset = AVURLAsset(url: url)
        self.player?.currentItem?.cancelPendingSeeks()
        self.player?.currentItem?.asset.cancelLoading()
//        if let ob = periodicTimeObserver {
//            self.player?.removeTimeObserver(ob)
//        }
        
        let asset = VideoAssetManager.shared.getAsset(with: url)
        
        asset.loadValuesAsynchronously(forKeys: ["tracks"]) { [weak self, weak asset] in
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                if let asset = asset, asset.isPlayable{
                    self?.loadedResourceForPlay(asset: asset)
                }
            }
        }
        self.playerItem = AVPlayerItem(asset: asset)
        
        self.player?.replaceCurrentItem(with: playerItem)
        if let totalTime = self.playerItem?.duration, let curTime = self.playerItem?.currentTime() {
            delegate?.saeLayer(layer: self, playTimeDidChange: TimeInterval(curTime.value), totalTime: TimeInterval(totalTime.value))
//            delegate?.setTotalTime(TimeInterval(totalTime.value))
        }
//        if let curTime = self.playerItem?.currentTime() {
//            delegate?.setCurrentTime(TimeInterval(curTime.value))
//            self.player?.seek(to: curTime)
//        }
        
        needChangeItem = false
        self.playerItem?.sae.observe(\AVPlayerItem.status, options: .new) { [weak self] (item, change) in
            switch item.status {
            case .readyToPlay:
                if self?.shouldStatus == PlayStatus.playing {
                    self?.player?.play()
                }
                break
            case .unknown:
                break
            case .failed:
                break
            @unknown default:
                break
            }
        }
        
        self.playerItem?.sae.observe(\AVPlayerItem.loadedTimeRanges, options: .new, changeHandler: { [weak self] (item, change) in
            guard let self = self else { return }
            // 计算缓冲进度
            guard let timeRange = change.newValue else { return }
            
            self.delegate?.saeLayer(layer: self, item: item, newRanges: timeRange)
            if let timeInterVarl = self.availableDuration(ranges: timeRange) {
                let duration        = item.duration
                let totalDuration   = CMTimeGetSeconds(duration)
                // 缓冲进度
            }
        })
        
        self.playerItem?.sae.observe(\AVPlayerItem.isPlaybackBufferEmpty, options: .new, changeHandler: { (item, change) in
            
            if let isPlaybackBufferEmpty = change.newValue, isPlaybackBufferEmpty {
                self.status = .buffering
                self.bufferingSomeSecond()
            }
        })
    }
    
    // 缓冲进度
    fileprivate func availableDuration(ranges loadedTimeRanges: [NSValue]) -> TimeInterval? {
        guard let first = loadedTimeRanges.first else { return nil }
        
        let timeRange = first.timeRangeValue
        let startSeconds = CMTimeGetSeconds(timeRange.start)
        let durationSecound = CMTimeGetSeconds(timeRange.duration)
        let result = startSeconds + durationSecound
        return result
    }
    
    /**
     缓冲比较差的时候
     */
    fileprivate func bufferingSomeSecond() {
        self.status = .buffering
        
        if isWaitingBuffered {
            return
        }
        isWaitingBuffered = true
        // 需要先暂停一小会之后再播放，否则网络状况不好的时候时间在走，声音播放不出来
        player?.pause()
        let popTime = DispatchTime.now() + Double(Int64( Double(NSEC_PER_SEC) * 0.3 )) / Double(NSEC_PER_SEC)
        
        DispatchQueue.main.asyncAfter(deadline: popTime) {
            // 如果执行了play还是没有播放则说明还没有缓存好，则再次缓存一段时间
            self.isWaitingBuffered = false
            if let item = self.playerItem {
                if !item.isPlaybackLikelyToKeepUp {
                    self.bufferingSomeSecond()
                } else {
                    if self.status == .buffering {
                        self.player?.play()
                    }
                }
            }
        }
    }
    
    // 加载视频相关信息
    func loadedResourceForPlay(asset: AVURLAsset) {
        for track in asset.tracks {
            if track.mediaType == .video {
                self.delegate?.saeLayer(layer: self, videoSize: track.naturalSize)
                return
            }
        }
    }
    
    
    /// 设置视频内容显示mode, 以及背景色
    /// - Parameter gravity:
    func setFullScreenStyle(gravity: AVLayerVideoGravity) {
        playerLayer?.videoGravity = gravity
        switch gravity {
        case .resize:
            backgroundColor = UIColor.black
            break
        case .resizeAspect:
            backgroundColor = UIColor.black
            break
        case .resizeAspectFill:
            backgroundColor = UIColor.clear
            break
        default:
            break
        }
    }
}

extension SaePlayerLayer {
    func setupViews() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .black
        
        self.player = CustomPlayer()
        self.player?.rate = 1.0
        
        self.cover = UIImageView()
        self.cover.contentMode = .scaleAspectFill
        self.cover.clipsToBounds = true
        self.cover.isHidden = false
        let playerLayer = AVPlayerLayer(player: player)
        self.playerLayer = playerLayer
        setFullScreenStyle(gravity: .resizeAspectFill)
        playerLayer.contentsScale = UIScreen.main.scale
        self.layer.addSublayer(playerLayer)
        self.clipsToBounds = true
    }
    
    func setupActions() {
        self.player?.sae.observe(\CustomPlayer.timeControlStatus, options: .new) { [weak self] (player, change) in
            //            guard self?.url == "https://qnimage.bamaying.com/2fe55de6ac84762ba75be4cb9dec17ae.mp4" else { return }
            switch player.timeControlStatus {
            case .paused:
//                print("observe: paused")
                if self?.isWaitingBuffered == true {
                    self?.status = .buffering
                } else if self?.isPlayEnded() == true {
                    self?.status = .ended
                } else if self?.isUserPause == true {
                    self?.status = .userPause
                } else {
                    self?.status = .pause
                }
            case .playing:
//                print("observe: playing")
                self?.status = .playing
            case .waitingToPlayAtSpecifiedRate:
                self?.status = .buffering
//                print("observe: waitingToPlayAtSpecifiedRate")
                break
            @unknown default:
                break
            }
        }
        self.player?.addPeriodicTimeObserver(forInterval: CMTimeMake(value: 1, timescale: 60), queue: DispatchQueue.main) { [weak self](time) in
            guard let self = self else { return }
            guard let duration = self.player?.currentItem?.duration else { return }
            //当前正在播放的时间
            let loadTime = CMTimeGetSeconds(time)
            //视频总时间
            let totalTime = CMTimeGetSeconds(duration)
            if loadTime == totalTime, self.autoRepeat == true {
                self.player?.seek(to: CMTime.zero, completionHandler: { [weak self] (com) in
                    self?.player?.play()
                })
            }
            self.delegate?.saeLayer(layer: self, playTimeDidChange: loadTime, totalTime: totalTime)
//            self?.delegate?.setTotalTime(totalTime)
//            self?.delegate?.setCurrentTime(loadTime)
        }
    }
}

extension SaePlayerLayer: SaePlayerLayerProtocol {
    
    func isPlayEnded() -> Bool {
        guard let duration = self.player?.currentItem?.duration else { return false}
        guard let curTime = self.player?.currentItem?.currentTime() else { return false}
        //当前正在播放的时间
        let loadTime = CMTimeGetSeconds(curTime)
        //视频总时间
        let totalTime = CMTimeGetSeconds(duration)
        return loadTime == totalTime
    }
    
    public func autoRepeat(_ isAuto: Bool) {
        self.autoRepeat = isAuto
    }
    
    public func pause(isUser: Bool = false) {
        // 外部暂停(代码暂停,用户暂停)
        isUserPause = isUser
        isWaitingBuffered = false
        player?.pause()
        shouldStatus = .pause
    }
    
    public func play() {
        isUserPause = false
        shouldStatus = .playing
        initAndPlay()
    }
    
    public func seekTo(_ time: TimeInterval) {
        let player = self.player
        player?.seek(
            to: CMTime(seconds: time, preferredTimescale: 1000),
            toleranceBefore: CMTimeMake(value: 1, timescale: 1000),
            toleranceAfter: CMTimeMake(value: 1, timescale: 1000),
            completionHandler: { [weak self] isCom in
                guard let self = self else { return }
                self.delegate?.saeLayer(layer: self, seekIsCompleted: isCom)
                self.player?.play()
        })
    }
}
