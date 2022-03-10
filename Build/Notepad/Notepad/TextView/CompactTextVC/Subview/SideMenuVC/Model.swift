//
//  Book.swift
//  Notepad
//
//  Created by 张维熙 on 2022/3/2.
//

import UIKit

enum ListItem: Hashable {
    case section(SectionItem)
    case book(BookItem)
    case text(TextItem)
    case blank(BlankItem)
}

struct BookItem: Hashable {
    let title: String
    let image: UIImage
    let texts: [TextItem]
    
    init(title: String) {
        self.title = title
        self.image = UIImage(systemName: "text.book.closed")!
        self.texts = []
    }
    
    init(title: String, image: String) {
        self.title = title
        self.image = UIImage(systemName: image)!
        self.texts = []
    }
    
    init(title: String, texts: [TextItem]) {
        self.title = title
        self.image = UIImage(systemName: "text.book.closed")!
        self.texts = texts
    }
    
    init(title: String, image: String, texts: [TextItem]) {
        self.title = title
        self.image = UIImage(systemName: image)!
        self.texts = texts
    }
}

struct TextItem: Hashable {
    let title: String
    let image: UIImage = UIImage(systemName: "doc.text")!
}

struct SectionItem: Hashable {
    let title: String
}

struct BlankItem: Hashable {
    
}
