//
//  CommonWebViewController.swift
//  myRecipick
//
//  Created by hanwe on 2021/04/21.
//  Copyright © 2021 depromeet. All rights reserved.
//

import UIKit
import WebKit
import SnapKit

class CommonWebViewController: UIViewController {
    // MARK: enum
    enum CommonWebViewControllerShowType {
        case push
        case present
    }
    
    // MARK: outlet
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var webViewContainerView: UIView!
    
    // MARK: property
    
    var showType: CommonWebViewControllerShowType = .push
    
    var webView: WKWebView = WKWebView()
    var mainURL: URL?
    let progressBar = UIProgressView(progressViewStyle: .bar)
    var naviTitle: String = ""
    
    
    // MARK: lifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        URLCache.shared.removeAllCachedResponses()
        URLCache.shared.diskCapacity = 0
        URLCache.shared.memoryCapacity = 0
        
        definesPresentationContext = true

        let userScript = WKUserScript(
            source: "mobileHeader()",
            injectionTime: WKUserScriptInjectionTime.atDocumentEnd,
            forMainFrameOnly: true
        )
        
        let contentController: WKUserContentController = WKUserContentController()
        contentController.addUserScript(userScript)
        
        guard let url = self.mainURL else {
            return
        }
        print("url:\(url)")
        
        let config: WKWebViewConfiguration = WKWebViewConfiguration()
        config.userContentController = contentController
        
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        preferences.javaScriptCanOpenWindowsAutomatically = true
        config.preferences = preferences
        
        self.webView.scrollView.isScrollEnabled = false
        self.webView = WKWebView(frame: .zero, configuration: config)
        self.webView.uiDelegate = self
        self.webView.navigationDelegate = self
        self.webView.scrollView.delegate = self
        self.webView.load(URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 5))
        self.webView.allowsLinkPreview = false
        
        initUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let _ = self.mainURL else {
            return
        }
        
    }
    
    // MARK: func
    func initUI() {
        
        self.webViewContainerView.addSubview(self.webView)
        self.webView.snp.makeConstraints { (make) in
            make.top.equalTo(self.webViewContainerView.snp.top).offset(0)
            make.bottom.equalTo(self.webViewContainerView.snp.bottom).offset(0)
            make.leading.equalTo(self.webViewContainerView.snp.leading).offset(0)
            make.trailing.equalTo(self.webViewContainerView.snp.trailing).offset(0)
        }
        
        
        self.progressBar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 2)
        self.progressBar.alpha = 0
        self.progressBar.tintColor = UIColor(asset: Colors.sampleColor)
        self.progressBar.autoresizingMask = .flexibleWidth
        
        self.webViewContainerView.addSubview(self.progressBar)
        self.progressBar.snp.makeConstraints { (make) in
            make.top.equalTo(self.webViewContainerView.snp.top).offset(0)
            make.leading.equalTo(self.webViewContainerView.snp.leading).offset(0)
            make.trailing.equalTo(self.webViewContainerView.snp.trailing).offset(0)
            make.height.equalTo(2)
        }
        setNavigationItems()
        switch self.showType {
        case .present:
            makeCloseBtnAndRemoveBackBtn()
        case .push:
            makeBackBtnAndRemoveCloseBtn()
        }
    }
    
    func setNavigationItems() {
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor(asset: Colors.sampleColor)
        titleLabel.font = UIFont(name: FontKeys.medium, size: 20)
        titleLabel.text = self.naviTitle
        self.navigationItem.titleView = titleLabel
        self.navigationController?.navigationBar.backgroundColor = UIColor.clear
    }
    
    func makeBackBtnAndRemoveCloseBtn() {
        self.navigationItem.rightBarButtonItem = nil
        let imgIcon = UIImage.init(systemName: "square.and.arrow.up")?.withRenderingMode(.alwaysOriginal)
        let barButtonItem = UIBarButtonItem(image: imgIcon, style: .plain, target: self, action: #selector(popButtonClicked(_:)))
        self.navigationItem.leftBarButtonItem = barButtonItem
    }
    
    func makeCloseBtnAndRemoveBackBtn() {
        self.navigationItem.leftBarButtonItem = nil
        let imgIcon = UIImage.init(systemName: "square.and.arrow.up")?.withRenderingMode(.alwaysOriginal)
        let barButtonItem = UIBarButtonItem(image: imgIcon, style: .plain, target: self, action: #selector(closeButtonClicked(_:)))
        self.navigationItem.rightBarButtonItem = barButtonItem
    }
    
    
    // MARK: action
    
    @objc func popButtonClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func closeButtonClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension CommonWebViewController: WKUIDelegate, WKNavigationDelegate, UIScrollViewDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType == .linkActivated {
            if let url = navigationAction.request.url {
                let app = UIApplication.shared
                if navigationAction.targetFrame == nil {
                    if app.canOpenURL(url) {
                        app.open(url)
                        decisionHandler(.cancel)
                        return
                    }
                } else {
                    UIApplication.shared.open(url, options: [:])
                    decisionHandler(.cancel)
                    return
                }
                decisionHandler(.allow)
            }
        } else {
            let app = UIApplication.shared
            if let url = navigationAction.request.url {
                
                if navigationAction.targetFrame == nil {
                    if app.canOpenURL(url) {
                        app.open(url)
                        decisionHandler(.cancel)
                        return
                    }
                }
            }
            decisionHandler(.allow)
        }
        
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.webView.evaluateJavaScript("document.body.style.webkitTouchCallout='none';")
        progressBar.setProgress(1, animated: true)
        UIView.animate(withDuration: 0.3, delay: 1, options: .curveEaseInOut, animations: {
            self.progressBar.alpha = 0
        }, completion: nil)
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print(Float(webView.estimatedProgress))
        progressBar.setProgress(Float(webView.estimatedProgress), animated: true)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation) {
        self.progressBar.setProgress(0, animated: false)
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: { self.progressBar.alpha = 1 }, completion: nil)
    }
    
    func webView(webView: WKWebView, navigation: WKNavigation, withError error: NSError) {
        progressBar.setProgress(1, animated: true)
        UIView.animate(withDuration: 0.3, delay: 1, options: .curveEaseInOut, animations: { self.progressBar.alpha = 0 }, completion: nil)
        let alert: UIAlertController = UIAlertController(title: "Error", message: "Could not load webpage", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        let code = (error as NSError).code
        if code == NSURLErrorNotConnectedToInternet {
            // NotConnectedToInternet
        } else if code == NSURLErrorTimedOut {
            // 타임아웃
        } else if code == NSURLErrorCancelled {
            // 의도적으로 취소한 경우
        } else {
            
        }
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return nil
    }
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
        }
        return nil
    }
}

