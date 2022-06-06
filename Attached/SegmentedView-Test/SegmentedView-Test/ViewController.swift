//
//  ViewController.swift
//  SegmentedView-Test
//
//  Created by 张维熙 on 2022/6/4.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    var backView = UIView()
    let segmentedController = UISegmentedControl(items: ["👻","🤖","👾"])
    let scrollView = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray
        
        configureBackView()
        configureScrollView()
    }

    func configureBackView() {
//        let backView = UIView()
        backView.backgroundColor = .white
        
        view.addSubview(backView)
        backView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
            make.height.equalTo(300)
        }
        
//        let segmentedController = UISegmentedControl(items: ["👻","🤖","👾"])
        backView.addSubview(segmentedController)
        segmentedController.selectedSegmentIndex = 0
        segmentedController.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(30)
            make.width.equalTo(300)
            make.bottom.equalToSuperview().inset(10)
        }
        segmentedController.addTarget(self, action: #selector(segmentedControllerValueDidChange), for: .valueChanged)
    }
    
    func configureScrollView() {
        
        scrollView.contentSize = CGSize(width: 1050, height: 260)
        scrollView.alwaysBounceVertical = false
        scrollView.alwaysBounceHorizontal = true
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        backView.addSubview(scrollView)
        
        let label1 = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        label1.text = "Label1"
        scrollView.addSubview(label1)
        
        let label2 = UILabel(frame: CGRect(x: 350, y: 0, width: 50, height: 50))
        label2.text = "Label2"
        scrollView.addSubview(label2)
        
        let label3 = UILabel(frame: CGRect(x: 700, y: 0, width: 50, height: 50))
        label3.text = "Label3"
        scrollView.addSubview(label3)
        
        scrollView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalTo(segmentedController.snp.top)
        }
    }
    
    @objc func segmentedControllerValueDidChange(_ sender: UISegmentedControl) {
        print("yes")
        switch sender.selectedSegmentIndex {
        case 0:
            print("1")
        case 1:
            print("2")
        case 2:
            print("3")
        default:
            break
        }
    }
}
