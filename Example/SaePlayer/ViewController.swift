//
//  ViewController.swift
//  SaePlayer
//
//  Created by Jemesl on 03/26/2020.
//  Copyright (c) 2020 Jemesl. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import SaeKit
let Videos = [
    "https://qnimage.bamaying.com/2fe55de6ac84762ba75be4cb9dec17ae.mp4",
    "https://qnimage.bamaying.com/a5a2abb4d8b2c6ada976df5376ded6f8.mp4",
    "https://qnimage.bamaying.com/e621594ea6e68b6fa2d0ab1be3561702.mp4",
    "https://qnimage.bamaying.com/bfdac7912700c410e2d8154dec2df8e1.mp4",
    "https://qnimage.bamaying.com/e9cfce04c89a915e1dfcabb1a3b3f748.mp4",
    "https://qnimage.bamaying.com/998fb2f5ff45681b025ccfc30186e06b.mp4",
    "https://qnimage.bamaying.com/dc3abd9864fd5187b2d0481b8aca30a5.mp4",
    "https://qnimage.bamaying.com/cdcf2ae8c0f999a8da1ecbffd622d90b.mp4",
    "https://qnimage.bamaying.com/2fe55de6ac84762ba75be4cb9dec17ae.mp4",
    "https://qnimage.bamaying.com/a5a2abb4d8b2c6ada976df5376ded6f8.mp4",
    "https://qnimage.bamaying.com/e621594ea6e68b6fa2d0ab1be3561702.mp4",
    "https://qnimage.bamaying.com/bfdac7912700c410e2d8154dec2df8e1.mp4",
    "https://qnimage.bamaying.com/e9cfce04c89a915e1dfcabb1a3b3f748.mp4",
    "https://qnimage.bamaying.com/998fb2f5ff45681b025ccfc30186e06b.mp4",
    "https://qnimage.bamaying.com/dc3abd9864fd5187b2d0481b8aca30a5.mp4",
    "https://qnimage.bamaying.com/cdcf2ae8c0f999a8da1ecbffd622d90b.mp4",
    "https://qnimage.bamaying.com/2fe55de6ac84762ba75be4cb9dec17ae.mp4",
    "https://qnimage.bamaying.com/a5a2abb4d8b2c6ada976df5376ded6f8.mp4",
    "https://qnimage.bamaying.com/e621594ea6e68b6fa2d0ab1be3561702.mp4",
    "https://qnimage.bamaying.com/bfdac7912700c410e2d8154dec2df8e1.mp4",
    "https://qnimage.bamaying.com/e9cfce04c89a915e1dfcabb1a3b3f748.mp4",
    "https://qnimage.bamaying.com/998fb2f5ff45681b025ccfc30186e06b.mp4",
    "https://qnimage.bamaying.com/dc3abd9864fd5187b2d0481b8aca30a5.mp4",
    "https://qnimage.bamaying.com/cdcf2ae8c0f999a8da1ecbffd622d90b.mp4",
    "https://qnimage.bamaying.com/2fe55de6ac84762ba75be4cb9dec17ae.mp4",
    "https://qnimage.bamaying.com/a5a2abb4d8b2c6ada976df5376ded6f8.mp4",
    "https://qnimage.bamaying.com/e621594ea6e68b6fa2d0ab1be3561702.mp4",
    "https://qnimage.bamaying.com/bfdac7912700c410e2d8154dec2df8e1.mp4",
    "https://qnimage.bamaying.com/e9cfce04c89a915e1dfcabb1a3b3f748.mp4",
    "https://qnimage.bamaying.com/998fb2f5ff45681b025ccfc30186e06b.mp4",
    "https://qnimage.bamaying.com/dc3abd9864fd5187b2d0481b8aca30a5.mp4",
    "https://qnimage.bamaying.com/cdcf2ae8c0f999a8da1ecbffd622d90b.mp4",
    "https://qnimage.bamaying.com/2fe55de6ac84762ba75be4cb9dec17ae.mp4",
    "https://qnimage.bamaying.com/a5a2abb4d8b2c6ada976df5376ded6f8.mp4",
    "https://qnimage.bamaying.com/e621594ea6e68b6fa2d0ab1be3561702.mp4",
    "https://qnimage.bamaying.com/bfdac7912700c410e2d8154dec2df8e1.mp4",
    "https://qnimage.bamaying.com/e9cfce04c89a915e1dfcabb1a3b3f748.mp4",
    "https://qnimage.bamaying.com/998fb2f5ff45681b025ccfc30186e06b.mp4",
    "https://qnimage.bamaying.com/dc3abd9864fd5187b2d0481b8aca30a5.mp4",
    "https://qnimage.bamaying.com/cdcf2ae8c0f999a8da1ecbffd622d90b.mp4",
    "https://qnimage.bamaying.com/2fe55de6ac84762ba75be4cb9dec17ae.mp4",
    "https://qnimage.bamaying.com/a5a2abb4d8b2c6ada976df5376ded6f8.mp4",
    "https://qnimage.bamaying.com/e621594ea6e68b6fa2d0ab1be3561702.mp4",
    "https://qnimage.bamaying.com/bfdac7912700c410e2d8154dec2df8e1.mp4",
    "https://qnimage.bamaying.com/e9cfce04c89a915e1dfcabb1a3b3f748.mp4",
    "https://qnimage.bamaying.com/998fb2f5ff45681b025ccfc30186e06b.mp4",
    "https://qnimage.bamaying.com/dc3abd9864fd5187b2d0481b8aca30a5.mp4",
    "https://qnimage.bamaying.com/cdcf2ae8c0f999a8da1ecbffd622d90b.mp4",
    "https://qnimage.bamaying.com/2fe55de6ac84762ba75be4cb9dec17ae.mp4",
    "https://qnimage.bamaying.com/a5a2abb4d8b2c6ada976df5376ded6f8.mp4",
    "https://qnimage.bamaying.com/e621594ea6e68b6fa2d0ab1be3561702.mp4",
    "https://qnimage.bamaying.com/bfdac7912700c410e2d8154dec2df8e1.mp4",
    "https://qnimage.bamaying.com/e9cfce04c89a915e1dfcabb1a3b3f748.mp4",
    "https://qnimage.bamaying.com/998fb2f5ff45681b025ccfc30186e06b.mp4",
    "https://qnimage.bamaying.com/dc3abd9864fd5187b2d0481b8aca30a5.mp4",
    "https://qnimage.bamaying.com/cdcf2ae8c0f999a8da1ecbffd622d90b.mp4",
    "https://qnimage.bamaying.com/2fe55de6ac84762ba75be4cb9dec17ae.mp4",
    "https://qnimage.bamaying.com/a5a2abb4d8b2c6ada976df5376ded6f8.mp4",
    "https://qnimage.bamaying.com/e621594ea6e68b6fa2d0ab1be3561702.mp4",
    "https://qnimage.bamaying.com/bfdac7912700c410e2d8154dec2df8e1.mp4",
    "https://qnimage.bamaying.com/e9cfce04c89a915e1dfcabb1a3b3f748.mp4",
    "https://qnimage.bamaying.com/998fb2f5ff45681b025ccfc30186e06b.mp4",
    "https://qnimage.bamaying.com/dc3abd9864fd5187b2d0481b8aca30a5.mp4",
    "https://qnimage.bamaying.com/cdcf2ae8c0f999a8da1ecbffd622d90b.mp4",
    "https://qnimage.bamaying.com/2fe55de6ac84762ba75be4cb9dec17ae.mp4",
    "https://qnimage.bamaying.com/a5a2abb4d8b2c6ada976df5376ded6f8.mp4",
    "https://qnimage.bamaying.com/e621594ea6e68b6fa2d0ab1be3561702.mp4",
    "https://qnimage.bamaying.com/bfdac7912700c410e2d8154dec2df8e1.mp4",
    "https://qnimage.bamaying.com/e9cfce04c89a915e1dfcabb1a3b3f748.mp4",
    "https://qnimage.bamaying.com/998fb2f5ff45681b025ccfc30186e06b.mp4",
    "https://qnimage.bamaying.com/dc3abd9864fd5187b2d0481b8aca30a5.mp4",
    "https://qnimage.bamaying.com/cdcf2ae8c0f999a8da1ecbffd622d90b.mp4",
    "https://qnimage.bamaying.com/a88c81ce190742a49bd0ceaf5dd17292.mp4"
]
class ViewController: UIViewController {
    
