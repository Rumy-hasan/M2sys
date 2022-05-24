//
//  Extension.swift
//  M2sys
//
//  Created by Paradox Space Rumy M1 on 24/5/22.
//

import Foundation
import UIKit
import Combine

extension HTTPURLResponse {
    func isResponseOK() -> Bool {
        return (200...299).contains(self.statusCode)
    }
}


extension Cache {
    //MARK: Hash key
    final class WrappedKey: NSObject {
        let key: Key
        
        init(_ key: Key) { self.key = key }
        
        override var hash: Int { return key.hashValue }
        
        override func isEqual(_ object: Any?) -> Bool {
            guard let value = object as? WrappedKey else {
                return false
            }
            
            return value.key == key
        }
    }
    
    //MARK: value object
    final class Entry {
        let value: Value

        init(value: Value) {
            self.value = value
        }
    }
}

