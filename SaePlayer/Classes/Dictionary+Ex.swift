//
//  Dictionary+Ex.swift
//  SaePlayerSample
//
//  Created by Jemesl on 2020/3/12.
//  Copyright © 2020 Jemesl. All rights reserved.
//

import Foundation
extension Dictionary where Key == String{

    func getOptionString(_ key: String) -> String? {
        return get(key)
    }
    
    func getOptionCGFloat(_ key: String) -> CGFloat? {
        return get(key)
    }
    
    func getOptionInt(_ key: String) -> Int? {
        return get(key)
    }
    
    func getOptionBool(_ key: String) -> Bool? {
        return get(key)
    }
    
    func getOptionDict(_ key: String) -> [String: Any]? {
        return get(key)
    }
    
    func getOptionArr<T>(_ key: String) -> [T]? {
        return get(key)
    }
    
    func getString(_ key: String) -> String {
        if let str = getOptionString(key) {
            return str
        } else {
            return ""
        }
//        return getOptionString(key) ?? ""
    }
    
    func getInt(_ key: String) -> Int {
        return getOptionInt(key) ?? 0
    }
    
    func getCGFloat(_ key: String) -> CGFloat {
        return getOptionCGFloat(key) ?? 0.0
    }
    
    func getBool(_ key: String) -> Bool {
        return getOptionBool(key) ?? false
    }
    
    func getDict(_ key: String) -> [String: Any] {
        return getOptionDict(key) ?? [:]
    }
    
    func getArr<T>(_ key: String) -> [T] {
        return getOptionArr(key) ?? []
    }

    func get<T>(_ key: String) -> T? {
        return self[key] as? T
    }
}
