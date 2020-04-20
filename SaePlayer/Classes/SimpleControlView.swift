//
//  SimpleSimpleControlView.swift
//  SaePlayer
//
//  Created by Jemesl on 2020/4/10.
//

import Foundation
import UIKit

public enum PanDirection: Int {
    case horizontal = 0
    case vertical   = 1
}

// SimpleControlView 通过 delegate 给 player
public class SimpleControlView: BaseControlView {
    fileprivate let edge = UIEdgeInsets(top: 15, left: LEFT_RIGHT_MARGIN, bottom: 15, right: LEFT_RIGHT_MARGIN)
    
//    var delegate: SaePlayerLayerProtocol? = nil
    // 控制组件状态
    fileprivate var isSimple: Bool = true
    // 简版控制组件
    fileprivate var simpleView: UIView!
    // 进度条 - 简版
    fileprivate var progressTime: UIView!
    // 暂停时的提示图标
    fileprivate var pauseIcon: UIImageView!
    // 快进快退时, 显示时间
    fileprivate var slideTipTime: UILabel!
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
    
    fileprivate var loadingView: LoadingView!
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
    open var panGesture: UIPanGestureRecognizer!
    
    // 滑动手势的方向
    open var panDirection: PanDirection = .horizontal
    // 水平手势滑动累计快进快退的时间
    open var sumTime: CGFloat = 0
    // 手势水平当前滑动的位置
    open var curSlideLocationX: CGFloat? = nil
    // 上次手势水平滑动位置
    open var lastSlideLocationX: CGFloat? = nil
    // 手势正在拖拽
    open var isDragingGesture: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("SimpleControlView")
    }
}

extension SimpleControlView: PlayControlProtocol {
    
    public func setCoverUrl(_ url: String) {
        if url != self.url {
            self.cover.kf.setImage(with: URL(string: url))
            self.url = url
        }
    }
    
    public func resetControl() {
        switchSimpleControlView(isSimple: true)
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
            loadingView.isHidden = true
            coverHidden()
            playBtn.isSelected = true
            panGesture.isEnabled = true
            pauseIcon.isHidden = true
            break
        case .pause:
            loadingView.isHidden = true
            coverShow()
            playBtn.isSelected = false
            panGesture.isEnabled = false
            pauseIcon.isHidden = false
            break
        case .ended:
            loadingView.isHidden = true
            playBtn.isSelected = false
//            panGesture.isEnabled = false
            pauseIcon.isHidden = true
            break
        case .none:
            loadingView.isHidden = true
            playBtn.isSelected = false
            panGesture.isEnabled = false
            pauseIcon.isHidden = true
            break
        case .buffering:
            // loading 动画
            loadingView.isHidden = false
            // 隐藏封面
//            coverHidden()
            // 播放状态
            playBtn.isSelected = true
            panGesture.isEnabled = true
            pauseIcon.isHidden = true
            break
        }
    }
    
    public func setCurrentTime(_ cur: TimeInterval) {
        currentTime = cur
        updateTime()
        updateSlide()
        updateSimpleProgress()
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
    func switchSimpleControlView(isSimple: Bool) {
        self.isSimple = isSimple
        fullView.isHidden = isSimple
        simpleView.isHidden = !isSimple
    }
    
    // 重置控制组件的状态
    func resetInitStatus() {
        switchSimpleControlView(isSimple: true)
    }
    
    @objc open func onTapGestureTapped(_ gesture: UITapGestureRecognizer) {
        switchPlayerStatus()
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

extension SimpleControlView {
    func setData() {
    }
    
    @objc func switchPlayerStatus() {
        playBtn.isSelected = !playBtn.isSelected
        playBtn.isSelected ? delegate?.play() : delegate?.pause()
    }
    
    @objc func sliderTouchBegan(_ sender: UISlider) {
        isDragSliding = true
    }

    @objc func sliderValueChanged(_ sender: UISlider) {

    }

    @objc func sliderTouchEnded(_ sender: UISlider) {
        let currentTime = Double(sender.value) * totalDuration
        delegate?.seekTo(currentTime)
        isDragSliding = false
    }
}

extension SimpleControlView {
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
        
        switchSimpleControlView(isSimple: true)
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTapGestureTapped(_:)))
        addGestureRecognizer(tapGesture)
    }
    
    func getSimpleView() -> UIView {
        let v = UIView()
        
        progressTime = UIView()
        progressTime.backgroundColor = .orange
        
        let progressGestureActionView = UIView()
        progressGestureActionView.backgroundColor = .clear
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.panDirectionAction(_:)))
        progressGestureActionView.addGestureRecognizer(panGesture)
        
        slideTipTime = UILabel()
        slideTipTime.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        slideTipTime.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        slideTipTime.textColor = .white
        slideTipTime.isHidden = true
        slideTipTime.layer.cornerRadius = 4
        slideTipTime.layer.masksToBounds = true
        
        pauseIcon = UIImageView()
        pauseIcon.image = imageResourcePath("player_play")//UIImage(named: "player_play")// 
        pauseIcon.isHidden = true
        
        loadingView = LoadingView()
        loadingView.isHidden = true
        
        v.addSubview(progressTime)
        v.addSubview(progressGestureActionView)
        v.addSubview(slideTipTime)
        v.addSubview(pauseIcon)
        v.addSubview(loadingView)
        
        progressGestureActionView.consLeft(0)
        progressGestureActionView.consRight(0)
        progressGestureActionView.consBottom(0)
        progressGestureActionView.consHeight(50)
        
        slideTipTime.consSuperCenterY()
        slideTipTime.consSuperCenterX()
        slideTipTime.consHeight(50)
        
        pauseIcon.consSuperCenterY()
        pauseIcon.consSuperCenterX()
        pauseIcon.consHeight(50)
        pauseIcon.consWidth(50)
        
        loadingView.consTop(10)
        loadingView.consRight(-10)
        loadingView.consHeight(26)
        loadingView.consWidth(26)
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

