//
//  UITableView+Ex.swift
//  SaePlayerSample
//
//  Created by Jemesl on 2020/3/24.
//  Copyright © 2020 Jemesl. All rights reserved.
//

import Foundation
import UIKit

public extension UITableView {
    
    // 初始化 播放状态, 并执行播放
    func resetPlayingStatus() {
        DispatchQueue.main.async { [weak self] in
            self?.updateCellDisplayStatus()
            self?.playingOfList(isFirst: true)
        }
    }
    
    // 播放可播放列表中的视频
    func playingOfList(isFirst: Bool = false) {
        let formatHash = String(format: "%12d", self.hash)
        var list = AutoPlayManager.shared.getIPs(with: formatHash)
        list = isFirst ? list.reversed() : list
        for (index, indexPath) in list.enumerated() {
            if let cell = self.cellForRow(at: indexPath) as? AutoPlayCell {
                if index == (list.count - 1) {
                    cell.play()
                } else {
                    cell.pause()
                }
            }
        }
    }
    
    // 检查更新 cell 的可播放/暂停状态
    func updateCellDisplayStatus() {
        guard let cells = self.visibleCells as? [AutoPlayCell] else { return }
        
        let formatHash = String(format: "%12d", self.hash)
        
        for (_, cell) in cells.enumerated() {
            if let playerRect = cell.getPlayerFrame(), let realCell = cell as? UITableViewCell {
                let rect =  cell.convert(playerRect, to: self)
                let curIndexPath = self.indexPath(for: realCell)
                if (rect.minY - contentOffset.y) < 0 {
                    cell.pause()
                    if let indexPath = curIndexPath {
                        AutoPlayManager.shared.remove(indexPath, hash: formatHash)
                    }
                } else if (rect.maxY - contentOffset.y) > self.frame.height {
                    cell.pause()
                    if let indexPath = curIndexPath {
                        AutoPlayManager.shared.remove(indexPath, hash: formatHash)
                    }
                } else {
                    if let indexPath = curIndexPath {
                        AutoPlayManager.shared.add(indexPath, hash: formatHash)
                    }
                }
            }
        }
    }
}

import Foundation
extension NSObject {
    
    // 返回className
    var className:String{
        get{
            let name =  type(of: self).description()
            if(name.contains(".")){
                return name.components(separatedBy: ".")[1];
            }else{
                return name;
            }
        }
    }
}
