//
//  BookListVC.swift
//  Notepad
//
//  Created by 张维熙 on 2022/2/14.
//

import UIKit

class BookListVC: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.navigationController?.navigationBar.prefersLargeTitles = true
        title = "观辞"
        
        let button = UIButton(frame: CGRect(x: 100, y: 200, width: 100, height: 100))
        button.setTitle("Test", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.tintColor = .blue
        button.addTarget(self, action: #selector(showAnother), for: .touchUpInside)
        view.addSubview(button)
        
    }

    @objc func showAnother() {
        splitViewController?.show(.supplementary)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
}
