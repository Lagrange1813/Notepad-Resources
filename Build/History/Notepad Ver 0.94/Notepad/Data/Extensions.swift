//
//  Extensions.swift
//  Notepad
//
//  Created by 张维熙 on 2022/1/23.
//

import CoreData
import Foundation
import UIKit

var hideSupplementary = false

// extension UIColor {
//    convenience init(hexString: String) {
//        let temp = Int(hexString) ?? 0
//        self.init(
//            red: CGFloat((temp >> 16) & 0xFF),
//            green: CGFloat((temp >> 8) & 0xFF),
//            blue: CGFloat(temp & 0xFF),
//            alpha: 1
//        )
//    }
// }

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

// enum Theme {
//    case defaultLight
//    case defaultDark
// }

// func fetchConfiguration(theme: Theme) -> [String: AnyObject] {
//    switch theme {
//    case .defaultLight:
//        <#code#>
//    case .defaultDark:
//        <#code#>
//    }
// }
//
// let defaultLight = ["":"",
//                    "":"",
//                    "":""]

enum TonalCollocation {
    case bodyBG

    case titleText
    case bodyText

    case titleBarBG
    case countBG
    case toolBarBG

    case cursor
}

enum ColorMode {
    case light
    case dark
}

func fetchColor(place: TonalCollocation, mode: ColorMode) -> UIColor {
    switch mode {
    case .light:
        switch place {
        case .bodyBG:
            return UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        case .titleText:
            return UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        case .bodyText:
            return UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        case .titleBarBG:
            return UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        case .countBG:
            return UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        case .toolBarBG:
            return UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        case .cursor:
            return UIColor(red: 0.2941176, green: 0.415686, blue: 0.917647, alpha: 1)
        }

    case .dark:
        return UIColor()
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

    static let cursorColor = UIColor(red: 0.2941176, green: 0.415686, blue: 0.917647, alpha: 1)
}

enum FontCollection {
    static let titleFont = UIFont(name: "LXGW WenKai", size: 0)
}

enum Font {
    case bookTitle
    case articleTitle
    case articleBody
}

func fetchFont(font: Font) -> UIFont {
    switch font {
    case .bookTitle:
        return UIFont(name: "LXGW WenKai Bold", size: 16)!
    case .articleTitle:
        return UIFont(name: "LXGW WenKai Bold", size: 15)!
    case .articleBody:
        return UIFont(name: "LXGW WenKai", size: 13)!
    }
}

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
