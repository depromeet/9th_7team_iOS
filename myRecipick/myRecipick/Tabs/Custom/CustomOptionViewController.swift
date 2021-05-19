//
//  CustomOptionViewController.swift
//  myRecipick
//
//  Created by Min on 2021/05/19.
//  Copyright © 2021 depromeet. All rights reserved.
//

import UIKit

class CustomOptionViewController: UIViewController, ClassIdentifiable {

    static func makeViewController(menuID: String) -> CustomOptionViewController {
        let vm = CustomOptionViewModel(menuID: menuID)
        let vc = CustomOptionViewController(nibName: self.identifier, bundle: nil)
        vc.viewModel = vm
        return vc
    }
    
    @IBOutlet weak var navigationView: CustomNavigationView!
    @IBOutlet weak var tableTopView: UIView!
    @IBOutlet weak var resetView: UIView!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var doneButton: UIButton!
    
    private var viewModel: CustomOptionViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initNavigationView()
        initTableTopView()
    }
    
    private func initNavigationView() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationView.setTitle("메뉴 이름")
        navigationView.setLeftButtonImage("iconsNavigation24ArrowLeft")
        navigationView.leftButton.addTarget(self, action: #selector(dismiss(_:)), for: .touchUpInside)
        navigationView.setRightButtonImage("iconClose")
        navigationView.rightButton.addTarget(self, action: #selector(popToRootView(_:)), for: .touchUpInside)
    }
    
    private func initTableTopView() {
        tableTopView.backgroundColor = Colors.grayScaleEE.color
        resetView.roundCorners(corners: [.topLeft, .topRight], radius: 25)
        resetButton.setTitle("초기화", for: .normal)
        resetButton.setTitleColor(Colors.grayScale66.color, for: .normal)
        resetButton.titleLabel?.font = .myRecipickFont(.button)
    }
    
    private func initTableView() {
        
    }
    
    private func initTableBottomView() {
        
    }
    
}

extension CustomOptionViewController {
    
    @objc
    private func dismiss(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func popToRootView(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
