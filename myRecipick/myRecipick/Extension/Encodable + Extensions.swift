//
//  Encodable + Extensions.swift
//  myRecipick
//
//  Created by Min on 2021/05/29.
//  Copyright © 2021 depromeet. All rights reserved.
//

import Foundation

extension Encodable {
    subscript(key: String) -> Any? {
        return dictionary
    }
    
    var dictionary: [String: Any] {
        return (try? JSONSerialization.jsonObject(with: JSONEncoder().encode(self))) as? [String: Any] ?? [:]
    }
}
