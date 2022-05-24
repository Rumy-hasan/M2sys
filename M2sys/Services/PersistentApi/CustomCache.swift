//
//  CustomCache.swift
//  M2sys
//
//  Created by Paradox Space Rumy M1 on 24/5/22.
//

import Foundation
import UIKit


//Taken from https://www.swiftbysundell.com/articles/caching-in-swift/#it-all-starts-with-a-declaration
protocol CacheUpdate:NSObject{
    func isCacheUpdate()
}

final class Cache<Key: Hashable, Value> {
    
    private let wrapped = NSCache<WrappedKey, Entry>()
    weak var cacheDelegate:CacheUpdate!
    init(){
        self.wrapped.name = "Json cache temporary"
        self.wrapped.countLimit = 100
    }
    
    func insert(_ value: Value, forKey key: Key) {
        let entry = Entry(value: value)
        wrapped.setObject(entry, forKey: WrappedKey(key))
        cacheDelegate.isCacheUpdate()
    }

    func value(forKey key: Key) -> Value? {
        let entry = wrapped.object(forKey: WrappedKey(key))
        return entry?.value
    }

    func removeValue(forKey key: Key) {
        wrapped.removeObject(forKey: WrappedKey(key))
        cacheDelegate.isCacheUpdate()
    }
    
}
 


extension Cache {
    subscript(key: Key) -> Value? {
        get { return value(forKey: key) }
        set {
            guard let value = newValue else {
                removeValue(forKey: key)
                return
            }
            insert(value, forKey: key)
        }
    }
}
