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
        view.backgroundColor = fetchColor(place: .bodyBG, mode: .light)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
        
        configureTextView()
        configureToolBar()
        configureTitleBar()
//        configureStatusBarBackground()
        configureCounter()
        
        registNotification()
        
        configureTitleBarBtnAction()
        configureToolBarBtnAction()
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

    func configureStatusBarBackground() {
        let background = UIView(frame: CGRect(x: 0, y: 0, width: ScreenSize.width, height: ScreenSize.topPadding! - 1))
        background.backgroundColor = fetchColor(place: .bodyBG, mode: .light)
        view.addSubview(background)
    }
    
    func configureTitleBar() {
        titleBar = TitleBar(frame: CGRect(x: ScreenSize.width/2 - ToolBar.width()/2,
                                          y: ScreenSize.topPadding! + titleBarOffset,
                                          width: ToolBar.width(),
                                          height: TitleBar.height()))
        view.addSubview(titleBar)
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
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(5 + TitleBar.height() + titleBarOffset)
//            make.trailing.equalTo(articleField).inset(5)
            make.trailing.equalTo(articleField).offset(10)
            make.width.equalTo(55)
            make.height.equalTo(20)
        }
        let temp = articleField.titleView.text + articleField.bodyView.text
        counter.refreshLabel(temp.count)
        refreshCounter()
    }

    func refreshCounter() {
        counter.snp.updateConstraints { make in
            make.width.equalTo(counter.width + 11)
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
        
//        toolBar.gestureHandler = { [self] in
//            let pan = self.toolBar.panGestureRecognizer
//            let velocity = pan!.velocity(in: articleField).y
//
//            if velocity < -200 {
//                UIView.animate(withDuration: 0.3, animations: {
//                    self.titleBar.frame.origin.y -= 50
//                })
//
//            } else if velocity > 200 {
//                UIView.animate(withDuration: 0.3, animations: {
//                    self.titleBar.frame.origin.y = ScreenSize.topPadding!
//                })
//            }
//        }
    }
}

extension CurrentTextVC: UIScrollViewDelegate, UITextViewDelegate {}
