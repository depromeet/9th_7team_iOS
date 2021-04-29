//
//  CoordinatorProtocol.swift
//  myRecipick
//
//  Created by hanwe lee on 2021/04/13.
//  Copyright © 2021 depromeet. All rights reserved.
//

import UIKit

@objc protocol CoordinatorProtocol: AnyObject {
    var navigationController: UINavigationController { get set }
//    var childCoordinators: [CoordinatorProtocol] { get set } // 샘플에는 이런게 들어있던데 어따쓰는지 몰라서 주석처리...........
    var parentsCoordinator: CoordinatorProtocol? { get set }
    @objc optional func moveTo(tab: TabCoordinator.Tab)
}

protocol MainTabCoordinatorProtocol: CoordinatorProtocol {
    func didSelected(tabCoordinator: TabCoordinator)
}

protocol CoordinatorViewControllerBaseProtocol: AnyObject {
    associatedtype CoordinatorType: CoordinatorProtocol
    var coordinator: CoordinatorType! { get set }
}

protocol CoordinatorViewControllerProtocol: CoordinatorViewControllerBaseProtocol {
    associatedtype SelfType: CoordinatorViewControllerProtocol
    static func makeViewController(coordinator: CoordinatorType) -> SelfType
}
