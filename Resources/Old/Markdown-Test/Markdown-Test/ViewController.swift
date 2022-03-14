//
//  ViewController.swift
//  Markdown-Test
//
//  Created by 张维熙 on 2022/2/3.
//

import UIKit
import Markdown

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemGray
        var testView = UITextView(frame: CGRect(x: 10, y: 100, width: 380, height: 600))
        testView.backgroundColor = .white
        view.addSubview(testView)
        
        let source = """
Opening paragraph, with an ordered list of autumn leaves I found

1. A big leaf
1. Some small leaves:
    1. Red (nested)
    2. **Orange**
    3. Yellow
1. A medium sized leaf that ~~maybe~~ was pancake shaped

Unordered list of fruits:

- Blueberries
- Apples
    - Macintosh
    - Honey crisp
    - Cortland
- Banana

### Fancy Header Title

Here's what someone said:

> I think blockquotes are cool

Nesting **an *[emphasized link](https://apolloapp.io)* inside strong text**, neato!

And then they mentiond code around `NSAttributedString` that looked like this code block:

```swift
func yeah() -> NSAttributedString {
    // TODO: Write code
}
```

Tables are even supported but (but need more than `NSAttributedString`  for support :p)
"""
        let document = Document(parsing: source)
        
        var markdown = Markdownosaur()
        let attributedString = markdown.attributedString(from: document)
        
        testView.isEditable = false
        testView.attributedText = attributedString
    }


}

