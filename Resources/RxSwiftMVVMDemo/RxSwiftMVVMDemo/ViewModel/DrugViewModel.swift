//
//  DrugViewModel.swift
//  RxSwiftMVVMDemo
//
//  Created by wujuan on 2019/7/25.
//  Copyright © 2019 guahao. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift


class DrugViewModel {
    
    let totalCount = PublishSubject<String>()

    private let disposeBag = DisposeBag()

    var respository: DrugsRespository
    
    init() {
        self.respository = DrugsRespository(apiClient: APIClient())
    }
    
    struct Input {
        let reload: PublishSubject<[DrugCellViewModel]>
        let editTrigger: PublishSubject<DrugCellViewModel>
        let deleteTrigger: PublishSubject<DrugCellViewModel>
    }
    
    struct Output {
        let items: BehaviorRelay<[DrugCellViewModel]>
        let totalCount: Driver<String>
    }
    

    func transform(input: Input) -> Output {
        let elements = BehaviorRelay<[DrugCellViewModel]>(value: [])

        input.reload.flatMapLatest({ (item) -> Observable<[DrugCellViewModel]> in
            return self.request()
        }).subscribe(onNext: { (items) in
            elements.accept(items)
        }).disposed(by: self.disposeBag)

        input.editTrigger.subscribe(onNext: { (item) in
            var arr = [DrugCellViewModel]()
            for model in elements.value {
                if model.drugModel.drugId == item.drugModel.drugId {
                    arr.append(item)
                } else {
                    arr.append(model)
                }
            }
            elements.accept(arr)
        }).disposed(by: self.disposeBag)
        
        input.deleteTrigger.subscribe(onNext: { (item) in
            if let index = elements.value.firstIndex(of:item) {
                var arr = elements.value
                arr.remove(at:index)
                elements.accept(arr)
            }
        }).disposed(by: self.disposeBag)
        
        let totalCount = elements.map({ (items) -> String in
            
            var sum = 0;
            var priceSum = 0.00;

            for cellViewModel in items {
                sum += cellViewModel.drugCount
                let price : Double =  (cellViewModel.drugModel.maxPrice) * Double(cellViewModel.drugCount)
                priceSum += price
            }
            return "共\(items.count)味药，\(sum)g，药品参考总价:\(priceSum)元"
        }).asDriver(onErrorJustReturn: "")

        return Output(items: elements, totalCount: totalCount)
    }
    
    
    func request() -> Observable<[DrugCellViewModel]> {
        return respository.fetchDrugs()
            .flatMap { (drugs) -> Observable<[DrugCellViewModel]> in
                var viewModels = [DrugCellViewModel]()
                for drug in drugs.items {
                    viewModels.append(DrugCellViewModel.init(drugModel: drug))
                }
                return Observable.just(viewModels)
        }
    }
}
