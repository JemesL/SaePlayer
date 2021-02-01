//
//  VideoCell.swift
//  SaePlayer_Example
//
//  Created by Jemesl on 2020/3/26.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import SaePlayer
import SnapKit
// 视频获得封面的后缀
let VideoCoverSuffix = "?vframe/jpg/offset/1"

class VideoCell: UITableViewCell {
    var index: IndexPath? = nil
    var tbHash: String? = nil
    var player: SaePlayer!
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        makeConstraints()
        setupActions()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        self.player.bounds = self.frame
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
//        self.player.player.replaceCurrentItem(with: nil)
        player.resetControlView()
    }
}

extension VideoCell {
    func setData(url: String) {
        self.player.setData(url: url, cover: "\(url)\(VideoCoverSuffix)", defaultCover: "loading_lightdark_360x294")
    }
    
    func play() {
        self.player.play()
    }
    
    func stop() {
        self.player.pause()
    }
    
    func setupViews() {
//        let sim = SimpleControlView()
//
//        sim.pauseBlock = { [weak self] in
//            guard let self = self else { return }
//            AutoPlayManager.shared.pause(self.index!, hash: self.tbHash!)
//        }
        player = SaePlayer()
        contentView.addSubview(player)
        player.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(0)
            make.height.equalTo(300).priority(.low)
        }
    }
    
    func makeConstraints() {
        
    }
    
    func setupActions() {
        
    }
}

extension VideoCell: AutoPlayProtocol {
    func pause() {
        self.player.pause()
    }
    
    func getPlayerFrame() -> CGRect? {
        return player.frame
    }
    
    
}
