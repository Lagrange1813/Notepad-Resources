//
//  ArticleListVC.swift
//  Notepad
//
//  Created by 张维熙 on 2022/2/14.
//

import UIKit

class ArticleListVC: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        title = "卡拉马佐夫兄弟"
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
}
