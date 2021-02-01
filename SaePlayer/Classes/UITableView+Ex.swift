//
//  UITableView+Ex.swift
//  SaePlayerSample
//
//  Created by Jemesl on 2020/3/24.
//  Copyright © 2020 Jemesl. All rights reserved.
//

import Foundation
import UIKit

import Foundation
import UIKit
//import SaeKit

public protocol SaeSpacable {
    associatedtype CompatibleType
    static var saeplayer: SaeSpace<CompatibleType>.Type { get }
    var saeplayer: SaeSpace<CompatibleType> { get }
}

extension SaeSpacable {
    public static var saeplayer: SaeSpace<Self>.Type {
        get {
            return SaeSpace<Self>.self
        }
    }
    public var saeplayer: SaeSpace<Self> {
        get {
            return SaeSpace(self)
        }
    }
}

public struct SaeSpace<Base> {
    public let base: Base
    
    public init(_ base: Base) {
        self.base = base
    }
}

extension NSObject: SaeSpacable {}


public extension SaeSpace where Base: UITableView {

    // 初始化 播放状态, 并执行播放
    func resetPlayingStatus() {
        DispatchQueue.main.async {
            self.updateCellDisplayStatus()
            self.playingOfList(isFirst: true)
        }
    }
    
    // 播放可播放列表中的视频
    func playingOfList(isFirst: Bool = false) {
        let formatHash = String(format: "%12d", base.hash)
        var list = AutoPlayManager.shared.getIPs(with: formatHash)
        list = isFirst ? list.reversed() : list
        for (index, indexPath) in list.enumerated() {
            if let cell = base.cellForRow(at: indexPath) as? AutoPlayCell {
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
        let cells = base.visibleCells.map { $0 as? AutoPlayCell }.compactMap{ $0 }
        let formatHash = String(format: "%12d", base.hash)
        
        for (_, cell) in cells.enumerated() {
            if let playerRect = cell.getPlayerFrame(), let realCell = cell as? UITableViewCell {
                let rect =  cell.convert(playerRect, to: base)
                let curIndexPath = base.indexPath(for: realCell)
                if (rect.minY - base.contentOffset.y) < 0 {
                    cell.pause()
                    if let indexPath = curIndexPath {
                        AutoPlayManager.shared.remove(indexPath, hash: formatHash)
                    }
                } else if (rect.maxY - base.contentOffset.y) > base.frame.height {
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
    
    // 暂停播放
    func pauseAllPlayer() {
        for cell in base.visibleCells {
            if let c = cell as? AutoPlayCell {
                c.pause()
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
