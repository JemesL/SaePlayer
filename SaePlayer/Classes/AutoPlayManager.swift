//
//  AutoPlayManager.swift
//  SaePlayerSample
//
//  Created by Jemesl on 2020/3/24.
//  Copyright © 2020 Jemesl. All rights reserved.
//

import Foundation
import UIKit

public typealias AutoPlayCell = AutoPlayProtocol & UIView

public protocol AutoPlayProtocol {
    func getPlayerFrame() -> CGRect?
    func play()
    func pause()
}

// 自动播放组件
open class AutoPlayManager {
    public static let shared: AutoPlayManager = AutoPlayManager()
    
    // 每个tableview 存储 indexpaths 的对象数组
    fileprivate var ipArr: [IndexPathStorage] = []
    
    public init() {}
    
    // 清除对应 hash 的所有数据
    func cleanIPs(with hash: String) {
        ipArr = ipArr.filter{ $0.hashKey != hash }
    }
    
    // 获取对应 hash 的 indexpath 数组
    func getIPs(with hash: String) -> [IndexPath] {
        return getCurIPStorage(with: hash).getCanPlayerList()
    }
    
    public func pause(_ index: IndexPath, hash: String) {
        let ipSt = getCurIPStorage(with: hash)
//        if !ipSt.playListIndex.contains(index) {
//            ipSt.playListIndex.append(index)
//        }
        ipSt.userPause(index: index)
        updateIPSt(ipst: ipSt, hash: hash)
    }
        
    func add(_ index: IndexPath, hash: String) {
        let ipSt = getCurIPStorage(with: hash)
        ipSt.add(index: index)
//        if !ipSt.playListIndex.contains(index) {
//            ipSt.playListIndex.append(index)
//
//        }
        updateIPSt(ipst: ipSt, hash: hash)
    }
    
    func remove(_ index: IndexPath, hash: String) {
        let ipSt = getCurIPStorage(with: hash)
        ipSt.remove(index: index)
//        if ipSt.playListIndex.contains(index) {
//            ipSt.playListIndex = ipSt.playListIndex.filter{ $0.section != index.section || $0.row != index.row }
            updateIPSt(ipst: ipSt, hash: hash)
//        }
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
    // 视频列表对象hash
    var hashKey: String? = nil
    // 可播放列表
    private var playListIndex: [IndexPath] = []
    // 用户手动暂停列表
    private var userPauseListIndex: [IndexPath] = []
    
    func add(index: IndexPath) {
        if !playListIndex.contains(index) {
            playListIndex.append(index)
        }
    }
    
    func remove(index: IndexPath) {
        if playListIndex.contains(index) {
            playListIndex = playListIndex.filter{ !($0.section == index.section && $0.row == index.row) }
        }
        // 暂停列表同步移除
        if let i = userPauseListIndex.firstIndex(of: index) {
            userPauseListIndex.remove(at: i)
        }
    }
    
    func userPause(index: IndexPath) {
        if !userPauseListIndex.contains(index) {
            userPauseListIndex.append(index)
        }
    }
    
    // 获取可以播放的列表
    func getCanPlayerList() -> [IndexPath] {
        return playListIndex.filter { !userPauseListIndex.contains($0) }
    }
}

