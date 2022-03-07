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
}

struct BookItem: Hashable {
    let title: String
    let image = UIImage(systemName: "text.book.closed")!
    let texts: [TextItem]
}

struct TextItem: Hashable {
    let title: String
    let image: UIImage = UIImage(systemName: "doc.text")!
}

struct SectionItem: Hashable {
    let title: String
}
