//
//  ViewController.swift
//  观辞
//
//  Created by 张维熙 on 2021/12/27.
//

import UIKit

class ViewController: UIViewController, UITextViewDelegate {
    var documentView: UITextView!
    var navigationBar: UINavigationBar!
    var toolBarItems: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureTestView()
        
        
        
    }

    
}

