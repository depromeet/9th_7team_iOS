//
//  MenuModel.swift
//  myRecipick
//
//  Created by Min on 2021/05/14.
//  Copyright © 2021 depromeet. All rights reserved.
//

import Foundation

struct MenuDataModel: Decodable {
    let status: Int
    let data: [MenuCategoryModel]
}

struct MenuCategoryModel: Decodable {
    let id: String
    let name: String
    let menus: [MenuModel]
}

struct MenuModel: Decodable {
    let id: String
    let brandId: String?
    let name: String
    let image: String
    let createdDate: String
    let updatedDate: String
}
