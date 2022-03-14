//
//  ViewController.swift
//  观辞
//
//  Created by 张维熙 on 2022/1/22.
//

import SnapKit
import UIKit

class CurrentTextVC: UIViewController {
    var articleField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = ColorCollection.bodyBackground
        configureNavigationBar()
        configureTextView()
        configureCounter()
    }
    
    func configureNavigationBar() {
        navigationItem.title = "观辞"
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isTranslucent = false
        let bar = UINavigationBarAppearance()
        bar.backgroundColor = ColorCollection.navigation
        bar.titleTextAttributes = [.foregroundColor: UIColor(red: 1, green: 1, blue: 1, alpha: 1)]
        if #available(iOS 15.0, *) {
            bar.backgroundEffect = nil
            self.navigationController?.navigationBar.scrollEdgeAppearance = bar
            self.navigationController?.navigationBar.standardAppearance = bar
        }
//        self.navigationController?.navigationBar.barTintColor = .white
    }
    
    func configureCounter() {
        let counter = WordCount()
        view.addSubview(counter)
        counter.refreshLabel(articleField.text.lengthOfBytes(using: .unicode))
    }

    func configureTextView() {
//        let height = navigationController!.navigationBar.frame.height + UIApplication.shared.statusBarFrame.height
//        let articleField = UITextView(frame: CGRect(x: 0,
//                y: 0,
//                width: view.frame.width,
//                height: view.frame.height - height))
        articleField = UITextView()
        articleField.delegate = self
        customTextStyle(articleField)
        view.addSubview(articleField)
        
        articleField.snp.makeConstraints { make in
            make.leading.top.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }

    func customTextStyle(_ articleField: UITextView) {
        let testTitle = "卡拉马佐夫兄弟\n"
        let testBody = "我不知道首席法官是不是已把检察官和辩护律师双方的证人分成两摊，并且规定了召唤他们的程序。大概这一切是有的。我只知道他首先召唤的是检察官方面的证人。\n我要重复一句，我不打算一步步依次描写全部的审问过程。何况那样我的描述一部分会是重复多余的，因为在检察官和律师辩论时的演词里，所有提供和听取的证词的整个情况及其全部含意，将会仿佛都集中到一点上，加以鲜明而突出的说明的，这两段出色的演词我至少在许多部分都作了完整的记录，到时候自会向读者转述；此外还有一桩完全意料不到的非常事件我也记了下来，——这事还是在法庭的辩论开始以前突然发生的，对于这次审判的可怕而不祥的结局无疑发生了影响。\n我唯一要指出的是，这个案件有一种异常的特点，从开庭后最初的几分钟就鲜明地显示出来并被大家所觉察到了，那就是公诉方面的力量比起辩护方面所拥有的手段来，简直要强大得多。这一点，当各种事实在威严的法庭上集中聚拢起来，全部的恐怖和血腥渐渐地鲜明呈露出来的时候，大家一下子就感觉到了。也许仅仅只进行了最初的几步，大家就已开始明白，这简直是完全无可争辩的事情，这里面毫无疑义，实际上根本不必进行什么辩论，辩论只是走走形式，罪人是有罪的，显然有罪，完全有罪的。我甚至以为就连那些太太，尽管全体一致迫不及待地渴望着这个有趣的被告被宣告无罪，但同时却也完全深信他确实有罪。\n不但如此，我觉得，如果他的有罪不得到如此确切的证实，她们甚至要表示愤慨的，因为那样一来最后就不会有有罪的人被宣告无罪那样强烈的效果了。至于他将被宣告无罪这一点，奇怪的是所有的太太们，几乎直到最后一分钟还一直是完全深信不疑的，理由是：“他有罪，但是出于人道的动机，按照现在流行的新思想，新感情，他是会被宣告无罪的。”就因为这个，她们才那么急不可耐地纷纷聚集在这里。男子们最感兴趣的却是检察官和鼎鼎大名的费丘科维奇之间的斗争。大家奇怪，而且暗地问自己：对这样一件无望的案子，这样一个空蛋壳，即使费丘科维奇再有才干，还能干出什么来呢？因此他们全神贯注一步不漏地密切注视着他如何干这样一件大事。但是费丘科维奇直到最后起来发表他的那篇演词以前，在大家眼中始终显得象一个谜。有经验的人们预感到他自有一套，他已经拟定了什么计划，他眼前抱有一个目的，不过到底是什么样的目的，却简直无法猜到。但他的自信和自恃却是一目了然的。此外，大家立刻愉快地看出，他在逗留我们城里的极短时间内，也许只有三天工夫，竟能使人惊奇地把这案件弄得清清楚楚，并且“作了细致入微的研究”。\n例如，以后大家愉快地谈论，他怎样把所有检察官方面的证人及时地引“上钩”，尽可能地把他们窘住，主要的是给他们的道德名誉抹黑，这样自然也就给他们的证词抹了黑。不过大家以为，他这样做，大半是为了游戏，可以说是为了维持某种法律场面，表示丝毫也没有疏忽任何律师惯用的辩护手法，因为大家相信，用这类“抹黑”的办法并不能得到某种决定性的重大好处，这一点大概他自己比谁都明白，其实他一定心里还暗藏着某种想法，某种暂时还隐藏不露的辩护手段，只等时机一到，就会忽然把它拿出来。"

        articleField.backgroundColor = ColorCollection.bodyBackground
        articleField.textContainerInset = UIEdgeInsets(top: 20, left: 5, bottom: 20, right: 5)
        
        let titleFont = UIFont.systemFont(ofSize: 18)
        let titleColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        let titleParagraphStyle = NSMutableParagraphStyle()
        titleParagraphStyle.alignment = .center
        titleParagraphStyle.paragraphSpacing = 20
        
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: titleFont,
            .foregroundColor: titleColor,
            .paragraphStyle: titleParagraphStyle
        ]

        let titleString = NSMutableAttributedString(string: testTitle, attributes: titleAttributes)
        
        let bodyFont = UIFont.systemFont(ofSize: 15)
        let bodyColor = ColorCollection.bodyText
        let bodyParagraphStyle = NSMutableParagraphStyle()
        bodyParagraphStyle.lineSpacing = 7
        bodyParagraphStyle.paragraphSpacing = 14
        bodyParagraphStyle.firstLineHeadIndent = 2 * bodyFont.pointSize
        
        let bodyAttributes: [NSAttributedString.Key: Any] = [
            .font: bodyFont,
            .foregroundColor: bodyColor,
            .paragraphStyle: bodyParagraphStyle
//            .textEffect: NSAttributedString.TextEffectStyle.letterpressStyle
        ]

        let bodyString = NSMutableAttributedString(string: testBody, attributes: bodyAttributes)
        
        titleString.append(bodyString)
        
        articleField.attributedText = titleString
    }
}

extension CurrentTextVC: UITextViewDelegate {}
