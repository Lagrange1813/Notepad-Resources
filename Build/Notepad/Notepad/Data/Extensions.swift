//
//  Extensions.swift
//  Notepad
//
//  Created by 张维熙 on 2022/1/23.
//

import CoreData
import Foundation
import UIKit

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

func isFullScreen() -> Bool {
    if ScreenSize.bottomPadding! > 0 { return true }
    else { return false }
}

enum ColorCollection {
    static let lightBodyBG = UIColor(red: 1, green: 1, blue: 1, alpha: 1)

    static let lightTitleText = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
    static let lightBodyText = UIColor(red: 0, green: 0, blue: 0, alpha: 1)

    static let lightTitleBar = UIColor(red: 1, green: 1, blue: 1, alpha: 1)

    static let lightCountBG = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
    static let lightToolBG = UIColor(red: 1, green: 1, blue: 1, alpha: 1)

    static let lightRightBG = UIColor(red: 0.94117, green: 0.94117, blue: 0.94117, alpha: 1)

    static let darkBodyBG = UIColor(red: 0.15686, green: 0.15686, blue: 0.15686, alpha: 1)
    static let darkBodyText = UIColor(red: 0.90196, green: 0.90196, blue: 0.90196, alpha: 1)
    static let darkNavigation = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
    static let darkCountBG = UIColor(red: 0.13333, green: 0.13333, blue: 0.13333, alpha: 0.6)
}

enum FontCollection {
    static let titleFont = UIFont(name: "LXGW WenKai", size: 0)
}

enum Font {
    case bookTitle
    case articleTitle
    case articleBody
}

//func fetchFont(font: Font) -> UIFont {
//    switch font {
//    case .bookTitle:
//        return UIFont(name: "LXGW WenKai Bold", size: 16)!
//    case .articleTitle:
//        return UIFont(name: "LXGW WenKai Bold", size: 15)!
//    case .articleBody:
//        return UIFont(name: "LXGW WenKai", size: 13)!
//    }
//}

/// 若 topPadding 大于 20， 返回 0 ，否则返回 10
let titleBarOffset: CGFloat = {
    if ScreenSize.topPadding! > 20 {
        return 0
    } else {
        return 10
    }
}()

enum ScreenSize {
    static let width = UIScreen.main.bounds.width
    static let height = UIScreen.main.bounds.height

    static let window = UIApplication.shared.windows.first
    static let topPadding = window?.safeAreaInsets.top
    static let bottomPadding = window?.safeAreaInsets.bottom
}

extension String {
    func range(from nsRange: NSRange) -> Range<String.Index>? {
        guard
            let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex),
            let to16 = utf16.index(from16, offsetBy: nsRange.length, limitedBy: utf16.endIndex),
            let from = String.Index(from16, within: self),
            let to = String.Index(to16, within: self)
            else { return nil }
        return from ..< to
    }
    
    func nsRange(from range: Range<String.Index>) -> NSRange {
        let from = range.lowerBound.samePosition(in: utf16)
        let to = range.upperBound.samePosition(in: utf16)
        return NSRange(location: utf16.distance(from: utf16.startIndex, to: from!),
                       length: utf16.distance(from: from!, to: to!))
    }
    
    func toRegex() -> NSRegularExpression {
        var pattern: NSRegularExpression = NSRegularExpression()

        do {
            try pattern = NSRegularExpression(pattern: self, options: .anchorsMatchLines)
        } catch {
            print(error)
        }

        return pattern
    }
}

// MARK: - Core Data configuration

//enum EntityType {
//    case Book
//    case Text
//}
func fetchBook() -> [Book] {
//    let type: String = {
//        switch fetchType {
//        case .Book:
//            return "Book"
//        case .Text:
//            return "Text"
//        }
//    }()
    
    var results: [Book] = []
    
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [] }

    let managedContext = appDelegate.persistentContainer.viewContext
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Book")

    do {
        results = try managedContext.fetch(fetchRequest) as! [Book]
    } catch let error as NSError {
        print("Could not fetch. \(error), \(error.userInfo)")
    }
    
    return results
}

func saveText(title: String, body: String, type: String) {
    saveText(title: title, body: body, type: type, bookName: "卡拉马佐夫兄弟")
}

func saveText(title: String, body: String, type: String, bookName: String) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

    let managedContext = appDelegate.persistentContainer.viewContext

    let entity = NSEntityDescription.entity(forEntityName: "Text", in: managedContext)!
//    let text = NSManagedObject(entity: entity, insertInto: managedContext)
//    text.setValue(title, forKey: "title")
//    text.setValue(body, forKey: "body")
//    text.setValue(type, forKey: "type")
    let text = Text(entity: entity, insertInto: managedContext)
    text.title = title
    text.body = body
    text.type = type
    
    var books: [NSManagedObject]!
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Book")
    do {
        books = try managedContext.fetch(fetchRequest)
    } catch let error as NSError {
        print("Could not fetch. \(error), \(error.userInfo)")
    }
    
    var targetBook: Book!
    for book in books {
        if (book.value(forKey: "title") as! String) == bookName {
            targetBook = (book as! Book)
        }
    }
    text.book = targetBook

    do { try managedContext.save()
    } catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
    }
}

func saveBook(title: String, author: String) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

    let managedContext = appDelegate.persistentContainer.viewContext

    let entity = NSEntityDescription.entity(forEntityName: "Book", in: managedContext)!
//    let article = NSManagedObject(entity: entity, insertInto: managedContext)
//    article.setValue(title, forKeyPath: "title")
//    article.setValue(author, forKey: "author")
    
    let book = Book(entity: entity, insertInto: managedContext)
    book.title = title
    book.author = author

    do { try managedContext.save()
    } catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
    }
}
