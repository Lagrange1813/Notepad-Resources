//
//  RxSwiftMVVMDemoTests.swift
//  RxSwiftMVVMDemoTests
//
//  Created by wujuan on 2019/7/25.
//  Copyright © 2019 guahao. All rights reserved.
//

import XCTest
import RxSwift
import RxBlocking

@testable import RxSwiftMVVMDemo

class RxSwiftMVVMDemoTests: XCTestCase {
    let vm = DrugViewModel()

    let reloadSubject = PublishSubject<[DrugCellViewModel]>()
    let editSubject = PublishSubject<DrugCellViewModel>()
    let deleteTrigger = PublishSubject<DrugCellViewModel>()

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testInitDataSource() {
        let disposeBag = DisposeBag()

        let expect = expectation(description: #function)
        var result: [DrugCellViewModel] = []
        var resultToalCount: String = ""

        let input = DrugViewModel.Input(reload: reloadSubject, editTrigger: editSubject, deleteTrigger: deleteTrigger )
        let output = vm.transform(input: input)
        output.items.skip(1).subscribe{
            result = $0.event.element ?? []
            expect.fulfill()
        }.disposed(by: disposeBag)
        
        output.totalCount.drive(onNext: { (content) in
            resultToalCount = content
        }).disposed(by: disposeBag)
        
        reloadSubject.onNext([])
        
        waitForExpectations(timeout: 1.0) { error in
            guard error == nil else {
                XCTFail(error!.localizedDescription)
                return
            }
            XCTAssertEqual(3, result.count)
            XCTAssertEqual("共3味药，7g，药品参考总价:43.0元", resultToalCount)
        }
    }

    func testInitDataSource2() {
        let input = DrugViewModel.Input(reload: reloadSubject, editTrigger: editSubject, deleteTrigger: deleteTrigger )
        let output = vm.transform(input: input)
        reloadSubject.onNext([])
        
        do {
            guard let result = try output.items.toBlocking(timeout:
                1.0).first() else { return }
            guard let resultToalCount = try output.totalCount.toBlocking(timeout:
                1.0).first() else { return }

            XCTAssertEqual(result.count, 3)
            XCTAssertEqual("共3味药，7g，药品参考总价:43.0元", resultToalCount)
        } catch {
            print(error)
        }
    }
    
    func testTapEditTrigger() {
        let input = DrugViewModel.Input(reload: reloadSubject, editTrigger: editSubject, deleteTrigger: deleteTrigger )
        let output = vm.transform(input: input)
        reloadSubject.onNext([])
        
        var items: [DrugCellViewModel]? = nil

        do {
            guard let result = try output.items.toBlocking(timeout:
                1.0).first() else { return }
            
            items = result
        } catch {
            print(error)
        }
        
        let first = items!.first!
        first.drugCount = 3
        editSubject.onNext(first)
        
        do {
            guard let result = try output.items.toBlocking(timeout:
                1.0).first() else { return }
            guard let resultToalCount = try output.totalCount.toBlocking(timeout:
                1.0).first() else { return }
            
            XCTAssertEqual(result.count, 3)
            XCTAssertEqual("共3味药，9g，药品参考总价:51.0元", resultToalCount)
        } catch {
            print(error)
        }

        first.drugCount = 0
        editSubject.onNext(first)

        do {
            guard let result = try output.items.toBlocking(timeout:
                1.0).first() else { return }
            guard let resultToalCount = try output.totalCount.toBlocking(timeout:
                1.0).first() else { return }
            
            XCTAssertEqual(result.count, 3)
            XCTAssertEqual("共3味药，6g，药品参考总价:39.0元", resultToalCount)
        } catch {
            print(error)
        }
    }
    
    
    func testTapDeleteTrigger() {
        let input = DrugViewModel.Input(reload: reloadSubject, editTrigger: editSubject, deleteTrigger: deleteTrigger )
        let output = vm.transform(input: input)
        reloadSubject.onNext([])
        
        var items: [DrugCellViewModel]? = nil
        do {
            guard let result = try output.items.toBlocking(timeout:
                1.0).first() else { return }
            items = result

        } catch {
            print(error)
        }
        
        deleteTrigger.onNext(items!.first!)
        
        do {
            guard let result = try output.items.toBlocking(timeout:
                1.0).first() else { return }
            guard let resultToalCount = try output.totalCount.toBlocking(timeout:
                1.0).first() else { return }
            
            XCTAssertEqual(result.count, 2)
            XCTAssertEqual("共2味药，6g，药品参考总价:39.0元", resultToalCount)
        } catch {
            print(error)
        }
        
    }
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