// 进度条相关
extension SimpleControlView {
    
    @objc fileprivate func panDirectionAction(_ pan: UIPanGestureRecognizer) {
        // 根据在view上Pan的位置，确定是调音量还是亮度
        let locationPoint = pan.location(in: self)
        print("locationPoint: \(locationPoint)")
        // 我们要响应水平移动和垂直移动
        // 根据上次和本次移动的位置，算出一个速率的point
        let velocityPoint = pan.velocity(in: self)
        
        // 判断是垂直移动还是水平移动
        switch pan.state {
        case UIGestureRecognizer.State.began:
            
            isDragingGesture = true
            delegate?.autoRepeat(!isDragingGesture)
            // 使用绝对值来判断移动的方向
            let x = abs(velocityPoint.x)
            let y = abs(velocityPoint.y)
            
            if x > y {
//                pan.cancelsTouchesInView = false
                if true {
                    self.panDirection = PanDirection.horizontal
                    showSlideTipTime()
                    curSlideLocationX = locationPoint.x
                    lastSlideLocationX = locationPoint.x
                    // 给sumTime初值
                    self.sumTime = CGFloat(currentTime)
                    print("初值: \(currentTime)")
                }
            } else {
//                pan.cancelsTouchesInView = true
//                self.panDirection = BMPanDirection.vertical
//                if locationPoint.x > self.bounds.size.width / 2 {
//                    self.isVolume = true
//                } else {
//                    self.isVolume = false
//                }
            }
            
        case UIGestureRecognizer.State.changed:
            switch self.panDirection {
            case .horizontal:
                lastSlideLocationX = curSlideLocationX
                curSlideLocationX = locationPoint.x
                let offsetX: CGFloat = (curSlideLocationX ?? 0) - (lastSlideLocationX ?? 0)
                self.horizontalMoved(velocityPoint.x, offsetX: offsetX)
            case .vertical:
//                self.verticalMoved(velocityPoint.y)
                break
            }
            
        case UIGestureRecognizer.State.ended:
            
            // 移动结束也需要判断垂直或者平移
            // 比如水平移动结束时，要快进到指定位置，如果这里没有判断，当我们调节音量完之后，会出现屏幕跳动的bug
            switch (self.panDirection) {
            case .horizontal:
                
                self.currentTime = TimeInterval(self.sumTime)
                updateSimpleProgress()
                delegate?.seekTo(currentTime)
                hiddenSlideTipTime()
//                controlView.hideSeekToView()
//                isSliderSliding = false
//                if isPlayToTheEnd {
//                    isPlayToTheEnd = false
//                    seek(self.sumTime, completion: {
//                        self.play()
//                    })
//                } else {
//                    seek(self.sumTime, completion: {
//                        self.autoPlay()
//                    })
//                }
                // 把sumTime滞空，不然会越加越多
                self.sumTime = 0.0
                self.lastSlideLocationX = nil
                self.curSlideLocationX = nil
            case .vertical:
//                self.isVolume = false
                break
            }
            isDragingGesture = false
            delegate?.autoRepeat(!isDragingGesture)
        default:
            break
        }
    }
    
