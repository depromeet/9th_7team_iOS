//
//  MenuOptionModel.swift
//  myRecipick
//
//  Created by Min on 2021/05/22.
//  Copyright © 2021 depromeet. All rights reserved.
//

import Foundation

protocol MenuOptionDataProtocol {
    var status: Int { get }
    var data: [OptionKindModel] { get }
}

protocol OptionKindProtocol {
    var id: String { get }
    var type: String { get }
    var name: String { get }
    var order: Int { get }
    var options: [OptionKindModel] { get }
}

protocol OptionProtocol {
    var type: OptionType { get }
    var name: String { get }
    var image: String { get }
    var order: Int { get }
}

struct MenuOptionDataModel: Decodable, MenuOptionDataProtocol {
    let status: Int
    let data: [OptionKindModel]
}

struct OptionKindModel: Decodable, OptionKindProtocol {
    let id: String
    let type: String
    let name: String
    let order: Int
    let options: [OptionKindModel]
}

struct OptionModel: Decodable, OptionProtocol {
    let type: OptionType
    let name: String
    let image: String
    let order: Int
}

enum OptionType: Decodable {
    case check
    case radio
    case unknown(value: String)
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let status = try? container.decode(String.self)
        switch status {
        case "CHECK": self = .check
        case "RADIO": self = .radio
        default: self = .unknown(value: status ?? "unknown")
        }
    }
}

class OptionSection: Hashable {
    let title: String
    let isSingleSelection: Bool
    var isExpanded = false
    var items: [OptionItem] = []

    private let uuid = UUID()
    
    public func hash(into hasher: inout Hasher) {
         hasher.combine(ObjectIdentifier(self).hashValue)
    }
    
    init(title: String, isSingleSelection: Bool = false, items: [OptionItem]) {
        self.title = title
        self.isSingleSelection = isSingleSelection
        self.items = items
    }
    
    static func == (lhs: OptionSection, rhs: OptionSection) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
}

class OptionItem: Hashable {
    let title: String
    var isSelected = false
    var type: Options
    private let uuid = UUID()
    
    public func hash(into hasher: inout Hasher) {
         hasher.combine(ObjectIdentifier(self).hashValue)
    }
    
    init(title: String, type: Options = .option) {
        self.title = title
        self.type = type
    }
    
    static func == (lhs: OptionItem, rhs: OptionItem) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
}

enum Options: Hashable {
    case option
    case additional
}
