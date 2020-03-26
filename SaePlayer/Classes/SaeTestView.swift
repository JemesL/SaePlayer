//
//  SaeTestView.swift
//  SaePlayerSample
//
//  Created by Jemesl on 2020/3/22.
//  Copyright © 2020 Jemesl. All rights reserved.
//

import Foundation
import UIKit

class SaeTestView: UIView {
    fileprivate let edge = UIEdgeInsets(top: 15, left: LEFT_RIGHT_MARGIN, bottom: 15, right: LEFT_RIGHT_MARGIN)
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SaeTestView {
    func setData() {
    }
}

extension SaeTestView {
    func setupViews() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        
                let red = UIView()
        red.backgroundColor = .red
        addSubview(red)
//        red.snp.makeConstraints { make in
//            make.centerX.equalToSuperview()
//            make.centerY.equalToSuperview()
//            make.size.equalTo(CGSize(width: 100, height: 100))
//        }

    }
    
    func setupConstraints() {
        
    }
}
