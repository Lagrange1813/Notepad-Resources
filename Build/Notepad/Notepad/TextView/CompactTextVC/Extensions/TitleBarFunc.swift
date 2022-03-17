//
//  TitleBarFunc.swift
//  Notepad
//
//  Created by 张维熙 on 2022/3/4.
//

import UIKit

extension CompactTextVC {
    func configureTitleBar() {
        titleBar = TitleBar(frame: CGRect(x: view.frame.width / 2 - (viewWidth - 10) / 2,
                            y: ScreenSize.topPadding! + titleBarOffset,
                            width: viewWidth - 10,
                            height: TitleBar.height()), theme)
        view.insertSubview(titleBar, at: 1)
    }

    func showTitleBar() {
        self.isTitleBarHidden = false
        UIView.animate(withDuration: 0.7, animations: {
            self.titleBar.frame.origin.y = ScreenSize.topPadding! + titleBarOffset
            
            self.titleBar.alpha = 1
        })
    }

    func hideTitleBar() {
        self.isTitleBarHidden = true
        UIView.animate(withDuration: 0.5, animations: {
            self.titleBar.frame.origin.y -= (TitleBar.height() + titleBarOffset + 5 + ScreenSize.topPadding!)
            
            
        })
        UIView.animate(withDuration: 0.3, animations: {
            self.titleBar.alpha = 0
        })
        
    }

    func configureTitleBarBtnAction() {
        titleBar.listBtn.addTarget(self, action: #selector(listBtnFunc), for: .touchUpInside)
        configureSwitchButton()
        titleBar.typeBtn.addTarget(self, action: #selector(typeBtnFunc), for: .touchUpInside)
    }

    func configureSwitchButton() {
        let books = fetchBook()
        var bookList: [String] = []
        var textList: [[Text]] = []

        for x in 0..<books.count {
            bookList.append(books[x].title!)
            textList.append([])
            let texts = books[x].text!
            for text in texts {
                textList[x].append(text as! Text)
            }
        }

        var bookBoard: [UIMenuElement] = []

        for x in 0..<bookList.count {
            var textBoard: [UIAction] = []
            for text in textList[x] {
                let item = UIAction(title: text.title!, image: UIImage(systemName: "doc.text")) { _ in
                    UserDefaults.standard.set(text.id!.uuidString, forKey: "CurrentTextID")
                    self.restart()
                }
                textBoard.append(item)
            }
            let item = UIMenu(title: bookList[x], image: UIImage(systemName: "book.closed"), children: textBoard)
            bookBoard.append(item)
        }

        let menu = UIMenu(title: "书籍", children: bookBoard)
        titleBar.listBtn.menu = menu
    }

    @objc func listBtnFunc() {
        triggerSideMenu(expand: true)
    }

    @objc func typeBtnFunc() {
        let id = UUID(uuidString: UserDefaults.standard.value(forKey: "CurrentTextID") as! String)
        let titleToStore: String = textField.titleView.text
        let bodyToStore: String = textField.bodyView.text

        saveText(id: id!, title: titleToStore, body: bodyToStore, type: {
            switch type {
            case "Text": return "MD"
            case "MD": return "Text"
            default: return ""
            }
        }())
        restart()
    }
}
