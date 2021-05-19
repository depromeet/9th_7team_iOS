//
//  MenuModel.swift
//  myRecipick
//
//  Created by Min on 2021/05/14.
//  Copyright © 2021 depromeet. All rights reserved.
//

import Foundation

protocol MenuDataProtocol {
    var status: Int { get }
    var message: String { get }
    var data: MenuCategoryModel { get }
}

protocol MenuCategoryProtocol {
    var id: String { get }
    var name: String { get }
    var menus: [MenuModel] { get }
}

protocol MenuProtocol {
    var id: String { get }
    var brandId: String { get }
    var name: String { get }
    var image: String { get }
    var isShow: Bool { get }
    var createdDate: String { get }
    var updatedDate: String { get }
}

struct MenuDataModel: Decodable, MenuDataProtocol {
    let status: Int
    let message: String
    let data: MenuCategoryModel
}

struct MenuCategoryModel: Decodable, MenuCategoryProtocol {
    let id: String
    let name: String
    let menus: [MenuModel]
}

struct MenuModel: Decodable, MenuProtocol {
    let id: String
    let brandId: String
    let name: String
    let image: String
    let isShow: Bool
    let createdDate: String
    let updatedDate: String
}
