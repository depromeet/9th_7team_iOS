//
//  BrandSelectService.swift
//  myRecipick
//
//  Created by hanwe lee on 2021/04/20.
//  Copyright © 2021 depromeet. All rights reserved.
//

import UIKit

protocol BrandSelectServiceProtocol: AnyObject {
    func getAllBrandInfos() -> [BrandObjectModel]
}

class BrandSelectService: BrandSelectServiceProtocol {
    // MARK: property
    
    // MARK: lifeCycle
    
    deinit {
        print("- \(type(of: self)) deinit")
    }
    
    // MARK: func
    
    func getAllBrandInfos() -> [BrandObjectModel] {
        return BrandModel.shared.brands
    }
    
}
