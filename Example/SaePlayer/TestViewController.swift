
//
//  TestViewController.swift
//  SaePlayer_Example
//
//  Created by Jemesl on 2020/3/26.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import Foundation
import UIKit

class TestViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
}

extension TestViewController {
    func setData() {
    }
    
    func setupViews() {
        
        let btn = UIButton()
        btn.backgroundColor = .blue
        btn.setTitle("点击", for: .normal)
        
        view.addSubview(btn)
        btn.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
        btn.addTarget(self, action: #selector(pushTo), for: .touchUpInside)
    }
    
    @objc func pushTo() {
        navigationController?.pushViewController(ViewController(), animated: true)
    }
    
    func setupConstraints() {
    }
}

