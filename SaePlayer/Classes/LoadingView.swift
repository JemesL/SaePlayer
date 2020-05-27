//
//  LoadingView.swift
//  SaePlayer
//
//  Created by Jemesl on 2020/4/13.
//

import Foundation
import UIKit

open class LoadingView: UIView {
    
    // 主layer
    var shapeLayer:CAShapeLayer!
    // 圆形layer
    var layer1:CAShapeLayer!
    var leftLayer: CAGradientLayer!
    var rightLayer: CAGradientLayer!
    
    // 色卡1
    var colors1:[CGColor] = [ UIColor.white.withAlphaComponent(0.5).cgColor,UIColor.white.cgColor]
    // 色卡2
    var colors2:[CGColor] = [UIColor.white.withAlphaComponent(0.5).cgColor,UIColor.white.withAlphaComponent(0).cgColor]
    
    init() {
        super.init(frame: CGRect.zero)
//        setUI()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        setUI()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
        self.layer.sublayers?.forEach{ $0.removeFromSuperlayer() }
        self.layer.removeAnimation(forKey: "loading")
        let size = self.bounds.size
        shapeLayer = CAShapeLayer()
        shapeLayer.frame = self.bounds
        self.layer.addSublayer(shapeLayer)
        
        // 创建梯形layer
        leftLayer = CAGradientLayer()
//        leftLayer.frame  = CGRect(x: 0, y: 0, width: 240, height: 120)
        leftLayer.frame  = CGRect(x: 0, y: 0, width: size.width, height: size.height / 2)
        leftLayer.colors = colors1
        leftLayer.startPoint = CGPoint(x: 0, y: 0.5)
        leftLayer.endPoint   = CGPoint(x: 1, y: 0.5)
        shapeLayer.addSublayer(leftLayer)
        
        rightLayer = CAGradientLayer()
//        rightLayer.frame  = CGRect(x: 0, y: 120, width: 240, height: 120)
        rightLayer.frame  = CGRect(x: 0, y: size.height / 2, width: size.width, height: size.height / 2)
        rightLayer.colors = colors2
        rightLayer.startPoint = CGPoint(x: 0, y: 0.5)
        rightLayer.endPoint   = CGPoint(x: 1, y: 0.5)
        shapeLayer.addSublayer(rightLayer)
        
        // 创建一个圆形layer
        layer1 = CAShapeLayer()
        layer1.strokeEnd = 1
        layer1.frame = self.bounds
        layer1.path = UIBezierPath(arcCenter: CGPoint(x: size.width/2, y: size.height/2), radius: min(size.width/2, size.height/2) - 2, startAngle: CGFloat(M_PI/30), endAngle: 2 * CGFloat(M_PI) - CGFloat(M_PI/30), clockwise: true).cgPath
//        layer1.path = UIBezierPath(arcCenter: CGPoint(x: 120, y: 120), radius: 100, startAngle: CGFloat(M_PI/30), endAngle: 2 * CGFloat(M_PI) - CGFloat(M_PI/30), clockwise: true).cgPath
        layer1.lineWidth    = 2
        layer1.lineCap      = CAShapeLayerLineCap.round
        layer1.lineJoin     = CAShapeLayerLineJoin.round
        layer1.strokeColor  = UIColor.black.cgColor
        layer1.fillColor    = UIColor.clear.cgColor
        
        // 根据laery1 的layer形状在 shaperLayer 中截取出来一个layer
        shapeLayer.mask = layer1
    }
    
    /**
     旋转动画
     */
    fileprivate func startLoading() {
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.isRemovedOnCompletion = false
        animation.toValue   =  2 * Double.pi
        animation.duration = 1.25
        animation.repeatCount = HUGE
        self.layer.add(animation, forKey: "loading")
    }
    
    func stopLoading() {
        self.layer.removeAnimation(forKey: "loading")
    }
    
    func showOrHidden(isHidden: Bool) {
        if isHidden {
            stopLoading()
        } else {
            startLoading()
        }
    }
    
    public override var isHidden: Bool {
        didSet {
            showOrHidden(isHidden: isHidden)
        }
    }
    
}
