//
//  ViewController.swift
//  RxSwiftMVVMDemo
//
//  Created by wujuan on 2019/7/25.
//  Copyright © 2019 guahao. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class ViewController: UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    let disposeBag = DisposeBag()
    
    var viewModel: DrugViewModel = DrugViewModel()
    var cellViewModels: [DrugCellViewModel] = []
    
    
    let reloadSubject = PublishSubject<[DrugCellViewModel]>()
    let editSubject = PublishSubject<DrugCellViewModel>()
    let deleteTrigger = PublishSubject<DrugCellViewModel>()


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        configView()
        setupViewModel()
        
        reloadSubject.onNext([])

    }
    
    func configView() {
        self.title = "添加中草药"
        let resetBar = UIBarButtonItem(barButtonSystemItem:.refresh, target: self, action: #selector(resetAction))
        navigationItem.leftBarButtonItem = resetBar
        
        let addBar = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addDrugAction))
        navigationItem.rightBarButtonItem = addBar
        tableView.register(UINib(nibName: CellIdentifiers.DrugTableViewCell, bundle: nil), forCellReuseIdentifier: CellIdentifiers.DrugTableViewCell)
    }
    
    func setupViewModel() {
        let input = DrugViewModel.Input(reload: reloadSubject, editTrigger: editSubject, deleteTrigger: deleteTrigger )

        let output = viewModel.transform(input: input)
        
        output.totalCount.drive(onNext: { (content) in
            self.titleLabel.text = content
        }).disposed(by: disposeBag)
        
        output.items.map({ (items) -> [DrugCellViewModel] in
            self.cellViewModels = items
            return items
        }).asDriver(onErrorJustReturn: []).drive(tableView.rx.items(cellIdentifier: CellIdentifiers.DrugTableViewCell, cellType: DrugTableViewCell.self)) { index, viewModel, cell in
                let rowViewModel = self.cellViewModels[index]

                cell.setup(viewModel: rowViewModel)
                
                rowViewModel.numberButtonTapped.asObserver().subscribe(onNext: { (drugCellViewModel) in
                    self.editSubject.onNext(drugCellViewModel)
                }).disposed(by: self.disposeBag)
                
                rowViewModel.deleteButtonTapped.asObserver().subscribe(onNext: { (drugCellViewModel) in
                    self.deleteTrigger.onNext(drugCellViewModel)
                }).disposed(by: self.disposeBag)

        }.disposed(by: self.disposeBag)
    }
    
    @objc func resetAction() {
        self.reloadSubject.onNext([])
    }
    
    @objc func addDrugAction() {
        //跳转到下一页
    }
}
