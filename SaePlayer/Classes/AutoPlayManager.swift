//
//  AutoPlayManager.swift
//  SaePlayerSample
//
//  Created by Jemesl on 2020/3/24.
//  Copyright © 2020 Jemesl. All rights reserved.
//

import Foundation
import UIKit

typealias AutoPlayCell = AutoPlayProtocol & UIView

public protocol AutoPlayProtocol {
    func getPlayerFrame() -> CGRect?
    func play()
    func pause()
}

// 自动播放组件
open class AutoPlayManager {
    static let shared: AutoPlayManager = AutoPlayManager()
    
    // 每个tableview 存储 indexpaths 的对象数组
    fileprivate var ipArr: [IndexPathStorage] = []
    
    init() {}
    
    // 清除对应 hash 的所有数据
    func cleanIPs(with hash: String) {
        ipArr = ipArr.filter{ $0.hashKey != hash }
    }
    
    // 获取对应 hash 的 indexpath 数组
    func getIPs(with hash: String) -> [IndexPath] {
        return getCurIPStorage(with: hash).playListIndex
    }
    
        
    func add(_ index: IndexPath, hash: String) {
        let ipSt = getCurIPStorage(with: hash)
        if !ipSt.playListIndex.contains(index) {
            ipSt.playListIndex.append(index)
            updateIPSt(ipst: ipSt, hash: hash)
        }
    }
    
    func remove(_ index: IndexPath, hash: String) {
        let ipSt = getCurIPStorage(with: hash)
        if ipSt.playListIndex.contains(index) {
            ipSt.playListIndex = ipSt.playListIndex.filter{ $0.section != index.section || $0.row != index.row }
            updateIPSt(ipst: ipSt, hash: hash)
        }
    }
}

extension AutoPlayManager {
    // 根据 hash 获取对应的 ip 存储对象
    fileprivate func getCurIPStorage(with hash: String) -> IndexPathStorage {
        for ip in ipArr {
            if ip.hashKey == hash {
                return ip
            }
        }
        let ipst = IndexPathStorage()
        ipst.hashKey = hash
        return ipst
    }
    
    fileprivate func updateIPSt(ipst: IndexPathStorage, hash: String) {
        ipArr = ipArr.filter{ $0.hashKey != hash}
        ipArr.append(ipst)
    }

}

fileprivate class IndexPathStorage {
    var hashKey: String? = nil
    var playListIndex: [IndexPath] = []
}

