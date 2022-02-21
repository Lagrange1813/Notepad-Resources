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
    
    var articleField: PureTextView!
    var articles: [NSManagedObject] = []
    var counter: WordCounter!
    
    var cursor: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = fetchColor(place: .bodyBG, mode: .light)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadData()
        
        configureTextView()
        configureCounter()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        articleField.resize()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        articleField.correctLayout(width: view.frame.width)
    }
    
    override func viewDidLayoutSubviews() {
        adjustView()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        splitViewController?.hide(.primary)
        
        if let articleField = articleField {
            articleField.correctLayout(width: view.frame.width)
        }

        coordinator.animate(alongsideTransition: nil) { _ in
            self.splitViewController?.hide(.primary)

            self.adjustView()
        }
    }
    
    func adjustView() {
        if let articleField = articleField {
            articleField.titleView.sizeToFit()
            articleField.bodyView.sizeToFit()
            articleField.resize()
        }
    }
    
    // MARK: - Load data
    
    func loadData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Article")

        do {
            articles = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    // MARK: - Configure components
    
    func configureTextView() {
        articleField = PureTextView(frame: CGRect())
        articleField.delegate = self
        articleField.bodyView.delegate = self
        articleField.titleView.delegate = self
        articleField.configureFont(fontName: "LXGW WenKai")
        
        configurePadding()
        
        configureText(articleField)
        
        view.addSubview(articleField)

        articleField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(topAnchor)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(bottomAnchor)
        }
    }
    
    func configurePadding() {
        articleField.setInsets(topPadding: topPadding, bottomPadding: bottomPadding)
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
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(5 + titleBarOffset + barHeight)
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
}

extension CommonTextVC: UIScrollViewDelegate, UITextViewDelegate {}
