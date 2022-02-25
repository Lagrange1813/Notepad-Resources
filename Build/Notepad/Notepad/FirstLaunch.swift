//
//  FirstLaunch.swift
//  Notepad
//
//  Created by 张维熙 on 2022/1/25.
//

import CoreData
import UIKit

extension UserDefaults {
    static func isFirstLaunch() -> Bool {
        let hasBeenLaunched = "hasBeenLaunched"
        let isFirstLaunch = !UserDefaults.standard.bool(forKey: hasBeenLaunched)
        if isFirstLaunch {
            UserDefaults.standard.set(true, forKey: hasBeenLaunched)
            UserDefaults.standard.synchronize()
        }
        return isFirstLaunch
    }
}

func firstStart() {
    let testTitle = "README"
    let testBody = "#Header 1\n##Header 2\n###Header 3\n\nThis is some **bold** text.\nThis is some *italic* text.\nThis is some `inline code`.\nThis is a custom @regex rule.\n\nThis is a custom [URL](http://google.com).\nThis is an image ![image description](http://google.com).\n\n\nOpening paragraph, with an ordered list of autumn leaves I found\n\n1. A big leaf\n1. Some small leaves:\n\t1. Red (nested)\n\t2. **Orange**\n\t3. Yellow\n1. A medium sized leaf that ~~maybe~~ was pancake shaped\n\nUnordered list of fruits:\n\n- Blueberries\n- Apples\n\t- Macintosh\n\t- Honey crisp\n\t- Cortland\n- Banana\n\n### Fancy Header Title\n\nHere's what someone said:\n\n> I think blockquotes are cool\n\nNesting **an *[emphasized link](https://apolloapp.io)* inside strong text**, neato!\n\nAnd then they mentiond code around `NSAttributedString` that looked like this code block:\n\n```swift\nfunc yeah() -> NSAttributedString {\n\t// TODO: Write code\n}\n```\n\nTables are even supported but (but need more than `NSAttributedString`  for support :p)"

    saveData(title: testTitle, body: testBody, type: "MD")
}
