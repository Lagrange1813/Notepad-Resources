//
//  MDPreviewVC.swift
//  Notepad
//
//  Created by 张维熙 on 2022/2/21.
//

import UIKit
import CoreData

class MDPreviewVC: UIViewController {
    var titleString: String = "" {
        didSet {
            guard let textField = textField else { return }
            textField.titleView.text = titleString
            adjustView()
        }
    }

    var bodyString: String = "" {
        didSet {
            guard let textField = textField else { return }
            textField.body = bodyString
            adjustView()
        }
    }

    var contentOffsetProportion: CGFloat = 0 {
        didSet {
            guard let textField = textField else { return }
            guard textField.contentSize.height > 0 else { return }
            textField.contentOffset.y = textField.contentSize.height * contentOffsetProportion
        }
    }

    var barHeight: CGFloat = 0
    
    var topAnchor: CGFloat = 0
    var bottomAnchor: CGFloat = 0
    
    var topPadding: CGFloat = 0
    var bottomPadding: CGFloat = 0
    
    var showCounter: Bool = true
    
    var textField: MDSubView!
    
    var texts: [NSManagedObject] = []
    var counter: WordCounter!
    
    var theme = Theme.BuiltIn.Default.enable()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
    
    // MARK: - Configure components
    
    func loadData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Text")

        do {
            texts = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func configureTextView() {
      textField = MDSubView(theme: theme.main)
        textField.delegate = self
        
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
    
    func configureText(_ textField: MDSubView) {
        let index = texts.count
        let text = texts[index - 1]
        textField.configureText(title: text.value(forKey: "title") as! String,
                                   body: text.value(forKey: "body") as! String)
    }
    
    func configurePadding() {
        textField.setInsets(topPadding: topPadding, bottomPadding: bottomPadding)
    }
    
    func configureCounter() {
      counter = WordCounter(theme.main)
        view.addSubview(counter)
        counter.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(5 + titleBarOffset + barHeight)
            make.trailing.equalTo(textField).offset(10)
            make.width.equalTo(55)
            make.height.equalTo(20)
        }
        let temp = textField.titleView.text + (textField.body ?? "")
        counter.refreshLabel(temp.count)
        
        refreshCounter()
    }

    func refreshCounter() {
        counter.snp.updateConstraints { make in
            make.width.equalTo(counter.width + 11)
        }
    }
}

extension MDPreviewVC: UIScrollViewDelegate {}
