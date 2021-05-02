//
//  TabCoordinator.swift
//  myRecipick
//
//  Created by hanwe lee on 2021/04/13.
//  Copyright © 2021 depromeet. All rights reserved.
//

import UIKit
import SwiftyJSON

class TabCoordinator: NSObject, CoordinatorProtocol, SplashViewProtocol {
    
    @objc enum Tab: Int {
        case home = 0
        case custom
        case yourPage
    }
    
    // MARK: property
    
    var rootViewController: UIViewController {
        return tabController
    }
    
    var navigationController: UINavigationController = UINavigationController()
    
    let tabController: UITabBarController
    weak var parentsCoordinator: CoordinatorProtocol?
    
    let homeCoordinator: HomeCoordinator
    let customCoordinator: CustomCoordinator
    let yourPageCoordinator: YourPageCoordinator
    
    let homeViewController: HomeViewController
    let customViewController: CustomViewController
    let yourPageViewController: YourPageViewController
    
    weak var targetView: UIView?
    var attachedView: UIView? = SplashView.instance()
    
    // MARK: state
    
    var currentSelectedTab: TabCoordinator.Tab = .home
    
    // MARK: lifeCycle
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.tabController = MainTabBarViewController()
        self.homeCoordinator = HomeCoordinator(navigationController: self.navigationController)
        self.customCoordinator = CustomCoordinator(navigationController: self.navigationController)
        self.yourPageCoordinator = YourPageCoordinator(navigationController: self.navigationController)

        var controllers: [UIViewController] = []
        homeViewController = HomeViewController.makeViewController(coordinator: self.homeCoordinator, viewModel: HomeViewModel())
        homeViewController.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "iconsNavigation32Home"), selectedImage: UIImage(named: "iconsNavigation32Home"))
        controllers.append(homeViewController)
        customViewController = CustomViewController()
        customViewController.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "iconsNavigation32Plus"), selectedImage: UIImage(named: "iconsNavigation32Plus"))
        controllers.append(customViewController)
        yourPageViewController = YourPageViewController.makeViewController(coordinator: self.yourPageCoordinator, viewModel: YourPageViewModel())
//        yourPageViewController = YourPageViewController()
        yourPageViewController.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "iconsNavigation32History"), selectedImage: UIImage(named: "iconsNavigation32History"))
        controllers.append(yourPageViewController)
        tabController.viewControllers = controllers
        tabController.tabBar.tintColor = UIColor(asset: Colors.primaryNormal)
        tabController.tabBar.unselectedItemTintColor = UIColor(asset: Colors.black)
        self.tabController.tabBar.isTranslucent = false
        self.navigationController.viewControllers = [self.tabController]
        super.init()
        setClearNavigation()
        self.tabController.delegate = self
        self.homeCoordinator.parentsCoordinator = self
        self.customCoordinator.parentsCoordinator = self
        self.yourPageCoordinator.parentsCoordinator = self
        
        self.targetView = self.navigationController.view
        self.showSplashView(completion: { [weak self] in
            BrandModel.shared.requestBandList(completeHandler: { [weak self] responseJson in
                if 200..<300 ~= responseJson["status"].intValue {
                    let items = responseJson["data"]
                    BrandModel.shared.fetchBrandList(items: items)
                } else {
                    print("********* todo alert??? ***********")
                    print("error:\(responseJson["status"].intValue)")
                    print("********************")
                }
                self?.hideSplashView(completion: nil)
            }, failureHandler: { [weak self] err in
                print("********* todo alert??? ***********")
                print("error:\(err.localizedDescription)")
                print("********************")
                self?.hideSplashView(completion: nil)
            })
        })
        print("end init")
    }
    
    deinit {
        print("- \(type(of: self)) deinit")
    }
    
    // MARK: func
    
    func moveTo(tab: Tab) {
        self.tabController.selectedIndex = tab.rawValue
        afterMoveTabActions(tab: tab)
    }
    
    func setClearNavigation() {
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().backgroundColor = .clear
        UINavigationBar.appearance().isTranslucent = true
    }
    
    // MARk: private func
    
    private func afterMoveTabActions(tab: Tab) {
        self.currentSelectedTab = tab
        switch tab {
        case .home:
            self.homeCoordinator.didSelected(tabCoordinator: self)
        case .custom:
            self.customCoordinator.didSelected(tabCoordinator: self)
        case .yourPage:
            self.yourPageCoordinator.didSelected(tabCoordinator: self)
        }
    }
    
}

extension TabCoordinator: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        switch viewController {
        case self.homeViewController:
            if self.currentSelectedTab != .home {
                afterMoveTabActions(tab: .home)
            }
        case self.customViewController:
            if self.currentSelectedTab != .custom {
                afterMoveTabActions(tab: .custom)
            }
        case self.yourPageViewController:
            if self.currentSelectedTab != .yourPage {
                afterMoveTabActions(tab: .yourPage)
            }
        default:
            print("selected unkownTab")
        }
    }
}
