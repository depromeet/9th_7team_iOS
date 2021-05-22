//
//  MenuContainerCollectionViewCell.swift
//  myRecipick
//
//  Created by Min on 2021/05/14.
//  Copyright © 2021 depromeet. All rights reserved.
//

import UIKit
import SnapKit

class MenuContainerCollectionViewCell: UICollectionViewCell, ClassIdentifiable {
    
    @IBOutlet weak var baseView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func menuList(list: [String]?, on parent: UIViewController) {
        guard let list = list else { return }
        let menuVC = MenuListViewController.makeViewController(menuList: list, parentVC: parent)
        menuVC.view.frame = baseView.frame
        baseView.addSubview(menuVC.view)
        parent.addChild(menuVC)
//        menuVC.didMove(toParent: parent)
    }

}
