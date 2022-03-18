//
//  LoadingViewController.swift
//  RxSwiftMVVMDemo
//
//  Created by wujuan on 2019/7/29.
//  Copyright © 2019 guahao. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {
    private lazy var activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.darkGray
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            
            ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
}
