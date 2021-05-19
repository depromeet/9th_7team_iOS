//
//  CustomNavigationView.swift
//  myRecipick
//
//  Created by Min on 2021/05/07.
//  Copyright © 2021 depromeet. All rights reserved.
//

import UIKit

class CustomNavigationView: BaseCustomView {

    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initView()
        
    }
    
    private func initView() {
        clipsToBounds = true
        leftButton.isHidden = true
        rightButton.isHidden = true
        titleLabel.text = nil
        
    }

}

extension CustomNavigationView {
    func setTitle(_ text: String) {
        titleLabel.text = text
        titleLabel.font = .myRecipickFont(.subTitle1)
    }
    
    func setLeftButtonText(_ text: String) {
        leftButton.isHidden = false
        leftButton.setTitle(text, for: .normal)
    }
    
    func setLeftButtonImage(_ imageName: String, color: UIColor = Colors.grayScale33.color) {
        leftButton.isHidden = false
        leftButton.setTitle("", for: .normal)
        let image = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate)
        leftButton.setImage(image, for: .normal)
        leftButton.tintColor = color
    }
    
    func setRightButtonText(_ text: String) {
        rightButton.isHidden = false
        rightButton.setTitle(text, for: .normal)
    }
    
    func setRightButtonImage(_ imageName: String, color: UIColor = Colors.grayScale33.color) {
        rightButton.isHidden = false
        rightButton.setTitle("", for: .normal)
        let image = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate)
        rightButton.setImage(image, for: .normal)
        rightButton.tintColor = color
    }
}
