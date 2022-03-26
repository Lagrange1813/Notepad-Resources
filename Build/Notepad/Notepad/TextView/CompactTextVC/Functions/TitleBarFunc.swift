//
//  TitleBarFunc.swift
//  Notepad
//
//  Created by 张维熙 on 2022/3/4.
//

import UIKit

extension CompactTextVC {
  func configureTitleBar() {
    let titleBarConnector = TitleBarConnector(frame: CGRect(x: view.frame.width / 2 - (viewWidth - 10) / 2,
                                                            y: ScreenSize.topPadding! + titleBarOffset,
                                                            width: viewWidth - 10,
                                                            height: TitleBar.height()),
                                              bag: bag,
                                              traitCollection: traitCollection,
                                              functions: (listBtn: listBtnFunc,
                                                          listMenu: fetchListBtnMenu(),
                                                          typeBtn: typeBtnFunc))
    titleBar = titleBarConnector.view
    view.insertSubview(titleBar, at: 3)
  }
  
  func fetchListBtnMenu() -> UIMenu {
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
    
    return menu
  }
  
  func listBtnFunc() {
    triggerSideMenu(expand: true)
  }
  
  func typeBtnFunc() {
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
  
  // MARK: - Auto Response
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if !fullScreen {
      let pan = scrollView.panGestureRecognizer
      let velocity = pan.velocity(in: scrollView).y

      if velocity < -200 {
        if !isTitleBarHidden {
          hideTitleBar()
        }
//                navigationController?.prefersStatusBarHidden = true

      } else if velocity > 200 {
        showTitleBar()
//                isTitleBarHidden = false
      }

      if textField.contentOffset.y <= -(TitleBar.height() + titleBarOffset) + 10 {
        showTitleBar()
//                isTitleBarHidden = true
      }
    }
  }
  
  func showTitleBar() {
    guard let titleBar = titleBar else { return }
    
    isTitleBarHidden = false
    UIView.animate(withDuration: 0.7, animations: {
      titleBar.frame.origin.y = ScreenSize.topPadding! + titleBarOffset
      titleBar.alpha = 1
    })
  }
  
  func hideTitleBar() {
    isTitleBarHidden = true
    UIView.animate(withDuration: 0.5, animations: {
      self.titleBar.frame.origin.y -= (TitleBar.height() + titleBarOffset + 5 + ScreenSize.topPadding!)
    })
    UIView.animate(withDuration: 0.3, animations: {
      self.titleBar.alpha = 0
    })
  }
}
