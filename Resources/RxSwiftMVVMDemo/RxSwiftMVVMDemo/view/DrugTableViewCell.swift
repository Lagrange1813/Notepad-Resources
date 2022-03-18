//
//  DrugTableViewCell.swift
//  RxSwiftMVVMDemo
//
//  Created by wujuan on 2019/7/26.
//  Copyright © 2019 guahao. All rights reserved.
//

import UIKit
import RxSwift

class DrugTableViewCell: UITableViewCell {
    @IBOutlet weak var drugNameLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var drugPriceLabel: UILabel!
    @IBOutlet weak var minusBtn: UIButton!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    private var viewModel: DrugCellViewModel?
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func setup(viewModel:DrugCellViewModel?) {
        self.viewModel = viewModel
        configureView()
    }
    
    private func configureView() {
        guard let viewModel = viewModel else { return }
        drugNameLabel.text = viewModel.drugModel.drugName
        textField.text = "\(viewModel.drugCount)"
        drugPriceLabel.text = "\(viewModel.drugModel.maxPrice)元"
    }
    
    
    @IBAction func minusButtonClick(_ sender: Any) {
        viewModel?.minusDrug()
    }
    
    @IBAction func plusButtonClick(_ sender: Any) {
        viewModel?.addDrug()
    }
    @IBAction func deleteButtonClick(_ sender: Any) {
        viewModel?.deleteDrug()
    }
}

extension DrugTableViewCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}
