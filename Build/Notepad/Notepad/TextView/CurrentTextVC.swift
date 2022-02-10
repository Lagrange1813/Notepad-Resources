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
    var titleBar: TitleBar!
    var toolBar: ToolBar!

    var cursor: UIView?

    var isKeyboardHasPoppedUp = false
    var moveDistance: CGFloat?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = ColorCollection.lightBodyBG
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
        configureTextView()
        configureToolBar()
        configureTitleBar()
        configureCounter()
        registNotification()
        configureBtnAction()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        articleField.resize()
        updateUnRedoButtons()
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
    
    func configureTitleBar() {
////        navigationItem.title = "卡拉马佐夫兄弟"
////        navigationController?.navigationBar.barStyle = .black
//        navigationController?.navigationBar.isTranslucent = true
//
//        let bar = UINavigationBarAppearance()
//        bar.backgroundColor = ColorCollection.lightNavigation
//        bar.titleTextAttributes = [.foregroundColor: ColorCollection.lightTitleText]
//        if #available(iOS 15.0, *) {
//            bar.backgroundEffect = nil
//            self.navigationController?.navigationBar.scrollEdgeAppearance = bar
//            self.navigationController?.navigationBar.standardAppearance = bar
//        }
        titleBar = TitleBar()
        view.addSubview(titleBar)
        
        titleBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.centerX.equalToSuperview()
            make.width.equalTo(ToolBar.width())
            make.height.equalTo(titleBar.height)
        }
    }


    func configureTextView() {
        articleField = PureTextView(frame: CGRect())
        articleField.delegate = self
        articleField.bodyView.delegate = self
        articleField.titleView.delegate = self
        articleField.configureFont(fontName: "LXGW WenKai")
        configureText(articleField)
        view.addSubview(articleField)

        articleField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
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
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10 + TitleBar.height())
            make.trailing.equalTo(articleField).inset(5)
            make.width.equalTo(55)
            make.height.equalTo(20)
        }
        let temp = articleField.titleView.text + articleField.bodyView.text
        counter.refreshLabel(temp.count)
        refreshCounter()
    }

    func refreshCounter() {
        counter.snp.updateConstraints { make in
            make.width.equalTo(counter.width + 5)
        }
    }

    func configureToolBar() {
        toolBar = ToolBar()
        view.addSubview(toolBar)

        toolBar.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            if ScreenSize.bottomPadding! > 0 {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(5)
            }
            make.width.equalTo(toolBar.width)
            make.height.equalTo(toolBar.height)
        }
    }
}

extension CurrentTextVC: UIScrollViewDelegate, UITextViewDelegate {}
