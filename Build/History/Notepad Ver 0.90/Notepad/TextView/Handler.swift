//
//  Handler.swift
//  Notepad
//
//  Created by 张维熙 on 2022/1/25.
//

import CoreData
import UIKit

extension CurrentTextVC {
    func textViewDidChange(_ textView: UITextView) {
        if textView == articleField.bodyView {
            articleField.bodyView.sizeToFit()
            updateUnRedoButtons()
            refreshAndGetText()
        } else if textView == articleField.titleView {
            articleField.titleView.sizeToFit()
            updateUnRedoButtons()
            refreshAndGetText()
        }
        articleField.resize()
    }

    func refreshAndGetText() {
        let temp = articleField.titleView.text! + articleField.bodyView.text!

        counter.refreshLabel(temp.count)
        refreshCounter()

        let titleToStore: String = articleField.titleView.text
        let bodyToStore: String = articleField.bodyView.text

        saveData(title: titleToStore, body: bodyToStore)
    }
}

func saveData(title: String, body: String) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

    let managedContext = appDelegate.persistentContainer.viewContext

    let entity = NSEntityDescription.entity(forEntityName: "Article", in: managedContext)!
    let article = NSManagedObject(entity: entity, insertInto: managedContext)
    article.setValue(title, forKeyPath: "title")
    article.setValue(body, forKey: "body")

    do { try managedContext.save()
    } catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
    }
}
