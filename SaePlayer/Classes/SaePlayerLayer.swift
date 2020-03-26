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
    func pause()
    // 播放
    func play()
    // 跳转
    func seekTo(_ time: TimeInterval)
}

open class SaePlayerLayer: UIView {
    fileprivate let edge = UIEdgeInsets(top: 15, left: LEFT_RIGHT_MARGIN, bottom: 15, right: LEFT_RIGHT_MARGIN)
    
    var player: AVPlayer? = nil
    var playerItem: AVPlayerItem? = nil
    var playerLayer: AVPlayerLayer? = nil
    fileprivate var periodicTimeObserver: Any? = nil
    fileprivate var needChangeItem: Bool = false
    
    // 封面
    var cover: UIImageView!
    var url: String? = nil
    
    weak var delegate: PlayControlProtocol? = nil
    
    
    
    // 播放状态
    fileprivate var status: PlayStatus = .none {
        didSet {
            delegate?.setPlayStatus(status)
        }
    }
    
    var isWaitingBuffered: Bool = false
    
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
        }
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
        self.playerItem = AVPlayerItem(asset: VideoAssetManager.shared.getAsset(with: url))
        
        self.player?.replaceCurrentItem(with: playerItem)
        if let totalTime = self.playerItem?.duration {
            delegate?.setTotalTime(TimeInterval(totalTime.value))
        }
        if let curTime = self.playerItem?.currentTime() {
            delegate?.setCurrentTime(TimeInterval(curTime.value))
            self.player?.seek(to: curTime)
        }
        
        needChangeItem = false
        self.playerItem?.sae.observe(\AVPlayerItem.status, options: .new) { [weak self] (item, change) in
            switch item.status {
            case .readyToPlay:
                self?.player?.play()
                break
            case .unknown:
                break
            case .failed:
                break
            @unknown default:
                break
            }
        }
        
        self.playerItem?.sae.observe(\AVPlayerItem.loadedTimeRanges, options: .new, changeHandler: { (item, change) in
            // 计算缓冲进度
            guard let items = change.newValue else { return }
            if let timeInterVarl = self.availableDuration(ranges: items) {
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
}

extension SaePlayerLayer {
    func setupViews() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        
        self.player = AVPlayer()
        self.player?.rate = 1.0
        
        self.cover = UIImageView()
        self.cover.contentMode = .scaleAspectFill
        self.cover.clipsToBounds = true
        self.cover.isHidden = false
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspectFill
        
        self.layer.addSublayer(playerLayer)

        self.playerLayer = playerLayer
    }
    
    func setupActions() {
        self.player?.sae.observe(\AVPlayer.timeControlStatus, options: .new) { [weak self] (player, change) in
            //            guard self?.url == "https://qnimage.bamaying.com/2fe55de6ac84762ba75be4cb9dec17ae.mp4" else { return }
            switch player.timeControlStatus {
            case .paused:
//                print("observe: paused")
                if self?.isWaitingBuffered == true {
                    self?.status = .buffering
                } else {
                    self?.status = .pause
                }
            case .playing:
//                print("observe: playing")
                self?.status = .playing
            case .waitingToPlayAtSpecifiedRate:
//                print("observe: waitingToPlayAtSpecifiedRate")
                break
            @unknown default:
                break
            }
        }
        self.player?.addPeriodicTimeObserver(forInterval: CMTimeMake(value: 1, timescale: 60), queue: DispatchQueue.main) { [weak self](time) in
            guard let duration = self?.player?.currentItem?.duration else { return }
            //当前正在播放的时间
            let loadTime = CMTimeGetSeconds(time)
            //视频总时间
            let totalTime = CMTimeGetSeconds(duration)
            if loadTime == totalTime {
                self?.player?.seek(to: CMTime.zero, completionHandler: { (com) in
                    self?.player?.play()
                })
            }
            self?.delegate?.setTotalTime(totalTime)
            self?.delegate?.setCurrentTime(loadTime)
        }

    }
}

extension SaePlayerLayer: SaePlayerLayerProtocol {
    
    public func pause() {
        // 外部暂停, 等于用户主动暂停
        isWaitingBuffered = false
        player?.pause()
    }
    
    public func play() {
        initAndPlay()
    }
    
    public func seekTo(_ time: TimeInterval) {
        let player = self.player
        player?.seek(to: CMTime(seconds: time, preferredTimescale: 1000)) { [weak self] (isCom) in
            self?.player?.play()
        }
    }
}
