//
//  SampleWebViewController.swift
//  Demo
//
//  Created by Suguru Kishimoto on 3/7/17.
//  Copyright © 2017 Suguru Kishimoto. All rights reserved.
//

import UIKit
import WebKit
import PullToDismiss

class SampleWebViewController: UIViewController {

    private lazy var webView: WKWebView = WKWebView(frame: .zero)
    private var pullToDismiss: PullToDismiss?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webView)
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        let attributes: [NSLayoutAttribute] = [.top, .left, .right, .bottom]
        let constraints: [NSLayoutConstraint] = attributes.map { attribute in
            NSLayoutConstraint(item: webView, attribute: attribute, relatedBy: .equal, toItem: view, attribute: attribute, multiplier: 1.0, constant: 0.0)
        }
        
        view.addConstraints(constraints)
        
        pullToDismiss = PullToDismiss(scrollView: webView.scrollView)
        Config.shared.adaptSetting(pullToDismiss: pullToDismiss)
        pullToDismiss?.delegate = self
        view.backgroundColor = .white

        webView.load(URLRequest(url: URL(string: "https://www.google.co.jp")!))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

extension SampleWebViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("!!!!!!!!! \(scrollView.contentOffset)")
    }
}
