//
//  ViewController.swift
//  Notepad
//
//  Created by 张维熙 on 2022/1/23.
//

import SnapKit
import UIKit
import CoreData

class CurrentTextVC: UIViewController {
    var articleField: PureTextView!
    var articles: [NSManagedObject] = []
    var counter: WordCounter!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = ColorCollection.bodyBackground
        configureNavigationBar()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

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
        
        configureTextView()
        configureCounter()
    }

    func configureNavigationBar() {
        navigationItem.title = "卡拉马佐夫兄弟"
//        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isTranslucent = false

        let bar = UINavigationBarAppearance()
        bar.backgroundColor = ColorCollection.navigation
        bar.titleTextAttributes = [.foregroundColor: UIColor(red: 1, green: 1, blue: 1, alpha: 1)]
        if #available(iOS 15.0, *) {
            bar.backgroundEffect = nil
            self.navigationController?.navigationBar.scrollEdgeAppearance = bar
            self.navigationController?.navigationBar.standardAppearance = bar
        }
    }

    func configureCounter() {
        counter = WordCounter()
        view.addSubview(counter)
        counter.refreshLabel(articleField.text.count)
    }

    func configureTextView() {
        articleField = PureTextView(frame: CGRect(), textContainer: nil)
        articleField.delegate = self
        configureText(articleField)
        view.addSubview(articleField)

        articleField.snp.makeConstraints { make in
            make.leading.top.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }

    func configureText(_ articleField: PureTextView) {
        let index = articles.count
        let text = articles[index-1]
        articleField.configureText(title: text.value(forKey: "title") as! String,
                                   body: text.value(forKey: "body") as! String)
//        articleField.isScrollEnabled = false
    }
    
    
}

extension CurrentTextVC: UITextViewDelegate {}
