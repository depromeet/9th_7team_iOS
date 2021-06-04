//
//  CustomMenuNameViewController.swift
//  myRecipick
//
//  Created by Min on 2021/05/29.
//  Copyright © 2021 depromeet. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CustomMenuNameViewController: UIViewController, ClassIdentifiable {

    static func makeViewController(menu: MenuModel?) -> CustomMenuNameViewController {
        let vc = CustomMenuNameViewController(nibName: self.identifier, bundle: nil)
        vc.menu = menu
        vc.modalPresentationStyle = .overFullScreen
        return vc
    }
    @IBOutlet weak var dimView: UIView!
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var popupViewBottomConstraint: NSLayoutConstraint!
    
    private var menu: MenuModel?
    
    var buttonClosure: ((String) -> Void)?
    let menuName = BehaviorRelay<String>(value: "")
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initBackgroundView()
        initPopupView()
        bind()
        initObservers()
    }
    
    deinit {
        deInitObservers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.25) {
            self.dimView.alpha = 1.0
            self.popupView.alpha = 1.0
        }
        
        UIView.animate(withDuration: 0.8,
                       delay: 0.0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0.0,
                       options: .curveEaseInOut) {
            self.popupViewBottomConstraint.constant = 0.0
            self.view.layoutIfNeeded()
        } completion: { (_ ) in
            self.nameTextField.becomeFirstResponder()
        }
    }

    private func initBackgroundView() {
        view.backgroundColor = .clear
        dimView.backgroundColor = UIColor(white: 0, alpha: 0.6)
        dimView.alpha = 0
        popupView.alpha = 0
    }
    
    private func initPopupView() {
        popupView.roundCorner(radius: 25)

        imageView.kf.setImage(with: URL(string: menu?.image ?? ""),
                                   placeholder: nil,
                                   options: [.cacheMemoryOnly],
                                   completionHandler: { [weak self] _ in
                                    self?.imageView.fadeIn(duration: 0.1, completeHandler: nil)
                                   })
        
        titleLabel.text = "이름 설정"
        titleLabel.font = .myRecipickFont(.subTitle1)
        titleLabel.textColor = Colors.grayScale33.color
        
        nameTextField.text = nil
        nameTextField.textColor = Colors.grayScale66.color
        nameTextField.font = .myRecipickFont(.subTitle2)
        
        okButton.setTitle("레시픽 저장", for: .normal)
        okButton.setTitleColor(Colors.white.color, for: .normal)
        okButton.setBackgroundColor(Colors.grayScaleBD.color, for: .disabled)
        okButton.setBackgroundColor(Colors.primaryLight.color, for: .selected)
        okButton.setBackgroundColor(Colors.primaryNormal.color, for: .normal)
        okButton.roundCorner(radius: 4)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(doClose(sender:)))
        dimView.addGestureRecognizer(gesture)
    }
    
    private func bind() {
        nameTextField.rx.text
            .orEmpty
            .compactMap { $0.count > 0 }
            .bind(to: okButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        nameTextField.rx.text
            .orEmpty
            .bind(to: menuName)
            .disposed(by: disposeBag)
        
        okButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.doSave()
            }).disposed(by: disposeBag)
    }
}

extension CustomMenuNameViewController {
    @objc
    private func doClose(sender: AnyObject?) {
        view.endEditing(true)

        UIView.animate(withDuration: 0.25) {
            self.popupView.alpha = 0.0
            self.dimView.alpha = 0.0
        } completion: { (_ ) in
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    @objc
    private func doSave() {
        view.endEditing(true)

        UIView.animate(withDuration: 0.25) {
            self.popupView.alpha = 0.0
            self.dimView.alpha = 0.0
        } completion: { (_ ) in
            self.dismiss(animated: false) {
                self.buttonClosure?(self.menuName.value)
            }
        }
    }
}

extension CustomMenuNameViewController {
    
    private func initObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(sender:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(sender:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    private func deInitObservers() {
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillShowNotification,
                                                  object: nil)
        
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillHideNotification,
                                                  object: nil)
    }
    
    @objc
    private func keyboardWillShow(sender: NSNotification) {
        if let keyboardFrame: NSValue = sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRect = keyboardFrame.cgRectValue
            popupViewBottomConstraint.constant = keyboardRect.size.height
            view.layoutIfNeeded()
        }
    }
    
    @objc
    private func keyboardWillHide(sender: NSNotification) {
        popupViewBottomConstraint.constant = 0.0
        view.layoutIfNeeded()
    }

}
