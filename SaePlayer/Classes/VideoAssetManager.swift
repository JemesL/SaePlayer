//
//  VideoAssetManager.swift
//  SaePlayerSample
//
//  Created by Jemesl on 2020/3/12.
//  Copyright © 2020 Jemesl. All rights reserved.
//

import Foundation
import AVKit
open class VideoAssetManager {
    static let shared: VideoAssetManager = VideoAssetManager()
    
    var list: [String: AVURLAsset] = [:]
    
    func getAsset(with url: URL) -> AVURLAsset {
        if let asset: AVURLAsset = list.get(url.absoluteString) {
            return asset
        } else {
            let asset = AVURLAsset(url: url)
            list[url.absoluteString] = asset
            return asset
        }
    }
    
    func remove(url: URL) {
        print("Asset remove: \(url)")
        list.removeValue(forKey: url.absoluteString)
    }
}
