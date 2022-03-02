//
//  CommonTextVC.swift
//  Notepad
//
//  Created by 张维熙 on 2022/2/19.
//

import CoreData
import SnapKit
import UIKit

class CommonTextVC: UIViewController {
    var barHeight: CGFloat = 0
    
    var topAnchor: CGFloat = 0
    var bottomAnchor: CGFloat = 0
    
    var topPadding: CGFloat = 0
    var bottomPadding: CGFloat = 0
    
    var showCounter: Bool = true
    var toSaveText: Bool = true
    
    var textField: BaseTextView!
    
    var type: String!
    
    var texts: [NSManagedObject] = []
    var counter: WordCounter!
    
    var theme: Theme!
    var textTheme: Theme!
    var markdownTheme: Theme!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        loadType()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        loadTextView()
        
        configureTextView()
        if showCounter {
            configureCounter()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textField.resize()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        textField.correctLayout(width: view.frame.width)
    }
    
    override func viewDidLayoutSubviews() {
        adjustView()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        if let textField = textField {
            textField.correctLayout(width: view.frame.width)
        }

        coordinator.animate(alongsideTransition: nil) { _ in
            self.adjustView()
        }
    }
    
    func adjustView() {
        if let textField = textField {
            textField.titleView.sizeToFit()
            textField.bodyView.sizeToFit()
            textField.resize()
        }
    }
    
    // MARK: - Load data
    
    func loadData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Text")

        do {
            texts = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
//        texts = fetchData(.Text)!
    }
    
    func loadType() {
        let index = texts.count
        let text = texts[index - 1]
        self.type = (text.value(forKey: "type") as! String)
    }
    
    func loadTheme() {
        switch type {
        case "Text": self.theme = textTheme
        case "MD": self.theme = markdownTheme
        default: return
        }
    }
    
    func loadTextView() {
        switch type {
        case "Text": textField = PureTextView(theme)
        case "MD": textField = MDTextView(theme)
        default: return
        }
    }
    
    // MARK: - Configure components
    
    func configureTextView() {
        textField.delegate = self
        textField.bodyView.delegate = self
        textField.titleView.delegate = self
        
        configurePadding()
        
        view.addSubview(textField)

        textField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(topAnchor)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(bottomAnchor)
        }
        
        configureText(textField)
    }
    
    func configurePadding() {
        textField.setInsets(topPadding: topPadding, bottomPadding: bottomPadding)
    }
    
    func configureText(_ textField: BaseTextView) {
        let index = texts.count
        let text = texts[index - 1]
        textField.configureText(title: text.value(forKey: "title") as! String,
                                   body: text.value(forKey: "body") as! String)
    }
    
    func configureCounter() {
        counter = WordCounter(theme)
        view.addSubview(counter)
        counter.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(5 + titleBarOffset + barHeight)
            make.trailing.equalTo(textField).offset(10)
            make.width.equalTo(55)
            make.height.equalTo(20)
        }
        let temp = textField.titleView.text + textField.bodyView.text
        counter.refreshLabel(temp.count)
        
        refreshCounter()
    }

    func refreshCounter() {
        counter.snp.updateConstraints { make in
            make.width.equalTo(counter.width + 11)
        }
    }
}

extension CommonTextVC: UIScrollViewDelegate, UITextViewDelegate {}
