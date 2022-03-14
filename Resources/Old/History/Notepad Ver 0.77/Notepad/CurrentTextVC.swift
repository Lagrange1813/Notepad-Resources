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
    var toolBar: ToolBar!

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
        registNotification()
        configureBtnAction()
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

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pan = scrollView.panGestureRecognizer
        let velocity = pan.velocity(in: scrollView).y
        navigationController?.navigationBar.barStyle = .black
        if velocity < -200 {
            UIView.animate(withDuration: 0.3, animations: {
//                self.navigationController?.isNavigationBarHidden = true  WOC, NB!
                self.navigationController?.setNavigationBarHidden(true, animated: true)
            })
//            navigationController?.isNavigationBarHidden = true
        } else if velocity > 200 {
            UIView.animate(withDuration: 0.3, animations: {
                self.navigationController?.isNavigationBarHidden = false
            })
        }
    }

    func registNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleKeyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleKeyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func handleKeyboardWillShow(notification: NSNotification) {
        print("It will appear")

        let keyboardInfo = notification.userInfo as NSDictionary?
        let value = keyboardInfo?.object(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! CGRect
        let moveDistance = value.height - ScreenSize.bottomPadding! + 5
        print(moveDistance)

        UIView.animate(withDuration: 1, animations: {
            self.toolBar.snp.updateConstraints { make in
                make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(moveDistance)
            }
        })
        view.layoutIfNeeded()
    }

    @objc func handleKeyboardWillHide() {
        UIView.animate(withDuration: 1, animations: {
            self.toolBar.snp.updateConstraints { make in
                if ScreenSize.bottomPadding! > 0 {
                    make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
                } else {
                    make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(5)
                }
            }
        })
        view.layoutIfNeeded()
    }
}

extension CurrentTextVC: UITextViewDelegate {}
