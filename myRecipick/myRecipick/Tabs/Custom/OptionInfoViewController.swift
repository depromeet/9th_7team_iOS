//
//  OptionInfoViewController.swift
//  myRecipick
//
//  Created by Min on 2021/05/29.
//  Copyright © 2021 depromeet. All rights reserved.
//

import UIKit

class OptionInfoViewController: UIViewController, ClassIdentifiable {
    
    static func makeViewController(item: OptionModel) -> OptionInfoViewController {
        let vc = OptionInfoViewController(nibName: self.identifier, bundle: nil)
        vc.optionItem = item
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        return vc
    }
    
    @IBOutlet weak var dimView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var popView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var kcalLabel: UILabel!
    
    private var optionItem: OptionModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        initBackgroundView()
        initLabel()
        bindData()
    }
    
    private func initBackgroundView() {
        view.backgroundColor = .clear
        dimView.backgroundColor = UIColor(white: 0, alpha: 0.6)
        popView.roundCorner(radius: 25)
    }
    
    private func initLabel() {
        nameLabel.text = nil
        nameLabel.textColor = Colors.grayScale33.color
        nameLabel.font = .myRecipickFont(.title4)
        
        infoLabel.text = nil
        infoLabel.textColor = Colors.grayScale66.color
        infoLabel.font = .myRecipickFont(.body2)
        
        kcalLabel.text = nil
        kcalLabel.textColor = Colors.grayScale99.color
        kcalLabel.font = .myRecipickFont(.caption)
        
    }
    
    private func bindData() {
        guard let item = optionItem else { return }
        nameLabel.text = item.name
        infoLabel.text = item.description
        kcalLabel.text = item.calorie
        
        imageView.kf.setImage(with: URL(string: item.image),
                                   placeholder: nil,
                                   options: [.cacheMemoryOnly],
                                   completionHandler: { [weak self] _ in
                                    self?.imageView.fadeIn(duration: 0.1, completeHandler: nil)
                                   })
    }

    @IBAction func closeButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
