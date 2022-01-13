//
//  TextViewTest.swift
//  观辞
//
//  Created by 张维熙 on 2021/12/27.
//

import Foundation
import UIKit

extension ViewController {
    func configureToolBar() {
        toolBarItems = UINavigationItem()
        toolBarItems.title = "Text"


        navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 44, width: view.frame.width, height: 100))

        view.addSubview(navigationBar)
    }


    func configureTestView() {
        documentView = UITextView(frame: CGRect(x: 0, y: 144, width: view.frame.width, height: view.frame.height))
        documentView.delegate = self
        documentView.font = .systemFont(ofSize: 20)
        documentView.text = "    我不知道首席法官是不是已把检察官和辩护律师双方的证人分成两摊，并且规定了召唤他们的程序。大概这一切是有的。我只知道他首先召唤的是检察官方面的证人。我要重复一句，我不打算一步步依次描写全部的审问过程。何况那样我的描述一部分会是重复多余的，因为在检察官和律师辩论时的演词里，所有提供和听取的证词的整个情况及其全部含意，将会仿佛都集中到一点上，加以鲜明而突出的说明的，这两段出色的演词我至少在许多部分都作了完整的记录，到时候自会向读者转述；此外还有一桩完全意料不到的非常事件我也记了下来，——这事还是在法庭的辩论开始以前突然发生的，对于这次审判的可怕而不祥的结局无疑发生了影响。我唯一要指出的是，这个案件有一种异常的特点，从开庭后最初的几分钟就鲜明地显示出来并被大家所觉察到了，那就是公诉方面的力量比起辩护方面所拥有的手段来，简直要强大得多。这一点，当各种事实在威严的法庭上集中聚拢起来，全部的恐怖和血腥渐渐地鲜明呈露出来的时候，大家一下子就感觉到了。也许仅仅只进行了最初的几步，大家就已开始明白，这简直是完全无可争辩的事情，这里面毫无疑义，实际上根本不必进行什么辩论，辩论只是走走形式，罪人是有罪的，显然有罪，完全有罪的。我甚至以为就连那些太太，尽管全体一致迫不及待地渴望着这个有趣的被告被宣告无罪，但同时却也完全深信他确实有罪。不但如此，我觉得，如果他的有罪不得到如此确切的证实，她们甚至要表示愤慨的，因为那样一来最后就不会有有罪的人被宣告无罪那样强烈的效果了。至于他将被宣告无罪这一点，奇怪的是所有的太太们，几乎直到最后一分钟还一直是完全深信不疑的，理由是：“他有罪，但是出于人道的动机，按照现在流行的新思想，新感情，他是会被宣告无罪的。”就因为这个，她们才那么急不可耐地纷纷聚集在这里。男子们最感兴趣的却是检察官和鼎鼎大名的费丘科维奇之间的斗争。大家奇怪，而且暗地问自己：对这样一件无望的案子，这样一个空蛋壳，即使费丘科维奇再有才干，还能干出什么来呢？因此他们全神贯注一步不漏地密切注视着他如何干这样一件大事。但是费丘科维奇直到最后起来发表他的那篇演词以前，在大家眼中始终显得象一个谜。有经验的人们预感到他自有一套，他已经拟定了什么计划，他眼前抱有一个目的，不过到底是什么样的目的，却简直无法猜到。但他的自信和自恃却是一目了然的。此外，大家立刻愉快地看出，他在逗留我们城里的极短时间内，也许只有三天工夫，竟能使人惊奇地把这案件弄得清清楚楚，并且“作了细致入微的研究”。例如，以后大家愉快地谈论，他怎样把所有检察官方面的证人及时地引“上钩”，尽可能地把他们窘住，主要的是给他们的道德名誉抹黑，这样自然也就给他们的证词抹了黑。不过大家以为，他这样做，大半是为了游戏，可以说是为了维持某种法律场面，表示丝毫也没有疏忽任何律师惯用的辩护手法，因为大家相信，用这类“抹黑”的办法并不能得到某种决定性的重大好处，这一点大概他自己比谁都明白，其实他一定心里还暗藏着某种想法，某种暂时还隐藏不露的辩护手段，只等时机一到，就会忽然把它拿出来。尽管这样，但由于他感到自己胸有成竹，所以暂时始终仿佛在那里游戏，闹着玩似的。所以，举例来说，当审问费多尔-巴夫洛维奇的贴身仆人格里戈里-瓦西里耶维奇，在他作关于“通花园的门是开着的”这一最有分量的证词的时候，一轮到律师发问，他就紧紧抓住不肯放松。应该指出的是格里戈里-瓦西里耶维奇一来到审判厅，并不因法庭庄严，旁听人数众多而露出一点点惊慌，他显出一副安然而且近乎庄重的神态。他作证时口气那么自信，简直好象是在同玛尔法-伊格纳奇耶芙娜私下里谈话，只是稍为恭敬些。把他难住是不可能的。检察官先长时间盘问他卡拉马佐夫家的详细情况。一幅家庭的图画鲜明地摆了出来。听得出，也看得出证人是直率而没有偏心的。尽管他对他去世的主人极为尊敬，但却仍然声称，比如说，主人对待米卡颇不公平，而且“不大关心教养儿子。这小孩如果没有我，会被虱子咬死的”，他在讲到米卡的儿童时代时候这样补充说。“父亲在母亲遗下来的祖传财产上欺瞒儿子，这也是不应该的。”检察官问，他有什么根据，可以证明费多尔-巴夫洛维奇在账目方面欺骗了儿子，使大家惊讶的是格里戈里-瓦西里耶维奇并没有提出任何切实的证据，但却坚持说，他和儿子所算的账是“不公平”的，他“应该补出几千卢布来”。顺便说一下，这个问题，——就是费多尔-巴夫洛维奇是否真的没付清米卡款项的问题，——检察官以后曾特别孜孜不倦地向所有可能知道的证人提了出来，连阿辽沙和伊凡-费多罗维奇也在内，但是没有从任何一个证人那里取得一点点确切的回答。大家全证实这事实，但没有人能提出一点点明显的证据。当格里戈里描述了正在吃饭的时候德米特里-费多罗维奇闯进来揍了父亲一顿，还威吓说要回来杀死他的那幕活剧时，全场的人都普遍产生了一种极坏的印象，尤其因为老仆人讲得口气平静，没有废话，用语别致，结果却显得极有说服力。至于米卡对他的冒犯，当时揍他的脸，把他打倒在地，他说他并不生气，早就原谅他了。对于去世的斯麦尔佳科夫，他一面画十字，一面表示他是一个能干的小伙子，只是傻里傻气，遭受病魔的折磨，尤其更坏的是，他是无神派，这是费多尔-巴夫洛维奇和他的大儿子教的。但对斯麦尔佳科夫的诚实不欺，他却几乎热烈地加以证实，立刻讲到，斯麦尔佳科夫有一次拣到主人掉下的钱，并没有藏起来，却交还给主人，主人因此“赏给他一个金币”，而且以后什么事情都很信任他了。关于通花园的门是开着的这一层，他用十分坚持的态度予以证实。他们盘问他的事情太多，我也不能全都记清楚了。最后由律师发问。他一开口就询问信封的事情，——就是“据信”费多尔-巴夫洛维奇曾把三千卢布藏在里面预备给“某一位太太”的那个信封。“您这个多年在您主人身边伺候的人，究竟亲眼看见过它没有？”格里戈里回答他没有看见，而且“直到大家纷纷谈论起它来之前”，也从没有听谁说起过关于这笔钱的话，关于信封的问题费丘科维奇也对证人中凡是可以询问的人都不断地提出来，就象检察官提出分产问题来一样，而从大家那里得到的也只有同样的回答，就是谁也没有看见过信封，尽管有许多人都听说过它。律师对于这个问题的坚持探询大家从一开始就看出来了。"
        view.addSubview(documentView)
    }
}
