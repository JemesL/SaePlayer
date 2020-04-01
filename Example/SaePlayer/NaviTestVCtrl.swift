//
//  NaviTestVCtrl.swift
//  SaePlayer_Example
//
//  Created by Jemesl on 2020/3/30.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

class NaviTestVCtrl: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
//        setupConstraints()
//        self.navigationController?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    func setupViews() {
        view.backgroundColor = .white
        let btn = UIButton()
        btn.backgroundColor = .blue
        btn.setTitle("点击", for: .normal)
        
        view.addSubview(btn)
        btn.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
        btn.addTarget(self, action: #selector(pushTo), for: .touchUpInside)
    }
    
    @objc func pushTo() {
        navigationController?.pushViewController(NaviTest2CTrl(), animated: true)
    }
    
    
}