    var playerItem: AVPlayerItem!
    var player: AVPlayer!
    
    var session: URLSession? = nil
    var pendingRequests: [AVAssetResourceLoadingRequest] = []
    
    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupView()
//        testColor()
    }
    
}

extension ViewController {
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
    }
    
    func setupView() {
        tableView = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(VideoCell.self, forCellReuseIdentifier: "VideoCell")
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.reloadData()
        tableView.estimatedRowHeight = 300
        tableView.contentInset = UIEdgeInsets(top: 100, left: 0, bottom: 0, right: 0)
        tableView.saeplayer.resetPlayingStatus()
        
        let pause = UIButton()
        pause.setTitle("暂停", for: UIControl.State.normal)
        pause.backgroundColor = .gray
        pause.frame.size = CGSize(width: 50, height: 50)
        pause.center = view.center
//        pause.frame = CGRect(x: 100, y: 200, width: 50, height: 50)
        pause.addTarget(self, action: #selector(pausePlayer), for: UIControl.Event.touchUpInside)
        
        view.addSubview(pause)
    }
    
    @objc func pausePlayer() {
        tableView.saeplayer.pauseAllPlayer()
    }
    
    func testColor() {
        let v = UIView()
        view.addSubview(v)
        v.backgroundColor = .white//UIColor.dynamic(.red, dark: .blue)
        v.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
        v.layer.borderWidth = 2
        v.layer.masksToBounds = true
        v.layer.cornerRadius = 100/2.0
    }
}


extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell") as? VideoCell {
            cell.setData(url: Videos[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Videos.count
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        300
    }
//
}

extension ViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        tableView.saeplayer.updateCellDisplayStatus()
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            let dragTpDragStop = scrollView.isTracking && !scrollView.isDragging && !scrollView.isDecelerating
            if dragTpDragStop {
                scrollViewDidEndScroll()
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let scrollToScrollStop = !scrollView.isTracking && !scrollView.isDragging && !scrollView.isDecelerating
        if scrollToScrollStop {
            scrollViewDidEndScroll()
        }
    }
    
    func scrollViewDidEndScroll() {
        tableView.saeplayer.playingOfList()
    }
}

