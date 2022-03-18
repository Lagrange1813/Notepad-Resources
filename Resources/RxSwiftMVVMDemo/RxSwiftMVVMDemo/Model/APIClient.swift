//
//  APIClient.swift
//  RxSwiftMVVMDemo
//
//  Created by wujuan on 2019/7/29.
//  Copyright © 2019 guahao. All rights reserved.
//

import Foundation
import RxSwift

class APIClient {
    func getDrugsTask<T: Codable>() -> Observable<T> {
        return Observable<T>.create{ observer -> Disposable in
            let path = Bundle.main.path(forResource: "drugList", ofType: "json")!
            let url = URL(fileURLWithPath: path)
            do {
                let data = try Data(contentsOf: url)
                let model: T = try JSONDecoder().decode(T.self, from: data )
                observer.onNext(model)
                
            }catch let error{
                
                observer.onError(error)
                print("读取本地数据错误",error)
            }
            observer.onCompleted()
            return Disposables.create {
                //请求cancel
            }
        }
    }
}