    fileprivate func horizontalMoved(_ velocityX: CGFloat, offsetX: CGFloat) {
//        print(velocityX)
//        guard BMPlayerConf.enablePlaytimeGestures else { return }
        
//        isSliderSliding = true
        if true {
            // 每次滑动需要叠加时间，通过一定的比例，使滑动一直处于统一水平
            self.sumTime = self.sumTime + calSecond(offsetX: offsetX, velocityX: velocityX, totalTime: CGFloat(totalDuration))
            print("sumTime:\(sumTime)")
            if (self.sumTime >= CGFloat(totalDuration)) { self.sumTime = CGFloat(totalDuration) }
            if (self.sumTime <= 0) { self.sumTime = 0 }
            updateSlideTipText(wantTo: TimeInterval(sumTime), total: totalDuration)
        }
    }
    
    func calSecond(offsetX: CGFloat, velocityX: CGFloat, totalTime: CGFloat) -> CGFloat {
        let second = calStandardSecond(offsetX: offsetX, totalTime: totalTime)
        let ratio = calRatio(velocityX: velocityX, totalTime: totalTime)
        return second * ratio
    }
    
    // 根据偏移值和 总时间 计算当前 offset 对应快进时间
    func calStandardSecond(offsetX: CGFloat, totalTime: CGFloat) -> CGFloat {
        let timelowLimit = max(totalTime, 30)
        let second = offsetX/300.0 * min(120, timelowLimit)
        return second
    }
    
    // 由速率和总时间来计算一个系数
    func calRatio(velocityX: CGFloat, totalTime: CGFloat) -> CGFloat {
        switch velocityX {
        case 0..<10:
            return 0.5
        case 10..<50:
            return 1
        case 50..<100:
            return 2
        case 100..<200:
            return 3
        case 200..<1000:
            return 4
        default:
            return 1
        }
    }
    
    // 显示
    fileprivate func showSlideTipTime() {
        slideTipTime.alpha = 0
        slideTipTime.isHidden = false
        UIView.animate(withDuration: 0.25, animations: { [weak self] in
            self?.slideTipTime.alpha = 1
        }) { (isEnd) in
            
        }
    }
    
    fileprivate func hiddenSlideTipTime() {
        UIView.animate(withDuration: 0.25, animations: { [weak self] in
            self?.slideTipTime.alpha = 0
        }) { [weak self] (isEnd) in
            self?.slideTipTime.alpha = 0
            self?.slideTipTime.isHidden = true
        }
    }
    
    fileprivate func updateSlideTipText(wantTo: TimeInterval, total: TimeInterval) {
        let curText = formatSecondsToString(wantTo)
        let allText = formatSecondsToString(totalDuration)
        slideTipTime.text = "  \(curText) / \(allText)  "
    }
}
