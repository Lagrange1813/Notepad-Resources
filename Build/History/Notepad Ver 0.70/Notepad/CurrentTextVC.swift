//
//  ViewController.swift
//  Notepad
//
//  Created by 张维熙 on 2022/1/23.
//

import CoreData
import SnapKit
import UIKit

class CurrentTextVC: UIViewController {
    var articleField: PureTextView!
    var articles: [NSManagedObject] = []
    var counter: WordCounter!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = ColorCollection.lightBodyBG
        configureNavigationBar()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
        configureTextView()
        configureCounter()
        configureToolBar()
    }

    func configureNavigationBar() {
        navigationItem.title = "卡拉马佐夫兄弟"
//        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isTranslucent = false

        let bar = UINavigationBarAppearance()
        bar.backgroundColor = ColorCollection.lightNavigation
        bar.titleTextAttributes = [.foregroundColor: ColorCollection.lightTitleText]
        if #available(iOS 15.0, *) {
            bar.backgroundEffect = nil
            self.navigationController?.navigationBar.scrollEdgeAppearance = bar
            self.navigationController?.navigationBar.standardAppearance = bar
        }
    }
    
    func loadData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Article")

        do {
            articles = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }

    func configureTextView() {
        articleField = PureTextView(frame: CGRect(), textContainer: nil)
        articleField.delegate = self
        configureText(articleField)
        view.addSubview(articleField)

        articleField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(5)
        }
    }
    
    func configureText(_ articleField: PureTextView) {
        let index = articles.count
        let text = articles[index - 1]
        articleField.configureText(title: text.value(forKey: "title") as! String,
                                   body: text.value(forKey: "body") as! String)
    }
    
    func configureCounter() {
        counter = WordCounter()
        view.addSubview(counter)
        counter.snp.makeConstraints { make in
            make.top.equalTo(articleField).offset(5)
            make.trailing.equalTo(articleField).inset(5)
            make.width.equalTo(55)
            make.height.equalTo(20)
        }
        counter.refreshLabel(articleField.text.count)
        refreshCounter()
    }
    
    func refreshCounter() {
        counter.snp.updateConstraints { make in
            make.width.equalTo(counter.width + 5)
        }
    }
    
    func configureToolBar() {
        let tool = ToolBar()
        view.addSubview(tool)
        
        tool.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.width.equalTo(tool.width)
            make.height.equalTo(tool.height)
        }
    }

    func test() {
        let btn = BtnWithArgu()
        btn.setTitle("Test", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.setTitleColor(.systemGray, for: .highlighted)
        btn.argument = "\\\""

        view.addSubview(btn)

        btn.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.width.height.equalTo(50)
        }

        btn.addTarget(self, action: #selector(insertFromCursor), for: .touchUpInside)
    }

    @objc func insertFromCursor(sender: BtnWithArgu, forEvent event: UIEvent) {
        let range = articleField.selectedRange
        let start = articleField.position(from: articleField.beginningOfDocument, offset: range.location)!
        let end = articleField.position(from: start, offset: range.length)!
        let textRange = articleField.textRange(from: start, to: end)!
        articleField.replace(textRange, withText: sender.argument!)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pan = scrollView.panGestureRecognizer
        let velocity = pan.velocity(in: scrollView).y
        navigationController?.navigationBar.barStyle = .black
        if velocity < -100 {
//            UIView.animate(withDuration: 0.3,
//                           animations: {
//                self.navigationController?.isNavigationBarHidden = true
//            })
            self.navigationController?.isNavigationBarHidden = true
        } else if velocity > 100 {
            UIView.animate(withDuration: 0.3,
                           animations: {
                self.navigationController?.isNavigationBarHidden = false
            })
        }
    }
}

extension CurrentTextVC: UITextViewDelegate {}
