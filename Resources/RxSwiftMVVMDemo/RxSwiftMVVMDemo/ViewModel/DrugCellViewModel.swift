//
//  DrugCellViewModel.swift
//  RxSwiftMVVMDemo
//
//  Created by wujuan on 2019/7/25.
//  Copyright © 2019 guahao. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class DrugCellViewModel: NSObject {
    
    var drugModel: DrugModel
    var drugCount:Int

    var numberButtonTapped = PublishSubject<DrugCellViewModel>()
    var deleteButtonTapped = PublishSubject<DrugCellViewModel>()
    
    init(drugModel:DrugModel) {
        self.drugModel =  drugModel
        drugCount = drugModel.drugCount
    }
    
    func addDrug() {
        self.drugModel.drugCount += 1
        drugCount+=1
        numberButtonTapped.onNext(self)
    }

    func minusDrug() {
        if drugCount > 0 {
            drugCount-=1
            self.drugModel.drugCount -= 1
        }
        numberButtonTapped.onNext(self)
    }

    func deleteDrug(){
        deleteButtonTapped.onNext(self)
    }
}

