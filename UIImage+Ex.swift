//
//  UIImage+Ex.swift
//  SaePlayer
//
//  Created by Jemesl on 2020/3/26.
//

import Foundation

extension UIImage {
    static func imageResourcePath(_ fileName: String) -> UIImage? {
        let bundle = Bundle(for: SaePlayer.self)
        return UIImage(named: fileName, in: bundle, compatibleWith: nil)
    }
}
