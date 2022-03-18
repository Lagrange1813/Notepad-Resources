//
//  DrugsRespository.swift
//  RxSwiftMVVMDemo
//
//  Created by wujuan on 2019/7/29.
//  Copyright © 2019 guahao. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class DrugsRespository {
    var apiClient: APIClient
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func fetchDrugs() -> Observable<Drugs> {
        return apiClient.getDrugsTask()
    }
    
}
